import 'package:flutter/foundation.dart';
import '../config/leagues.dart';
import 'rugby_service.dart';

class MatchEntry {
  final String league;
  final dynamic match;
  MatchEntry({required this.league, required this.match});
}

/// Cache en memoria compartido entre Próximos y En Vivo.
class MatchCache {
  MatchCache._();
  static final MatchCache instance = MatchCache._();

  final Map<String, List<dynamic>> _data = {};
  DateTime? _lastFetch;
  bool _loading = false;

  static const _ttl = Duration(minutes: 10);

  bool get _isStale =>
      _lastFetch == null || DateTime.now().difference(_lastFetch!) > _ttl;

  Future<Map<String, List<dynamic>>> fetchAll({bool force = false}) async {
    if (!force && !_isStale && _data.isNotEmpty) return Map.unmodifiable(_data);

    if (_loading) {
      while (_loading) {
        await Future<void>.delayed(const Duration(milliseconds: 150));
      }
      return Map.unmodifiable(_data);
    }

    _loading = true;
    try {
      final service = RugbyService();
      final entries = leagueIds.entries
          .where((e) => e.value > 0 && !staticLeagues.contains(e.key))
          .toList();

      final results = await Future.wait(
        entries.map((e) => service
            .fetchMatches(e.value, noCache: force)
            .then<List<dynamic>?>((data) => data)
            .catchError((err) {
              debugPrint('❌ MatchCache: error cargando ${e.key}: $err');
              return null;
            })),
      );

      for (int i = 0; i < entries.length; i++) {
        final result = results[i];
        if (result != null) {
          _data[entries[i].key] = result;
        }
      }
      _lastFetch = DateTime.now();
    } finally {
      _loading = false;
    }
    return Map.unmodifiable(_data);
  }

