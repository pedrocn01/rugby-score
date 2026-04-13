import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── IDs de campeonatos URBA por temporada ───────────────────────────────────
// Actualizar cuando cambie la temporada (buscar en /api/championships/{year})

const Map<String, int> urbaChampionshipIds = {
  'URBA Top 14':    2025176,
  'URBA Primera A': 2025177,
  'URBA Primera B': 2025178,
  'URBA Primera C': 2025179,
};

// ─── Cuántos equipos clasifican a playoffs por liga ──────────────────────────
const Map<String, int> urbaPlayoffSpots = {
  'URBA Top 14':    4,
  'URBA Primera A': 4,
  'URBA Primera B': 4,
  'URBA Primera C': 4,
};

class UrbaService {
  static const _base = 'https://api.urba.org.ar/api';
  static const _headers = {'Accept': 'application/json'};

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

    final playoffSpots = urbaPlayoffSpots[leagueName] ?? 4;
    final total        = positions.length;

    return positions.map<dynamic>((p) {
      final pos      = p['position'] as int;
      final clubName = p['team']?['club']?['name'] as String?
                    ?? p['team']?['name'] as String?
                    ?? '?';
      String? description;
      if (pos <= playoffSpots) {
        description = 'Playoffs';
      } else if (pos == total - 1) {
        description = 'Relegation Playoffs';
      } else if (pos == total) {
        description = 'Relegation';
      }

      return {
        'position': pos,
        'team':     {'name': clubName},
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

    return results.expand((m) => m).toList();
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
      final homeName  = m['local_team']?['club']?['name'] as String?
                     ?? m['local_team']?['name'] as String?
                     ?? '?';
      final awayName  = m['visit_team']?['club']?['name'] as String?
                     ?? m['visit_team']?['name'] as String?
                     ?? '?';
      final dateStr   = m['playdate'] as String? ?? round['playdate'] as String? ?? '';

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
          'home': {'name': homeName, 'logo': null},
          'away': {'name': awayName, 'logo': null},
        },
      };
    }).toList();
  }
}
