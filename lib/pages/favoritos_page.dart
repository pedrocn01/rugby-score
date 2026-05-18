import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../services/favorites_service.dart';
import '../services/match_cache.dart';
import '../data/static_data.dart';
import '../services/urba_service.dart';
import 'team_detail_page.dart';

// ─── Modelo interno ───────────────────────────────────────────────────────────

class _Entry {
  final String league;
  final dynamic match;
  const _Entry(this.league, this.match);
}

// ─── Página principal ─────────────────────────────────────────────────────────

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  static const _urbaLeagues = ['URBA Top 14', 'URBA Primera A', 'URBA Primera B', 'URBA Primera C'];

  bool _loadingMatches = true;
  final List<_Entry> _all = [];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final cache = await MatchCache.instance.fetchAll();
    for (final e in cache.entries) {
      for (final m in e.value) {
        _all.add(_Entry(e.key, m));
      }
    }
    final urba = UrbaService();
    final results = await Future.wait(
      _urbaLeagues.map((l) => urba.fetchMatches(l).catchError((_) => <dynamic>[])),
    );
    for (int i = 0; i < _urbaLeagues.length; i++) {
      for (final m in results[i]) {
        _all.add(_Entry(_urbaLeagues[i], m));
      }
    }
    for (final raw in StaticDataService.getMatches('TDI A 2026')) {
      final m = Map<String, dynamic>.from(raw as Map);
      if (!m.containsKey('timestamp')) {
        final dt = DateTime.tryParse(m['date'] as String? ?? '');
        m['timestamp'] = dt != null ? dt.millisecondsSinceEpoch ~/ 1000 : 0;
      }
      _all.add(_Entry('TDI A 2026', m));
    }
    if (mounted) setState(() => _loadingMatches = false);
  }

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TeamPicker(allMatches: _all),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: FavoritesService.instance,
          builder: (context, _) {
            final favs = FavoritesService.instance.favorites;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('MIS EQUIPOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              )),
                            const SizedBox(height: 2),
                            Text(
                              favs.isEmpty
                                  ? 'Seguí tus equipos favoritos'
                                  : '${favs.length} equipo${favs.length != 1 ? 's' : ''} seguido${favs.length != 1 ? 's' : ''}',
                              style: const TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _openPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B5E20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text('AGREGAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Contenido ────────────────────────────────────────────────
                Expanded(
                  child: favs.isEmpty
                      ? _EmptyState(onAdd: _openPicker)
                      : _loadingMatches
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B4332)))
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: favs.length,
                              itemBuilder: (ctx, i) => _TeamCard(
                                teamName: favs[i],
                                allMatches: _all,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TeamDetailPage(teamName: favs[i]),
                                  ),
                                ),
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.sports_rugby_rounded, color: Colors.white12, size: 56),
        const SizedBox(height: 16),
        const Text('Sin equipos todavía',
          style: TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text('Agregá tus equipos para ver sus partidos\nde un vistazo',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white24, fontSize: 13, height: 1.5)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text('AGREGAR EQUIPO',
                  style: TextStyle(
                    color: Colors.white, fontSize: 13,
                    fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Tarjeta de equipo favorito ───────────────────────────────────────────────

class _TeamCard extends StatelessWidget {
  final String teamName;
  final List<_Entry> allMatches;
  final VoidCallback onTap;
  const _TeamCard({required this.teamName, required this.allMatches, required this.onTap});

  static const _doneStatuses = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};
  static const _liveStatuses = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};

  List<_Entry> get _teamMatches => allMatches.where((e) {
    final home = e.match['teams']?['home']?['name']?.toString() ?? '';
    final away = e.match['teams']?['away']?['name']?.toString() ?? '';
    return home == teamName || away == teamName;
  }).toList();

  String get _league {
    for (final e in _teamMatches) { return e.league; }
    return '';
  }

  bool get _isLive => _teamMatches.any(
    (e) => _liveStatuses.contains(e.match['status']?['short']));

  List<bool?> get _lastResults {
    final done = _teamMatches
        .where((e) => _doneStatuses.contains(e.match['status']?['short']))
        .toList()
      ..sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return tb.compareTo(ta);
      });
    return done.take(5).map((e) {
      final hs = e.match['scores']?['home'] as num?;
      final as_ = e.match['scores']?['away'] as num?;
      if (hs == null || as_ == null) return null;
      final isHome = (e.match['teams']?['home']?['name'] as String?) == teamName;
      if (hs == as_) return null;
      return isHome ? hs > as_ : as_ > hs;
    }).toList();
  }

  String get _nextMatchLabel {
    if (_isLive) return 'EN VIVO';
    final upcoming = _teamMatches
        .where((e) => e.match['status']?['short'] == 'NS')
        .toList()
      ..sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return ta.compareTo(tb);
      });
    if (upcoming.isEmpty) return '';
    final raw = upcoming.first.match['date'] as String? ?? '';
    if (raw.length < 10) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final matchDay = DateTime(dt.year, dt.month, dt.day);
      if (matchDay == today) {
        final h = dt.hour.toString().padLeft(2, '0');
        final m = dt.minute.toString().padLeft(2, '0');
        return 'HOY $h:$m';
      }
      const months = ['', 'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
                       'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
      return '${dt.day} ${months[dt.month]}';
    } catch (_) { return ''; }
  }

  Color get _accentColor {
    final theme = leagueThemes[_league];
    return theme?.primary ?? const Color(0xFF1B4332);
  }

  @override
  Widget build(BuildContext context) {
    final logoPath = clubLogo(teamName);
    final accent   = _accentColor;
    final results  = _lastResults;
    final next     = _nextMatchLabel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.25)),
        ),
        child: Stack(
          children: [
            // Gradiente sutil de color de liga
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent.withValues(alpha: 0.12), Colors.transparent],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                // ── Logo + nombre + liga ──────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        SizedBox(
                          width: 44, height: 44,
                          child: logoPath != null
                              ? Image.asset(logoPath, fit: BoxFit.contain,
                                  errorBuilder: (_, e, st) => _InitialsWidget(teamName))
                              : _InitialsWidget(teamName),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          teamName.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                            height: 1.1,
                          ),
                        ),
                        if (_league.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            _league.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // ── Barra inferior: resultados + próximo ──────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Puntitos W/L
                      Row(
                        children: results.map((won) => Container(
                          width: 7, height: 7,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: won == null
                                ? Colors.white.withValues(alpha: 0.15)
                                : won
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFEF5350),
                          ),
                        )).toList(),
                      ),
                      // Próximo partido
                      if (next.isNotEmpty)
                        Text(
                          next,
                          style: TextStyle(
                            color: _isLive ? const Color(0xFFFF5252) : const Color(0xFF4CAF50),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Badge EN VIVO
            if (_isLive)
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [BoxShadow(color: const Color(0xFFD32F2F).withValues(alpha: 0.5), blurRadius: 6)],
                  ),
                  child: const Text('EN VIVO',
                    style: TextStyle(
                      color: Colors.white, fontSize: 7,
                      fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InitialsWidget extends StatelessWidget {
  final String name;
  const _InitialsWidget(this.name);

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(' ');
    final text  = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.substring(0, name.length.clamp(0, 2)).toUpperCase();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
      alignment: Alignment.center,
      child: Text(text,
        style: const TextStyle(
          color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w900)),
    );
  }
}

// ─── Bottom sheet picker ──────────────────────────────────────────────────────

class _TeamPicker extends StatefulWidget {
  final List<_Entry> allMatches;
  const _TeamPicker({required this.allMatches});

  @override
  State<_TeamPicker> createState() => _TeamPickerState();
}

class _TeamPickerState extends State<_TeamPicker> {
  final _ctrl = TextEditingController();
  List<String> _filtered = [];
  final Map<String, String> _networkLogos = {};

  late final List<String> _allTeams;

  @override
  void initState() {
    super.initState();
    // Recolectar logos de red de la API (URBA 1A/1B/1C, etc.)
    for (final e in widget.allMatches) {
      final hn = e.match['teams']?['home']?['name'] as String?;
      final hl = e.match['teams']?['home']?['logo'] as String?;
      final an = e.match['teams']?['away']?['name'] as String?;
      final al = e.match['teams']?['away']?['logo'] as String?;
      if (hn != null && hl != null && !_networkLogos.containsKey(hn)) _networkLogos[hn] = hl;
      if (an != null && al != null && !_networkLogos.containsKey(an)) _networkLogos[an] = al;
    }
    // Excluir aliases del mapa estático para evitar duplicados
    final fromLogos   = clubLogoUrls.keys.where((k) => !teamPickerHidden.contains(k)).toSet();
    final fromMatches = <String>{};
    for (final e in widget.allMatches) {
      final h = e.match['teams']?['home']?['name'] as String?;
      final a = e.match['teams']?['away']?['name'] as String?;
      if (h != null && h.isNotEmpty) fromMatches.add(h);
      if (a != null && a.isNotEmpty) fromMatches.add(a);
    }
    _allTeams = {...fromLogos, ...fromMatches}.toList()..sort();
    _filtered = List.from(_allTeams);
    _ctrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onSearch);
    _ctrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _ctrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(_allTeams)
          : _allTeams.where((t) => t.toLowerCase().contains(q)).toList();
    });
  }

  String _leagueFor(String teamName) {
    for (final e in widget.allMatches) {
      final h = e.match['teams']?['home']?['name'] as String?;
      final a = e.match['teams']?['away']?['name'] as String?;
      if (h == teamName || a == teamName) return e.league;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize:     0.4,
      maxChildSize:     0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('AGREGAR EQUIPO',
                  style: TextStyle(
                    color: Colors.white, fontSize: 17,
                    fontWeight: FontWeight.w900, letterSpacing: 1.0)),
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.search_rounded, color: Colors.white38, size: 18),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white70,
                        decoration: const InputDecoration(
                          hintText: 'Ej: CUBA, Crusaders, Bath…',
                          hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_ctrl.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, color: Colors.white38, size: 18),
                        onPressed: () => _ctrl.clear(),
                      ),
                  ],
                ),
              ),
            ),
            // Lista
            Expanded(
              child: ListenableBuilder(
                listenable: FavoritesService.instance,
                builder: (context, _) => ListView.builder(
                  controller: scrollCtrl,
                  itemCount: _filtered.length,
                  itemBuilder: (ctx, i) {
                    final name    = _filtered[i];
                    final isFav   = FavoritesService.instance.isFavorite(name);
                    final logo        = clubLogo(name);
                    final networkLogo = logo == null ? _networkLogos[name] : null;
                    final league      = _leagueFor(name);

                    return InkWell(
                      onTap: () => FavoritesService.instance.toggle(name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.04))),
                        ),
                        child: Row(
                          children: [
                            // Logo
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                              child: logo != null
                                  ? ClipOval(child: Image.asset(logo, fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => _InitialsWidget(name)))
                                  : networkLogo != null
                                      ? ClipOval(child: Image.network(networkLogo, fit: BoxFit.contain,
                                          errorBuilder: (_, _, _) => _InitialsWidget(name)))
                                      : _InitialsWidget(name),
                            ),
                            const SizedBox(width: 12),
                            // Nombre + liga
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                    style: const TextStyle(
                                      color: Colors.white, fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                                  if (league.isNotEmpty)
                                    Text(league.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white38, fontSize: 9,
                                        fontWeight: FontWeight.w600, letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                            // Estrella (favoritos)
                            Icon(
                              isFav ? Icons.check_circle_rounded : Icons.circle_outlined,
                              color: isFav ? const Color(0xFF4CAF50) : Colors.white24,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
