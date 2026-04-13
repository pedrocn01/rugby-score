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

  /// Descarga las posiciones de un campeonato URBA y las convierte al
  /// formato estándar de la app (igual al que devuelve api-sports.io).
  Future<List<dynamic>> fetchStandings(String leagueName) async {
    final champId = urbaChampionshipIds[leagueName];
    if (champId == null) throw Exception('UrbaService: liga desconocida "$leagueName"');

    final uri = Uri.parse('$_base/positions/$champId');
    final res  = await http.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) throw Exception('URBA API error ${res.statusCode}');

    final data      = jsonDecode(res.body) as Map<String, dynamic>;
    final positions = (data['positions'] as List<dynamic>?) ?? [];

    positions.sort((a, b) =>
        (a['position'] as int).compareTo(b['position'] as int));

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
      } else if (pos == total) {
        // último → desciende o juega promoción (según el torneo)
        description = 'Relegation';
      } else if (pos == total - 1) {
        description = 'Relegation Playoffs';
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
}
