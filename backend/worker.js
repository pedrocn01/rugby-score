/**
 * Rugby Score — Cloudflare Worker proxy con cache inteligente
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │  La API key NUNCA llega al navegador del usuario.               │
 * │  El Worker la inyecta acá, del lado del servidor.               │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Endpoints expuestos:
 *   GET /games?league=XX&season=XXXX
 *   GET /standings?league=XX&season=XXXX
 *
 * Estrategia de cache (Cloudflare edge cache, gratis):
 *   Mar–Jue  → 24 horas   (no hay partidos, los datos no cambian)
 *   Vie–Dom  →  10 min    (días de partido, datos frescos)
 *   Lun      →  1 hora    (resultados del fin de semana ya fijos)
 *
 *   Con esto, 7.500 requests/día alcanzan para usuarios ilimitados:
 *   la API solo se consulta cuando el cache vence, no por cada usuario.
 *
 * Setup (una sola vez):
 *   1. npm install -g wrangler
 *   2. wrangler login
 *   3. wrangler secret put API_KEY    ← pegá tu key de api-sports.io
 *   4. wrangler deploy                ← te da la URL del Worker
 *
 * Build Flutter producción:
 *   flutter build web --release \
 *     --dart-define=API_BASE_URL=https://rugby-proxy.TU_USUARIO.workers.dev \
 *     --dart-define=API_KEY=
 */

const ALLOWED_ENDPOINTS = ['games', 'standings'];
const API_ORIGIN        = 'https://v1.rugby.api-sports.io';

// ── TTL base según día de la semana ──────────────────────────────────────
function getBaseTTL() {
  const day = new Date().getUTCDay();
  if (day === 5 || day === 6 || day === 0) return 10 * 60;   // Vie/Sáb/Dom → 10 min
  if (day === 1)                            return 60 * 60;   // Lun → 1 hora
  if (day === 4)                            return 30 * 60;   // Jue → 30 min
  return 24 * 60 * 60;                                        // Mar/Mié → 24 horas
}

// ── TTL inteligente: si hay partidos activos HOY, usar 5 min ─────────────
function getSmartTTL(body) {
  try {
    const data = JSON.parse(body);
    if (!Array.isArray(data.response)) return getBaseTTL();

    const now  = Date.now();
    const liveStatuses     = new Set(['1H', '2H', 'HT', 'ET', 'BT', 'P']);
    const finishedStatuses = new Set(['FT', 'AET', 'PEN', 'Canc', 'AWD', 'Susp', 'ABD']);

    for (const game of data.response) {
      const status    = game.status?.short ?? '';
      const gameStart = new Date(game.date || 0).getTime();
      const msSince   = now - gameStart;
      const msUntil   = gameStart - now;

      // Partido en vivo → 2 minutos
      if (liveStatuses.has(status)) return 2 * 60;

      // Partido que arranca en menos de 30 min → 5 minutos
      if (!finishedStatuses.has(status) && msUntil >= 0 && msUntil < 30 * 60 * 1000)
        return 5 * 60;

      // Partido no terminado que empezó hace menos de 3h (puede estar en juego aunque
      // la API todavía no actualizó el estado, o es una partida que cruzó medianoche UTC)
      if (!finishedStatuses.has(status) && msSince >= 0 && msSince < 3 * 60 * 60 * 1000)
        return 5 * 60;
    }

    return getBaseTTL();
  } catch {
    return getBaseTTL();
  }
}

// ── Handler principal ─────────────────────────────────────────────────────
export default {
  async fetch(request, env) {

    // Preflight CORS
    if (request.method === 'OPTIONS') {
      return corsResponse('', 204);
    }

    if (request.method !== 'GET') {
      return corsResponse(JSON.stringify({ error: 'Método no permitido' }), 405);
    }

    const url      = new URL(request.url);
    const endpoint = url.pathname.replace(/^\/+/, '');

    if (!ALLOWED_ENDPOINTS.includes(endpoint)) {
      return corsResponse(JSON.stringify({ error: 'Endpoint no permitido' }), 403);
    }

    // ── Intentar servir desde cache ───────────────────────────────────────
    const forceRefresh = request.headers.get('X-Force-Fresh') === '1';
    const cache     = caches.default;
    const cacheKey  = request.url;          // URL completa como clave

    if (!forceRefresh) {
      const cached = await cache.match(cacheKey);
      if (cached) {
        // Cache HIT: devolver sin tocar la API
        return addCorsHeaders(cached, 'HIT');
      }
    }

    // ── Cache MISS: llamar a la API ───────────────────────────────────────
    const apiUrl  = `${API_ORIGIN}/${endpoint}${url.search}`;
    const apiResp = await fetch(apiUrl, {
      headers: {
        'x-apisports-key': env.API_KEY,
        'Accept':          'application/json',
      },
    });

    const body = await apiResp.text();
    const ttl  = getSmartTTL(body);

    const response = new Response(body, {
      status:  apiResp.status,
      headers: {
        'Content-Type':                 'application/json',
        'Cache-Control':                `public, max-age=${ttl}`,
        'Access-Control-Allow-Origin':  '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, x-apisports-key, X-Force-Fresh',
        'X-Cache':                      'MISS',
        'X-Cache-TTL':                  `${ttl}s`,
      },
    });

    // Guardar en cache solo si la API respondió OK Y sin errores en el cuerpo.
    // api-sports devuelve HTTP 200 incluso para errores (ej: rate limit excedido),
    // con { "errors": { "requests": "..." }, "response": [] }.
    // Si cacheamos eso, todos los usuarios ven resultados vacíos hasta que el cache expire.
    if (apiResp.ok && !hasApiErrors(body)) {
      await cache.put(cacheKey, response.clone());
    }

    return response;
  },
};

// ── Detecta errores en respuesta de api-sports ───────────────────────────────
// api-sports devuelve HTTP 200 con { "errors": {...}, "response": [] } cuando
// se alcanza el límite diario u ocurre otro error interno. No cachear eso.
function hasApiErrors(bodyText) {
  try {
    const errors = JSON.parse(bodyText)?.errors;
    return errors && !Array.isArray(errors) && Object.keys(errors).length > 0;
  } catch {
    return false;
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────

function corsResponse(body, status = 200) {
  return new Response(body, {
    status,
    headers: {
      'Content-Type':                 'application/json',
      'Access-Control-Allow-Origin':  '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, x-apisports-key, X-Force-Fresh',
    },
  });
}

// Agrega CORS a una respuesta cacheada (que ya los tiene, pero por si acaso)
function addCorsHeaders(response, cacheStatus) {
  const headers = new Headers(response.headers);
  headers.set('Access-Control-Allow-Origin', '*');
  headers.set('X-Cache', cacheStatus);
  return new Response(response.body, { status: response.status, headers });
}
