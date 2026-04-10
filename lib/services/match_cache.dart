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
            .catchError((_) => <dynamic>[])),
      );

      for (int i = 0; i < entries.length; i++) {
        _data[entries[i].key] = results[i];
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

  /// Partidos de hoy (todos los estados) + próximos días (solo NS), agrupados por fecha
  Map<String, List<MatchEntry>> getUpcoming() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final byDate = <String, List<MatchEntry>>{};

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

        // Hoy: mostrar todos (jugados, en vivo, próximos)
        // Días futuros: solo partidos no iniciados (NS)
        final isToday = matchDate.isAtSameMomentAs(today);
        if (isToday) {
          // Incluir todo excepto partidos de días anteriores
          if (matchDate.isBefore(today)) continue;
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
