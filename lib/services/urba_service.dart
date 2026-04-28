import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── IDs de campeonatos URBA por temporada ───────────────────────────────────
// Actualizar cuando cambie la temporada (buscar en /api/championships/{year})

const Map<String, int> urbaChampionshipIds = {
  'URBA Top 14':             2025176,
  'URBA Primera A':          2025177,
  'URBA Primera B':          2025178,
  'URBA Primera C':          2025179,
  'TOP 14 Intermedia':       2025184,
  'TOP 14 Pre-Intermedia A': 2025185,
  'TOP 14 Pre-Intermedia B': 2025186,
  'TOP 14 Pre-Intermedia C': 2025197,
  'TOP 14 Pre-Intermedia D': 2025198,
  'TOP 14 Pre-Intermedia E': 2025200,
  'TOP 14 Pre-Intermedia F': 2025201,
  'TOP 14 M-22':             2025206,
  // ── Primera A ──────────────────────────────────────────────────────────────
  '1A Intermedia':           2025187,
  '1A Pre-Intermedia':       2025188,
  '1A Pre-Intermedia B':     2025189,
  '1A Pre-Intermedia C':     2025202,
  '1A Pre-Intermedia D':     2025203,
  // ── Primera B ──────────────────────────────────────────────────────────────
  '1B Intermedia':           2025190,
  '1B Pre-Intermedia':       2025191,
  '1B Pre-Intermedia B':     2025192,
  '1B Pre-Intermedia C':     2025204,
  // ── Primera C ──────────────────────────────────────────────────────────────
  '1C Intermedia':           2025193,
  '1C Pre-Intermedia':       2025195,
  '1C Pre-Intermedia B':     2025205,
};

// ─── Clasificación de la tabla por liga ──────────────────────────────────────
//
// URBA Top 14 : 4 Playoffs · 2 descensos directos
// URBA Primera A/B/C: 1 Ascenso directo · pos 2-5 Playoff de ascenso · 2 descensos
const Set<String> urbaTop14Leagues = {'URBA Top 14'};
const Set<String> urbaFirstLeagues = {'URBA Primera A', 'URBA Primera B', 'URBA Primera C'};

class UrbaService {
  static const _base = 'https://api.urba.org.ar/api';
  static const _headers = {'Accept': 'application/json'};

  // URL del Worker de Cloudflare (misma variable que usa RugbyService).
  // En desarrollo apunta a api-sports directamente → /urba-live no existe → ignorado.
  static const _workerBase = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const _appSecret  = String.fromEnvironment('APP_SECRET',   defaultValue: '');

  // ── Tabla de posiciones ───────────────────────────────────────────────────

  Future<List<dynamic>> fetchStandings(String leagueName) async {
    final champId = urbaChampionshipIds[leagueName];
    if (champId == null) throw Exception('UrbaService: liga desconocida "$leagueName"');

    final res = await http.get(
      Uri.parse('$_base/positions/$champId'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('URBA API error ${res.statusCode}');

    final positions = ((jsonDecode(res.body)['positions']) as List<dynamic>? ?? [])
      ..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));

    final total = positions.length;

    return positions.map<dynamic>((p) {
      final pos      = p['position'] as int;
      final clubName = p['team']?['name'] as String?
                    ?? p['team']?['club']?['name'] as String?
                    ?? '?';
      String? description;
      if (urbaTop14Leagues.contains(leagueName)) {
        if (pos <= 4) {
          description = 'Playoffs';
        } else if (pos >= total - 1) {
          description = 'Relegation';
        }
      } else if (urbaFirstLeagues.contains(leagueName)) {
        if (pos == 1) {
          description = 'Qualified';
        } else if (pos <= 5) {
          description = 'Relegation Playoffs';
        } else if (pos >= total - 1) {
          description = 'Relegation';
        }
      }

      final imageUri = p['team']?['club']?['image_uri'] as String?;
      final logoUrl  = imageUri != null ? 'https://api.urba.org.ar/$imageUri' : null;

      return {
        'position': pos,
        'team':     {'name': clubName, 'logo': logoUrl},
        'games': {
          'played': p['played'] ?? 0,
          'win':    {'total': p['won']  ?? 0},
          'draw':   {'total': p['tied'] ?? 0},
          'lose':   {'total': p['lost'] ?? 0},
        },
        'points':      p['points_total'] ?? 0,
        'description': description,
      };
    }).toList();
  }

  // ── Partidos (todas las fechas en paralelo) ───────────────────────────────

  Future<List<dynamic>> fetchMatches(String leagueName) async {
    final champId = urbaChampionshipIds[leagueName];
    if (champId == null) throw Exception('UrbaService: liga desconocida "$leagueName"');

    // Para URBA Top 14 iniciamos el fetch de datos en vivo en paralelo con
    // la descarga de fechas, sin que afecte el resto de divisiones.
    final liveFuture = leagueName == 'URBA Top 14'
        ? fetchLiveTop14()
        : Future<List<dynamic>?>.value(null);

    // 1. Obtener todas las fechas del campeonato
    final champRes = await http.get(
      Uri.parse('$_base/championship/$champId?include=rounds'),
      headers: _headers,
    );
    if (champRes.statusCode != 200) throw Exception('URBA API error ${champRes.statusCode}');

    final champData    = jsonDecode(champRes.body) as Map<String, dynamic>;
    final championship = ((champData['championship'] as List?)?.firstOrNull) as Map?;
    final rounds       = (championship?['rounds'] as List<dynamic>?) ?? [];

    if (rounds.isEmpty) return [];

    // 2. Descargar todas las fechas en paralelo
    final results = await Future.wait(
      rounds.map((r) => _fetchRound(r).catchError((_) => <dynamic>[])),
    );

    final allMatches = results.expand((m) => m).toList();

    // 3. Overlay en vivo — SOLO para URBA Top 14
    final liveData = await liveFuture;
    if (liveData != null && liveData.isNotEmpty) {
      _applyLiveOverlay(allMatches, liveData);
    }

    return allMatches;
  }

