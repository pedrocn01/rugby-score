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
            .fetchMatches(e.value)
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

  /// Próximos partidos (NS), desde hoy, agrupados por fecha YYYY-MM-DD
  Map<String, List<MatchEntry>> getUpcoming() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final byDate = <String, List<MatchEntry>>{};

    for (final entry in _data.entries) {
      for (final m in entry.value) {
        final s = m['status']?['short'] as String? ?? '';
        if (s != 'NS') continue;
        final rawDate = m['date'] as String? ?? '';
        if (rawDate.length < 10) continue;
        final dateStr = rawDate.substring(0, 10);
        final matchDate = DateTime.tryParse(dateStr);
        if (matchDate == null || matchDate.isBefore(today)) continue;
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
