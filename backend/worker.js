/**
 * Rugby Score — Cloudflare Worker proxy con cache inteligente
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │  La API key de api-sports NUNCA llega al navegador del usuario. │
 * │  El Worker la inyecta acá, del lado del servidor.               │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ── Estrategia de cache ───────────────────────────────────────────
 *
 *  /standings → siempre 24 horas.
 *    La tabla de posiciones solo cambia al terminar una fecha completa.
 *    No tiene sentido refrescarla cada 10 minutos un sábado.
 *
 *  /games (inteligente según estado de partidos):
 *    · Partido en vivo            →  2 minutos
 *    · Partido arranca en < 30min →  5 minutos
 *    · Partido reciente sin FT    →  5 minutos  (API tarda en actualizar)
 *    · Sin partidos activos       → 24 horas    ← clave: evita requests innecesarios
 *
 *  Con esto, una liga sin partidos hoy NO gasta requests,
 *  independientemente del día de la semana.
 *
 * ── Seguridad ────────────────────────────────────────────────────
 *
 *  Todos los requests deben incluir el header X-App-Secret con el
 *  valor configurado como secreto en Cloudflare (APP_SECRET).
 *  Si APP_SECRET no está configurado, el Worker permite todo
 *  (modo desarrollo/migración).
 *
 * ── Setup ────────────────────────────────────────────────────────
 *
 *  1. npm install -g wrangler
 *  2. wrangler login
 *  3. wrangler secret put API_KEY      ← key de api-sports.io
 *  4. wrangler secret put APP_SECRET   ← string aleatorio largo, mismo
 *                                         que --dart-define=APP_SECRET=
 *  5. wrangler deploy                  ← devuelve la URL del Worker
 *
 *  Build Flutter producción:
 *    flutter build web --release \
 *      --dart-define=API_BASE_URL=https://rugby-proxy.TU_SUBDOMAIN.workers.dev \
 *      --dart-define=API_KEY= \
 *      --dart-define=APP_SECRET=el_mismo_string_del_paso_4
 */

const PROXY_ENDPOINTS = ['games', 'standings'];
const API_ORIGIN      = 'https://v1.rugby.api-sports.io';

// TTL base para cualquier respuesta sin partidos activos
const BASE_TTL = 24 * 60 * 60; // 24 horas

// ── TTL inteligente para /games ───────────────────────────────────────────────
// Solo refresca rápido cuando hay partidos activos o por comenzar.
// Si no hay nada activo → 24h, sin importar el día de la semana.
function getGamesTTL(body) {
  try {
    const data = JSON.parse(body);
    if (!Array.isArray(data.response)) return BASE_TTL;

    const now             = Date.now();
    const liveStatuses     = new Set(['1H', '2H', 'HT', 'ET', 'BT', 'P']);
    const finishedStatuses = new Set(['FT', 'AET', 'PEN', 'Canc', 'AWD', 'Susp', 'ABD']);

    for (const game of data.response) {
      const status    = game.status?.short ?? '';
      const gameStart = new Date(game.date || 0).getTime();
      const msSince   = now - gameStart;
      const msUntil   = gameStart - now;

      // Partido en vivo → 2 minutos
      if (liveStatuses.has(status)) return 2 * 60;

      // Partido arranca en menos de 30 min → 5 minutos
      if (!finishedStatuses.has(status) && msUntil >= 0 && msUntil < 30 * 60 * 1000)
        return 5 * 60;

      // Partido no terminado que empezó hace menos de 3h (la API puede tardar
      // en actualizar el estado, el partido puede seguir en juego)
      if (!finishedStatuses.has(status) && msSince >= 0 && msSince < 3 * 60 * 60 * 1000)
        return 5 * 60;
    }

    // Sin partidos activos → 24 horas (no gastar requests)
    return BASE_TTL;
  } catch {
    return BASE_TTL;
  }
}

// ── Detecta errores en respuesta de api-sports ────────────────────────────────
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

// ── Validación de seguridad ────────────────────────────────────────────────────
// Verifica que el request viene de la app y no de un scraper externo.
// Usa el secreto APP_SECRET configurado en Cloudflare.
// Si APP_SECRET no está configurado → permite todo (modo dev/migración).
function isAuthorized(request, env) {
  const secret = env.APP_SECRET;
  if (!secret) return true; // no configurado → modo desarrollo
  return request.headers.get('X-App-Secret') === secret;
}