  // Llama a GET /urba-live en el Worker y devuelve la lista de partidos.
  // Retorna null ante cualquier error (falla silenciosa → se usan datos de URBA API).
  // Método público para que MatchCache pueda inyectar partidos en vivo en "En Vivo".
  Future<List<dynamic>?> fetchLiveTop14() async {
    // Solo consultar el Worker los sábados — evita requests innecesarios el resto de la semana.
    if (DateTime.now().weekday != DateTime.saturday) return null;
    // En desarrollo API_BASE_URL apunta a api-sports → no tiene /urba-live → ignorar.
    if (_workerBase.isEmpty || _workerBase.contains('api-sports')) return null;
    try {
      final res = await http.get(
        Uri.parse('$_workerBase/urba-live'),
        headers: {
          'Accept': 'application/json',
          if (_appSecret.isNotEmpty) 'X-App-Secret': _appSecret,
        },
      ).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) return null;

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      // Ignorar datos con más de 4 horas de antigüedad (evita mostrar
      // scores del sábado pasado como si fueran en vivo).
      final updatedAt = DateTime.tryParse(body['updated_at'] as String? ?? '');
      if (updatedAt == null) return null;
      if (DateTime.now().toUtc().difference(updatedAt).inHours >= 4) return null;

      return body['matches'] as List<dynamic>?;
    } catch (_) {
      return null;
    }
  }

  // Sobrescribe status y scores de los partidos de la API con los datos en vivo.
  // La coincidencia es por nombre de equipo local + visitante.
  void _applyLiveOverlay(List<dynamic> matches, List<dynamic> liveMatches) {
    for (final live in liveMatches) {
      final lh = (live['teams']?['home']?['name'] as String? ?? '').toLowerCase().trim();
      final la = (live['teams']?['away']?['name'] as String? ?? '').toLowerCase().trim();
      if (lh.isEmpty || la.isEmpty) continue;

      for (int i = 0; i < matches.length; i++) {
        final m  = matches[i] as Map;
        final mh = (m['teams']?['home']?['name'] as String? ?? '').toLowerCase().trim();
        final ma = (m['teams']?['away']?['name'] as String? ?? '').toLowerCase().trim();
        if (mh == lh && ma == la) {
          matches[i] = Map<String, dynamic>.from(m)
            ..['status'] = live['status']
            ..['scores'] = live['scores'];
          break;
        }
      }
    }
  }

  Future<List<dynamic>> _fetchRound(dynamic round) async {
    final roundId   = round['id']   as int;
    final roundName = round['name'] as String;

    final res = await http.get(
      Uri.parse('$_base/round/$roundId'),
      headers: _headers,
    );
    if (res.statusCode != 200) return [];

    final matches = ((jsonDecode(res.body)['round']?['matches']) as List<dynamic>?) ?? [];

    return matches.map<dynamic>((m) {
      final fulfilled = m['fulfilled'] as bool? ?? false;
      final suspended = m['suspended'] as bool? ?? false;
      final homeScore = m['local_team_score'] as int?;
      final awayScore = m['visit_team_score'] as int?;
      final homeName    = m['local_team']?['name'] as String?
                       ?? m['local_team']?['club']?['name'] as String?
                       ?? '?';
      final awayName    = m['visit_team']?['name'] as String?
                       ?? m['visit_team']?['club']?['name'] as String?
                       ?? '?';
      final homeImgUri  = m['local_team']?['club']?['image_uri'] as String?;
      final awayImgUri  = m['visit_team']?['club']?['image_uri'] as String?;
      final homeLogo    = homeImgUri != null ? 'https://api.urba.org.ar/$homeImgUri' : null;
      final awayLogo    = awayImgUri != null ? 'https://api.urba.org.ar/$awayImgUri' : null;
      final dateStr     = m['playdate'] as String? ?? round['playdate'] as String? ?? '';

      // Convertir playdate a timestamp Unix para ordenamiento
      final dt        = DateTime.tryParse(dateStr);
      final timestamp = dt != null ? dt.millisecondsSinceEpoch ~/ 1000 : 0;

      final statusShort = suspended
          ? 'Canc'
          : (fulfilled ? 'FT' : 'NS');

      return {
        'date':      dateStr,
        'timestamp': timestamp,
        'week':      roundName,
        'status':    {'short': statusShort, 'long': statusShort},
        'scores': {
          'home': fulfilled ? homeScore : null,
          'away': fulfilled ? awayScore : null,
        },
        'teams': {
          'home': {'name': homeName, 'logo': homeLogo},
          'away': {'name': awayName, 'logo': awayLogo},
        },
      };
    }).toList();
  }
}
