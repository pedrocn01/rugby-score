import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EspnService {
  static const _base = 'https://site.web.api.espn.com/apis/v2/sports/rugby';

  static const Map<String, int> _leagueIds = {
    'Super Rugby Pacific': 242041,
  };

  static const Map<String, int> _seasons = {
    'Super Rugby Pacific': 2026,
  };

  // Nombres que ESPN devuelve distintos a los que usamos en logos.dart
  static const Map<String, String> _nameNormalization = {
    'New South Wales Waratahs': 'Waratahs',
    'Queensland Reds':          'Reds',
  };

  Future<List<List<dynamic>>> fetchStandings(String leagueName) async {
    final leagueId = _leagueIds[leagueName];
    final season   = _seasons[leagueName] ?? DateTime.now().year;
    if (leagueId == null) return [];

    try {
      final uri = Uri.parse(
        '$_base/$leagueId/standings?region=us&lang=en&season=$season&seasontype=1&type=0',
      );
      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final data     = json.decode(response.body);
      final children = data['children'] as List<dynamic>?;
      if (children == null || children.isEmpty) return [];

      final entries = children[0]['standings']?['entries'] as List<dynamic>?;
      if (entries == null || entries.isEmpty) return [];

      double sv(List<dynamic> stats, String name) {
        final s = stats.firstWhere(
          (s) => s['name'] == name,
          orElse: () => <String, dynamic>{},
        );
        return (s['value'] as num?)?.toDouble() ?? 0.0;
      }

      final rows = entries.map((e) {
        final team  = e['team'] as Map<String, dynamic>;
        final stats = e['stats'] as List<dynamic>;

        final rawName = team['displayName'] as String? ?? team['name'] as String? ?? '';
        final name    = _nameNormalization[rawName] ?? rawName;
        final logos   = team['logos'] as List<dynamic>?;
        final logoUrl = (logos != null && logos.isNotEmpty)
            ? logos[0]['href'] as String?
            : null;

        return <String, dynamic>{
          'position': sv(stats, 'rank').toInt(),
          'team': {'name': name, 'logo': logoUrl},
          'games': {
            'played': sv(stats, 'gamesPlayed').toInt(),
            'win':    {'total': sv(stats, 'gamesWon').toInt()},
            'draw':   {'total': sv(stats, 'gamesDrawn').toInt()},
            'lose':   {'total': sv(stats, 'gamesLost').toInt()},
          },
          'points':      sv(stats, 'points').toInt(),
          'description': null,
        };
      }).toList()
        ..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));

      return [rows];
    } catch (e) {
      debugPrint('❌ EspnService.fetchStandings($leagueName): $e');
      return [];
    }
  }
}