  /// Partidos actualmente en vivo (1H, HT, 2H, ET, BT, P)
  List<MatchEntry> getLive() {
    const liveStatuses = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};
    final result = <MatchEntry>[];
    for (final entry in _data.entries) {
      for (final m in entry.value) {
        final s = m['status']?['short'] as String? ?? '';
        if (liveStatuses.contains(s)) {
          result.add(MatchEntry(league: entry.key, match: m));
        }
      }
    }
    result.sort((a, b) {
      final ta = a.match['timestamp'] as int? ?? 0;
      final tb = b.match['timestamp'] as int? ?? 0;
      return ta.compareTo(tb);
    });
    return result;
  }

  // ── Puntos SVNS por posición final (posición 1-based → índice 0-based) ────
  static const _svnsPoints = [20, 14, 10, 7, 5, 4, 3, 2, 1, 1, 1, 1];

  /// Tabla acumulada del Circuito 7s calculada automáticamente desde resultados de la API.
  /// Los puntos se asignan según la posición final en cada etapa (sistema SVNS).
  List<List<dynamic>> getAccumulatedSevensStandings() {
    final Map<String, int> totalPts    = {};
    final Map<String, int> etapas      = {};
    final Map<String, int> etapasGanadas = {};

    for (final league in sevensLeagues) {
      final matches = _data[league] ?? [];
      if (matches.isEmpty) continue;
      final placements = _computeTournamentPlacements(matches);
      if (placements.isEmpty) continue;

      for (final entry in placements.entries) {
        final team = entry.key;
        final pos  = entry.value; // 1-based
        final pts  = (pos >= 1 && pos <= _svnsPoints.length) ? _svnsPoints[pos - 1] : 0;
        totalPts[team]       = (totalPts[team] ?? 0) + pts;
        etapas[team]         = (etapas[team] ?? 0) + 1;
        if (pos == 1) etapasGanadas[team] = (etapasGanadas[team] ?? 0) + 1;
      }
    }

    if (totalPts.isEmpty) return [];

    final sorted = totalPts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return [
      sorted.asMap().entries.map<dynamic>((e) => {
        'position': e.key + 1,
        'team':     {'name': e.value.key},
        'games': {
          'played': etapas[e.value.key] ?? 0,
          'win':    {'total': etapasGanadas[e.value.key] ?? 0},
          'draw':   {'total': 0},
          'lose':   {'total': 0},
        },
        'points':      e.value.value,
        'description': null,
      }).toList(),
    ];
  }

  /// Determina la posición final (1-based) de cada equipo en un torneo 7s
  /// analizando los resultados de los partidos de Copa (cup knockout).
  Map<String, int> _computeTournamentPlacements(List<dynamic> matches) {
    final Map<String, int> placements = {};

    // Solo partidos jugados
    final finished = matches.where((m) => m['scores']?['home'] != null).toList();
    if (finished.isEmpty) return {};

    // Recoger todos los equipos del torneo
    final allTeams = <String>{};
    for (final m in finished) {
      final h = m['teams']?['home']?['name']?.toString();
      final a = m['teams']?['away']?['name']?.toString();
      if (h != null && h.isNotEmpty) allTeams.add(h);
      if (a != null && a.isNotEmpty) allTeams.add(a);
    }
    if (allTeams.isEmpty) return {};

    String? winner(dynamic m) {
      final hs = m['scores']?['home'];
      final as_ = m['scores']?['away'];
      if (hs == null || as_ == null) return null;
      final h = m['teams']?['home']?['name']?.toString() ?? '';
      final a = m['teams']?['away']?['name']?.toString() ?? '';
      return (hs as num) >= (as_ as num) ? h : a;
    }

    String? loser(dynamic m) {
      final hs = m['scores']?['home'];
      final as_ = m['scores']?['away'];
      if (hs == null || as_ == null) return null;
      final h = m['teams']?['home']?['name']?.toString() ?? '';
      final a = m['teams']?['away']?['name']?.toString() ?? '';
      return (hs as num) < (as_ as num) ? h : a;
    }

    // Helpers para reconocer fases (formato SVNS: "SVNS Dubai - Final", etc.)
    bool isFinal(String w)   => w == 'cup final' || (w.contains('svns') && w.endsWith('- final'));
    bool isBronze(String w)  => w.contains('bronze') || w.contains('3rd') || w.contains('third')
                              || (w.contains('svns') && w.endsWith('- 3rd place'));
    bool is5th(String w)     => w.contains('5th') || w.contains('fifth')
                              || (w.contains('svns') && w.endsWith('- 5th place'));
    bool is7th(String w)     => w.contains('7th') || w.contains('seventh')
                              || (w.contains('svns') && w.endsWith('- 7th place'));
    bool is9th(String w)     => w.contains('9th') || (w.contains('svns') && w.endsWith('- 9th place'));
    bool isSemi(String w)    => (w.contains('cup') && w.contains('semi'))
                              || (w.contains('svns') && w.contains('semi'));
    bool isQuarter(String w) => (w.contains('cup') && w.contains('quarter'))
                              || (w.contains('svns') && w.contains('quarter'));

    // Clasificar partidos por fase
    for (final m in finished) {
      final week = m['week']?.toString().toLowerCase() ?? '';
      if (isFinal(week)) {
        final w = winner(m); final l = loser(m);
        if (w != null) placements[w] = 1;
        if (l != null) placements[l] = 2;
      } else if (isBronze(week)) {
        final w = winner(m); final l = loser(m);
        if (w != null) placements.putIfAbsent(w, () => 3);
        if (l != null) placements.putIfAbsent(l, () => 4);
      } else if (is5th(week)) {
        final w = winner(m); final l = loser(m);
        if (w != null) placements.putIfAbsent(w, () => 5);
        if (l != null) placements.putIfAbsent(l, () => 6);
      } else if (is7th(week)) {
        final w = winner(m); final l = loser(m);
        if (w != null) placements.putIfAbsent(w, () => 7);
        if (l != null) placements.putIfAbsent(l, () => 8);
      } else if (is9th(week)) {
        final w = winner(m); final l = loser(m);
        if (w != null) placements.putIfAbsent(w, () => 9);
        if (l != null) placements.putIfAbsent(l, () => 10);
      }
    }

    // SF losers no asignados → posiciones siguientes
    int nextPos = placements.isEmpty ? 1
        : placements.values.fold(0, (a, b) => a > b ? a : b) + 1;
    nextPos = nextPos.clamp(5, 99);

    for (final m in finished) {
      final week = m['week']?.toString().toLowerCase() ?? '';
      if (isSemi(week)) {
        final l = loser(m);
        if (l != null) placements.putIfAbsent(l, () => nextPos++);
      }
    }

    // QF losers no asignados
    for (final m in finished) {
      final week = m['week']?.toString().toLowerCase() ?? '';
      if (isQuarter(week)) {
        final l = loser(m);
        if (l != null) placements.putIfAbsent(l, () => nextPos++);
      }
    }

    // Equipos que solo jugaron pools → posiciones restantes
    for (final team in allTeams) {
      placements.putIfAbsent(team, () => nextPos++);
    }

    return placements;
  }

  /// Partidos de ayer (FT) + hoy (todos) + próximos días (NS), agrupados por fecha
  Map<String, List<MatchEntry>> getUpcoming() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final byDate = <String, List<MatchEntry>>{};

    const doneStatuses = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};

    for (final entry in _data.entries) {
      for (final m in entry.value) {
        final s = m['status']?['short'] as String? ?? '';
        final rawDate = m['date'] as String? ?? '';
        if (rawDate.length < 10) continue;
        // Convertir a hora local para agrupar por la fecha correcta
        final utcDt = DateTime.tryParse(rawDate);
        if (utcDt == null) continue;
        final localDt = utcDt.toLocal();
        final matchDate = DateTime(localDt.year, localDt.month, localDt.day);

        // Ayer: solo partidos terminados
        // Hoy: mostrar todos (jugados, en vivo, próximos)
        // Días futuros: solo partidos no iniciados (NS)
        final isYesterday = matchDate.isAtSameMomentAs(yesterday);
        final isToday = matchDate.isAtSameMomentAs(today);
        if (isYesterday) {
          if (!doneStatuses.contains(s)) continue;
        } else if (isToday) {
          // incluir todo
        } else {
          // Días futuros: solo NS
          if (s != 'NS') continue;
          if (matchDate.isBefore(tomorrow)) continue;
        }

        final dateStr = '${localDt.year.toString().padLeft(4, '0')}-'
            '${localDt.month.toString().padLeft(2, '0')}-'
            '${localDt.day.toString().padLeft(2, '0')}';
        byDate.putIfAbsent(dateStr, () => []);
        byDate[dateStr]!.add(MatchEntry(league: entry.key, match: m));
      }
    }

    for (final list in byDate.values) {
      list.sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return ta.compareTo(tb);
      });
    }
    return byDate;
  }
}
