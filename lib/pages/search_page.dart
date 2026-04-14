import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../services/match_cache.dart';
import '../services/urba_service.dart';

// ─── Modelo interno ───────────────────────────────────────────────────────────

class _Entry {
  final String league;
  final dynamic match;
  const _Entry(this.league, this.match);
}

// ─── Página principal ─────────────────────────────────────────────────────────

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl    = TextEditingController();
  final _focus   = FocusNode();
  bool _loading  = true;
  final List<_Entry> _all = [];
  List<_Entry> _results   = [];

  static const _doneStatuses   = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};
  static const _urbaLeagues    = ['URBA Top 14', 'URBA Primera A', 'URBA Primera B', 'URBA Primera C'];

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onType);
    _loadAll();
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onType);
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ── Carga de datos ──────────────────────────────────────────────────────────

  Future<void> _loadAll() async {
    // 1. Ligas internacionales — ya en caché, instantáneo
    final cache = await MatchCache.instance.fetchAll();
    for (final e in cache.entries) {
      for (final m in e.value) {
        _all.add(_Entry(e.key, m));
      }
    }

    // 2. Ligas URBA — fetch en paralelo (puede tardar 2-4 s)
    final urba    = UrbaService();
    final futures = _urbaLeagues.map(
      (l) => urba.fetchMatches(l).catchError((_) => <dynamic>[]),
    );
    final urbaResults = await Future.wait(futures);
    for (int i = 0; i < _urbaLeagues.length; i++) {
      for (final m in urbaResults[i]) {
        _all.add(_Entry(_urbaLeagues[i], m));
      }
    }

    if (mounted) {
      setState(() => _loading = false);
      // Auto-foco al terminar de cargar
      _focus.requestFocus();
    }
  }

  // ── Búsqueda ────────────────────────────────────────────────────────────────

  void _onType() {
    final q = _ctrl.text.trim().toLowerCase();
    if (q.length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = _all.where((e) {
        final home = e.match['teams']?['home']?['name']?.toString().toLowerCase() ?? '';
        final away = e.match['teams']?['away']?['name']?.toString().toLowerCase() ?? '';
        return home.contains(q) || away.contains(q);
      }).toList();
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Separar en jugados y próximos
    final played   = _results.where((e) {
      final s = e.match['status']?['short'] as String? ?? '';
      return _doneStatuses.contains(s);
    }).toList()
      ..sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return tb.compareTo(ta); // más recientes primero
      });

    final upcoming = _results.where((e) {
      final s = e.match['status']?['short'] as String? ?? '';
      return !_doneStatuses.contains(s);
    }).toList()
      ..sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return ta.compareTo(tb); // más próximos primero
      });

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        elevation:       0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller:  _ctrl,
          focusNode:   _focus,
          autofocus:   true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white70,
          decoration: InputDecoration(
            hintText:      'Buscar equipo…',
            hintStyle:     TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 15),
            border:        InputBorder.none,
            suffixIcon: _ctrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: Colors.white54, size: 20),
                    onPressed: () { _ctrl.clear(); setState(() => _results = []); },
                  )
                : null,
          ),
        ),
      ),
      body: _loading
          ? const _LoadingView()
          : _ctrl.text.trim().length < 2
              ? const _EmptyPrompt()
              : _results.isEmpty
                  ? _NoResults(query: _ctrl.text.trim())
                  : _ResultsList(played: played, upcoming: upcoming),
    );
  }
}

// ─── Estados vacíos ───────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Color(0xFF1B4332)),
        SizedBox(height: 16),
        Text('Cargando partidos…',
          style: TextStyle(color: Colors.white38, fontSize: 13)),
      ],
    ),
  );
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.search_rounded, color: Colors.white12, size: 64),
        SizedBox(height: 16),
        Text('Escribí el nombre de un equipo',
          style: TextStyle(color: Colors.white38, fontSize: 14)),
        SizedBox(height: 6),
        Text('Ej: "CUBA", "Crusaders", "Bath"',
          style: TextStyle(color: Colors.white24, fontSize: 12)),
      ],
    ),
  );
}

class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.sports_rugby_rounded, color: Colors.white12, size: 56),
        const SizedBox(height: 16),
        Text('Sin resultados para "$query"',
          style: const TextStyle(color: Colors.white38, fontSize: 14)),
      ],
    ),
  );
}

