import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LineupPlayer {
  final int?   number;
  final String name;
  final String position;
  const LineupPlayer({this.number, required this.name, required this.position});
}

class TeamLineup {
  final String             teamName;
  final List<LineupPlayer> starters; // posiciones 1-15
  final List<LineupPlayer> subs;     // posiciones 16-23
  const TeamLineup({required this.teamName, required this.starters, required this.subs});
}

class MatchLineup {
  final TeamLineup home;
  final TeamLineup away;
  const MatchLineup({required this.home, required this.away});
}

class EspnLineupService {
  static const _base = 'https://site.api.espn.com/apis/site/v2/sports/rugby';

  static const Map<String, int> _espnLeagueIds = {
    'Nations Championship': 17567,
    'Seis Naciones':        182527,
    'The Rugby Championship': 164205,
  };

  static bool supportsLineups(String league) => _espnLeagueIds.containsKey(league);

  Future<MatchLineup?> fetchLineup({
    required String league,
    required String homeTeam,
    required String awayTeam,
    required String date, // ISO 8601, ej: "2026-07-04T18:00:00+00:00"
  }) async {
    final leagueId = _espnLeagueIds[league];
    if (leagueId == null) return null;

    try {
      // Paso 1: buscar el evento ESPN por fecha y nombre de equipo
      final dateStr = date.substring(0, 10).replaceAll('-', ''); // YYYYMMDD
      final scoreboard = await _get('$_base/$leagueId/scoreboard?dates=$dateStr');

      final events = scoreboard['events'] as List<dynamic>? ?? [];
      int? eventId;

      for (final event in events) {
        final name = event['name'] as String? ?? '';
        if (name.contains(homeTeam) || name.contains(awayTeam)) {
          eventId = int.tryParse(event['id']?.toString() ?? '');
          break;
        }
      }

      if (eventId == null) {
        debugPrint('⚠ EspnLineupService: no se encontró evento para $homeTeam vs $awayTeam el $dateStr');
        return null;
      }

      // Paso 2: obtener rosters del summary
      final summary = await _get('$_base/$leagueId/summary?event=$eventId');
      final rosters  = summary['rosters'] as List<dynamic>? ?? [];
      if (rosters.length < 2) return null;

      TeamLineup parseRoster(dynamic data, int fallbackIdx) {
        final r        = data as Map<String, dynamic>;
        final teamName = r['team']?['displayName'] as String? ?? '';
        final players  = r['roster']  as List<dynamic>? ?? [];

        final starters = <LineupPlayer>[];
        final subs     = <LineupPlayer>[];

        for (int i = 0; i < players.length; i++) {
          final p   = players[i] as Map<String, dynamic>;
          final ath = p['athlete'] as Map<String, dynamic>?;
          final name = ath?['displayName'] as String? ?? '?';
          final pos  = p['position']?['displayName'] as String? ?? '';
          final num  = int.tryParse(p['jerseyNumber']?.toString() ?? '') ?? (i + 1);

          final player = LineupPlayer(number: num, name: name, position: pos);
          if (i < 15) { starters.add(player); } else { subs.add(player); }
        }

        return TeamLineup(teamName: teamName, starters: starters, subs: subs);
      }

      final homeData = rosters.firstWhere(
        (r) => (r as Map)['homeAway'] == 'home', orElse: () => rosters[0]);
      final awayData = rosters.firstWhere(
        (r) => (r as Map)['homeAway'] == 'away', orElse: () => rosters[1]);

      return MatchLineup(
        home: parseRoster(homeData, 0),
        away: parseRoster(awayData, 1),
      );
    } catch (e) {
      debugPrint('❌ EspnLineupService.fetchLineup: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> _get(String url) async {
    final resp = await http
        .get(Uri.parse(url), headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
    return json.decode(resp.body) as Map<String, dynamic>;
  }
}
