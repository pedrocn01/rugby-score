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
  // ── Segunda ────────────────────────────────────────────────────────────────
  'Segunda Superior':        2025180,
  'Segunda Intermedia':      2025196,
  // ── Tercera ────────────────────────────────────────────────────────────────
  'Tercera Superior':        2025181,
  'Tercera Intermedia':      2025199,
  // ── Desarrollo ─────────────────────────────────────────────────────────────
  'Desarrollo Superior':     2025182,
  'Desarrollo Intermedia':   2025207,
  // ── Femenino ───────────────────────────────────────────────────────────────
  'Femenino TOP 9':            2025208,
  'Femenino Primera División': 2025209,
  'Femenino Segunda División': 2025210,
  // ── M-19 ───────────────────────────────────────────────────────────────────
  'M-19 G1 A':                     2025224,
  'M-19 G1 B':                     2025225,
  'M-19 G1 Formativa A':           2025226,
  'M-19 G1 Formativa B':           2025229,
  'M-19 G1 Formativa C':           2025230,
  'M-19 G2 Nivel 1 A':             2025213,
  'M-19 G2 Nivel 1 A Eq B':        2025214,
  'M-19 G2 Nivel 1 B':             2025215,
  'M-19 G2 Nivel 1 B Eq B':        2025216,
  'M-19 G2 Nivel 2 C':             2025217,
  'M-19 G2 Nivel 2 C Eq B':        2025218,
  'M-19 G2 Nivel 2 D':             2025219,
  'M-19 G2 Nivel 2 D Eq B':        2025220,
  'M-19 G2 Nivel 2 Desarrollo':    2025227,
  'M-19 G2 Nivel 2 Desarrollo Eq B': 2025228,
  // ── M-17 ───────────────────────────────────────────────────────────────────
  'M-17 G2 Nivel 1 A':             2025231,
  'M-17 G2 Nivel 1 A Eq B':        2025232,
  'M-17 G2 Nivel 1 B':             2025233,
  'M-17 G2 Nivel 1 B Eq B':        2025234,
  'M-17 G2 Nivel 2 C':             2025235,
  'M-17 G2 Nivel 2 C Eq B':        2025236,
  'M-17 G1 A':                     2025237,
  'M-17 G1 B':                     2025238,
  'M-17 G1 C':                     2025239,
  'M-17 G1 Formativo A':           2025240,
  'M-17 G1 Formativo B':           2025241,
  'M-17 G1 Formativo C':           2025242,
  // ── M-16 ───────────────────────────────────────────────────────────────────
  'M-16 G2 Nivel 1 A':             2025243,
  'M-16 G2 Nivel 1 A Eq B':        2025244,
  'M-16 G2 Nivel 1 B':             2025245,
  'M-16 G2 Nivel 1 B Eq B':        2025246,
  'M-16 G2 Nivel 2 C':             2025247,
  'M-16 G2 Nivel 2 C Eq B':        2025248,
  'M-16 G2 Nivel 2 Desarrollo':    2025249,
  'M-16 G2 Nivel 2 Desarrollo Eq B': 2025250,
  'M-16 G1 A':                     2025251,
  'M-16 G1 B':                     2025252,
  'M-16 G1 Formativa A':           2025253,
  'M-16 G1 Formativa B':           2025254,
  // ── Universitario (CURUBA) ─────────────────────────────────────────────────
  'Rugby Universitario':           2025212,
  // ── M-15 ───────────────────────────────────────────────────────────────────
  'M-15 G2 Nivel 1 A':             2025255,
  'M-15 G2 Nivel 1 A Eq B':        2025256,
  'M-15 G2 Nivel 1 B':             2025257,
  'M-15 G2 Nivel 1 B Eq B':        2025258,
  'M-15 G2 Nivel 2 Desarrollo':    2025259,
  'M-15 G2 Nivel 2 Desarrollo Eq B': 2025260,
  'M-15 G1 A':                     2025261,
  'M-15 G1 B':                     2025262,
  'M-15 G1 Formativa A':           2025263,
  'M-15 G1 Formativa B':           2025264,
};

// ─── Clasificación de la tabla por liga ──────────────────────────────────────
//
// URBA Top 14 : 4 Playoffs · 2 descensos directos
// URBA Primera A/B/C: 1 Ascenso directo · pos 2-5 Playoff de ascenso · 2 descensos
const Set<String> urbaTop14Leagues = {'URBA Top 14'};
const Set<String> urbaFirstLeagues = {
  'URBA Primera A', 'URBA Primera B', 'URBA Primera C',
  'Segunda Superior', 'Segunda Intermedia',
  'Tercera Superior', 'Tercera Intermedia',
  'Desarrollo Superior', 'Desarrollo Intermedia',
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
        'points':          p['points_total']    ?? 0,
        'bonus_offensive': p['bonus_offensive'] ?? 0,
        'bonus_defensive': p['bonus_defensive'] ?? 0,
        'points_favor':    p['points_favor']    ?? 0,
        'points_against':  p['points_against']  ?? 0,
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

    final allMatches = results.expand((m) => m).toList();

    // Inyectar horarios reales para URBA Top 14:
    // las 3 primeras fechas pendientes juegan a las 14:00, el resto a las 15:30.
    if (leagueName == 'URBA Top 14') {
      return _injectUrbaKickoffTimes(allMatches);
    }

    return allMatches;
  }

  List<dynamic> _injectUrbaKickoffTimes(List<dynamic> matches) {
    // Obtener fechas únicas de partidos NS (pendientes), ordenadas
    final pendingDates = matches
        .where((m) => m['status']?['short'] == 'NS')
        .map((m) => (m['date'] as String? ?? '').substring(0, 10))
        .where((d) => d.length == 10)
        .toSet()
        .toList()
      ..sort();

    final first3 = pendingDates.take(3).toSet();

    return matches.map<dynamic>((m) {
      if (m['status']?['short'] != 'NS') return m;
      final rawDate = (m['date'] as String? ?? '');
      final dateOnly = rawDate.length >= 10 ? rawDate.substring(0, 10) : '';
      if (dateOnly.isEmpty) return m;

      final time    = first3.contains(dateOnly) ? '14:00:00' : '15:30:00';
      final newDate = '${dateOnly}T$time-03:00';
      final dt      = DateTime.tryParse(newDate);

      return <String, dynamic>{
        ...Map<String, dynamic>.from(m as Map),
        'date':      newDate,
        'timestamp': dt != null ? dt.millisecondsSinceEpoch ~/ 1000 : m['timestamp'],
      };
    }).toList();
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