// ─── Lista de resultados ──────────────────────────────────────────────────────

class _ResultsList extends StatelessWidget {
  final List<_Entry> played;
  final List<_Entry> upcoming;
  const _ResultsList({required this.played, required this.upcoming});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (upcoming.isNotEmpty) ...[
          _SectionHeader('PRÓXIMOS', upcoming.length),
          ...upcoming.map((e) => _MatchCard(entry: e, isDone: false)),
        ],
        if (played.isNotEmpty) ...[
          _SectionHeader('JUGADOS', played.length),
          ...played.map((e) => _MatchCard(entry: e, isDone: true)),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader(this.title, this.count);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF1B4332),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800,
              fontSize: 11, letterSpacing: 2.0)),
        ),
        const SizedBox(width: 8),
        Text('$count partido${count != 1 ? 's' : ''}',
          style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xFF1B4332).withValues(alpha: 0.5),
                Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Tarjeta de partido ───────────────────────────────────────────────────────

class _MatchCard extends StatelessWidget {
  final _Entry entry;
  final bool   isDone;
  const _MatchCard({required this.entry, required this.isDone});

  String _formatDate(dynamic match) {
    final raw = match['date'] as String? ?? '';
    if (raw.length < 10) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                       'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      final time = (dt.hour == 0 && dt.minute == 0) ? '' : ' · $h:$m';
      return '${dt.day} ${months[dt.month]} ${dt.year}$time';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final m         = entry.match;
    final home      = m['teams']?['home']?['name'] as String? ?? '?';
    final away      = m['teams']?['away']?['name'] as String? ?? '?';
    final homeLogo  = m['teams']?['home']?['logo'] as String?;
    final awayLogo  = m['teams']?['away']?['logo'] as String?;
    final homeScore = m['scores']?['home'];
    final awayScore = m['scores']?['away'];
    final hasScore  = homeScore != null && awayScore != null;
    final week      = m['week'] as String?;
    final theme     = leagueThemes[entry.league];
    final color     = theme?.primary ?? const Color(0xFF1B4332);
    final dateStr   = _formatDate(m);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Liga + fecha/jornada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                // Logo de liga
                if (leagueLogo(entry.league) != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.network(
                      leagueLogo(entry.league)!,
                      width: 14, height: 14, fit: BoxFit.contain,
                      errorBuilder: (ctx, e, st) => const SizedBox(width: 14),
                    ),
                  ),
                Text(entry.league,
                  style: TextStyle(color: color, fontSize: 10,
                    fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                if (week != null && week.isNotEmpty) ...[
                  Text(' · ',
                    style: TextStyle(color: color.withValues(alpha: 0.5), fontSize: 10)),
                  Text(week,
                    style: TextStyle(color: color.withValues(alpha: 0.8),
                      fontSize: 10, fontWeight: FontWeight.w600)),
                ],
                const Spacer(),
                Text(dateStr,
                  style: const TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          // Equipos y marcador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Local
                Expanded(
                  child: Row(
                    children: [
                      _Logo(name: home, apiUrl: homeLogo),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(home,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isDone && hasScore && homeScore > awayScore
                                ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13,
                          )),
                      ),
                    ],
                  ),
                ),
                // Marcador o vs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFF1B4332).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: hasScore
                      ? Text('$homeScore - $awayScore',
                          style: TextStyle(
                            color: isDone ? Colors.white70 : const Color(0xFF4A7C59),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ))
                      : const Text('vs',
                          style: TextStyle(color: Colors.white38,
                            fontWeight: FontWeight.w700, fontSize: 12)),
                ),
                // Visitante
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(away,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: isDone && hasScore && awayScore > homeScore
                                ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13,
                          )),
                      ),
                      const SizedBox(width: 6),
                      _Logo(name: away, apiUrl: awayLogo),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mini logo de equipo ──────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  final String  name;
  final String? apiUrl;
  const _Logo({required this.name, this.apiUrl});

  @override
  Widget build(BuildContext context) {
    final url = clubLogo(name) ?? apiUrl;
    if (url == null) return const SizedBox(width: 20);
    return Image.network(url, width: 20, height: 20, fit: BoxFit.contain,
      errorBuilder: (ctx, e, st) => const SizedBox(width: 20));
  }
}