// ── Validación del scraper Python (token secreto, diferente al del app) ────────
// Si LIVE_SECRET_TOKEN no está configurado, rechaza todo (falla segura).
function isScraperAuthorized(request, env) {
  const token = env.LIVE_SECRET_TOKEN;
  if (!token) return false;
  return request.headers.get('X-Secret-Token') === token;
}

// ── Handler principal ──────────────────────────────────────────────────────────
export default {
  async fetch(request, env) {

    // Preflight CORS
    if (request.method === 'OPTIONS') {
      return corsResponse('', 204);
    }

    const url      = new URL(request.url);
    const endpoint = url.pathname.replace(/^\/+/, '');

    // ── /urba-live: datos en vivo del URBA Top 14 guardados en KV ─────────
    //   GET → la app Flutter lee los datos (requiere X-App-Secret)
    //   PUT → el scraper Python escribe los datos (requiere X-Secret-Token)
    if (endpoint === 'urba-live') {
      if (request.method === 'GET') {
        if (!isAuthorized(request, env)) {
          return corsResponse(JSON.stringify({ error: 'No autorizado' }), 403);
        }
        const data = await env.RUGBY_LIVE.get('urba_live_data');
        if (!data) return corsResponse(JSON.stringify({ matches: [] }), 200);
        return corsResponse(data, 200);
      }
      if (request.method === 'PUT') {
        if (!isScraperAuthorized(request, env)) {
          return corsResponse(JSON.stringify({ error: 'No autorizado' }), 403);
        }
        const body = await request.text();
        await env.RUGBY_LIVE.put('urba_live_data', body);
        return corsResponse(JSON.stringify({ ok: true }), 200);
      }
      return corsResponse(JSON.stringify({ error: 'Método no permitido' }), 405);
    }

    // ── Proxy a api-sports (games, standings) ─────────────────────────────
    if (request.method !== 'GET') {
      return corsResponse(JSON.stringify({ error: 'Método no permitido' }), 405);
    }

    // Validar que el request viene de la app
    if (!isAuthorized(request, env)) {
      return corsResponse(JSON.stringify({ error: 'No autorizado' }), 403);
    }

    if (!PROXY_ENDPOINTS.includes(endpoint)) {
      return corsResponse(JSON.stringify({ error: 'Endpoint no permitido' }), 403);
    }

    // ── Intentar servir desde cache ────────────────────────────────────────
    const forceRefresh = request.headers.get('X-Force-Fresh') === '1';
    const cache        = caches.default;
    const cacheKey     = request.url;

    if (!forceRefresh) {
      const cached = await cache.match(cacheKey);
      if (cached) {
        return addCorsHeaders(cached, 'HIT');
      }
    }

    // ── Cache MISS: llamar a la API ────────────────────────────────────────
    const apiUrl  = `${API_ORIGIN}/${endpoint}${url.search}`;
    const apiResp = await fetch(apiUrl, {
      headers: {
        'x-apisports-key': env.API_KEY,
        'Accept':          'application/json',
      },
    });

    const body = await apiResp.text();

    // TTL según endpoint: standings siempre 24h, games según estado de partidos
    const ttl = endpoint === 'standings' ? BASE_TTL : getGamesTTL(body);

    const response = new Response(body, {
      status:  apiResp.status,
      headers: {
        'Content-Type':                 'application/json',
        'Cache-Control':                `public, max-age=${ttl}`,
        'Access-Control-Allow-Origin':  '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, x-apisports-key, X-Force-Fresh, X-App-Secret',
        'X-Cache':                      'MISS',
        'X-Cache-TTL':                  `${ttl}s`,
      },
    });

    // Cachear solo si la API respondió OK y sin errores en el cuerpo
    if (apiResp.ok && !hasApiErrors(body)) {
      await cache.put(cacheKey, response.clone());
    }

    return response;
  },
};

// ── Helpers ────────────────────────────────────────────────────────────────────

function corsResponse(body, status = 200) {
  return new Response(body, {
    status,
    headers: {
      'Content-Type':                 'application/json',
      'Access-Control-Allow-Origin':  '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, x-apisports-key, X-Force-Fresh, X-App-Secret',
    },
  });
}

function addCorsHeaders(response, cacheStatus) {
  const headers = new Headers(response.headers);
  headers.set('Access-Control-Allow-Origin', '*');
  headers.set('X-Cache', cacheStatus);
  return new Response(response.body, { status: response.status, headers });
}
