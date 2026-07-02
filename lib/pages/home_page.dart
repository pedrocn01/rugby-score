import 'package:flutter/material.dart';
import '../config/leagues.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../services/match_cache.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/rugby_logo.dart';
import 'carpeta_page.dart';
import 'detalle_liga.dart';
import 'search_page.dart';

enum _Status { hot, active, upcoming, finished }

// ── Estado calculado de una liga ──────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;

  bool _loaded = false;
  int  _weekendCount  = 0;
  String?       _heroLeague;
  List<dynamic> _heroMatches    = [];
  int           _heroTotal      = 0;
  bool          _urbaHeroActive = false;
  String        _urbaWeekName   = '';
  int           _urbaCount      = 0;
  Map<String, _Status> _status  = {};

  static const _internacionalOrder = [
    'Nations Championship', 'Seis Naciones', 'The Rugby Championship',
  ];
  static const _superRugbyOrder = [
    'Super Rugby Pacific', 'Super Rugby Américas',
  ];
  static const _europaOrder = [
    'Top 14', 'Premiership', 'United Rugby Championship', 'Champions Cup', 'Challenge Cup',
  ];

  static const _subs = <String, String>{
    'Nations Championship':   'Internacional · 12 selecciones',
    'Seis Naciones':          'Europa · 6 selecciones',
    'The Rugby Championship': 'SANZAAR · 4 selecciones',
    'Super Rugby Pacific':    'Oceanía',
    'Super Rugby Américas':   'Américas',
    'Top 14':                 'Francia',
    'Premiership':            'Inglaterra',
    'United Rugby Championship': 'Europa',
    'Champions Cup':          'Europa',
    'Challenge Cup':          'Europa',
  };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _loadStatus();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    final cache = await MatchCache.instance.fetchAll();
    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final in7   = today.add(const Duration(days: 7));
    final in14  = today.add(const Duration(days: 14));

    final statusMap      = <String, _Status>{};
    final upcomingMap    = <String, List<dynamic>>{};
    final totalMap       = <String, int>{};
    int weekendCount = 0;

    for (final entry in cache.entries) {
      final matches = entry.value;
      final upcoming = <dynamic>[];
      bool hasToday = false, hasWeek = false, hasFuture = false;
      int total = 0;

      for (final m in matches) {
        final raw = m['date'] as String? ?? '';
        final dt  = DateTime.tryParse(raw)?.toLocal();
        if (dt == null) continue;
        final day = DateTime(dt.year, dt.month, dt.day);

        if (day == today) {
          hasToday = true; hasWeek = true;
          weekendCount++; total++;
          upcoming.add(m);
        } else if (day.isAfter(today) && !day.isAfter(in7)) {
          hasWeek = true; total++;
          upcoming.add(m);
        } else if (day.isAfter(in7) && !day.isAfter(in14)) {
          hasFuture = true; total++;
          upcoming.add(m);
        } else if (day.isAfter(in14)) {
          hasFuture = true;
        }
      }

      statusMap[entry.key] = hasToday ? _Status.hot
          : hasWeek         ? _Status.active
          : hasFuture       ? _Status.upcoming
          : _Status.finished;

      if (upcoming.isNotEmpty) {
        upcoming.sort((a, b) =>
            ((a['timestamp'] as num?)?.toInt() ?? 0)
            .compareTo((b['timestamp'] as num?)?.toInt() ?? 0));
        upcomingMap[entry.key] = upcoming;
        totalMap[entry.key] = total;
      }
    }

    // Hero internacional
    String? heroLeague;
    List<dynamic> heroMatches = [];
    int heroTotal = 0;
    for (final l in _internacionalOrder) {
      final s = statusMap[l];
      if (s == _Status.hot || s == _Status.active) {
        heroLeague  = l;
        heroMatches = (upcomingMap[l] ?? []).take(3).toList();
        heroTotal   = totalMap[l] ?? 0;
        break;
      }
    }

    // Hero URBA
    final urbaS     = statusMap['URBA Top 14'];
    final urbaActive = urbaS == _Status.hot || urbaS == _Status.active;
    final urbaList  = upcomingMap['URBA Top 14'] ?? [];
    final urbaWeek  = urbaList.isNotEmpty ? urbaList.first['week'] as String? ?? '' : '';
    final urbaCount = totalMap['URBA Top 14'] ?? 0;

    if (!mounted) return;
    setState(() {
      _status        = statusMap;
      _heroLeague    = heroLeague;
      _heroMatches   = heroMatches;
      _heroTotal     = heroTotal;
      _urbaHeroActive = urbaActive;
      _urbaWeekName  = urbaWeek;
      _urbaCount     = urbaCount;
      _weekendCount  = weekendCount;
      _loaded        = true;
    });
  }

  void _go(BuildContext ctx, String name) {
    if (folders.containsKey(name)) {
      final ligas = folders[name]!;
      if (ligas.length == 1) { _go(ctx, ligas[0]); return; }
      Navigator.push(ctx, MaterialPageRoute(
        builder: (_) => CarpetaPage(titulo: name, ligas: ligas),
      ));
      return;
    }
    final id    = leagueIds[name] ?? 0;
    final theme = leagueThemes[name] ?? const LeagueTheme(
      primary: Color(0xFF1B4332), accent: Color(0xFF40916C), background: Color(0xFFE8F5EE),
    );
    Navigator.push(ctx, MaterialPageRoute(
      builder: (_) => DetalleLiga(
        nombreLiga:            name,
        leagueId:              id,
        theme:                 theme,
        isStatic:              staticLeagues.contains(name),
        isStaticStandingsOnly: staticStandingsOnly.contains(name),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── AppBar ──────────────────────────────────────────────────
            SliverAppBar(
              pinned:              true,
              backgroundColor:     const Color(0xFF0A0A0A),
              elevation:           0,
              surfaceTintColor:    Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: const Color(0xFF141414)),
              ),
              actions: [
                const ProfileAvatarButton(),
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: Colors.white70),
                  tooltip: 'Buscar equipo',
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                ),
              ],
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const RugbyLogo(size: 28, color: Colors.white),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize:       MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('RUGBY SCORE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                          fontSize: 14, letterSpacing: 2.5)),
                      Text('Resultados · Tablas · Fixtures',
                        style: TextStyle(color: Colors.white.withValues(alpha: .4),
                          fontSize: 8, letterSpacing: 1.5)),
                    ],
                  ),
                ],
              ),
            ),

            // ── Contenido ───────────────────────────────────────────────
            SliverList(
              delegate: SliverChildListDelegate([

                // Strip bar
                if (_loaded && _weekendCount > 0)
                  _StripBar(count: _weekendCount),

                // Hero internacional
                if (_heroLeague != null)
                  _HeroCard(
                    league:  _heroLeague!,
                    matches: _heroMatches,
                    total:   _heroTotal,
                    onTap:   () => _go(context, _heroLeague!),
                  ),

                // Hero URBA
                if (_urbaHeroActive)
                  _HeroMedCard(
                    weekName:   _urbaWeekName,
                    matchCount: _urbaCount,
                    onTap:      () => _go(context, 'URBA'),
                  ),

                // ── INTERNACIONAL ────────────────────────────────────────
                const _SectionLabel('Internacional'),
                ..._internacionalOrder
                    .where((l) => l != _heroLeague)
                    .map((l) => _LeagueRow(
                          name:  l,
                          sub:   _subs[l] ?? '',
                          status: _status[l],
                          onTap: () => _go(context, l),
                        )),

                // ── SUPER RUGBY ──────────────────────────────────────────
                const _SectionLabel('Super Rugby'),
                ..._superRugbyOrder.map((l) => _LeagueRow(
                      name:  l,
                      sub:   _subs[l] ?? '',
                      status: _status[l],
                      onTap: () => _go(context, l),
                    )),

                // ── EUROPA ───────────────────────────────────────────────
                const _SectionLabel('Europa'),
                ..._europaOrder.map((l) => _LeagueRow(
                      name:  l,
                      sub:   _subs[l] ?? '',
                      status: _status[l],
                      onTap: () => _go(context, l),
                    )),

                // ── LOCALES ──────────────────────────────────────────────
                const _SectionLabel('Locales'),
                if (!_urbaHeroActive)
                  _FolderRow(
                    name:   'URBA',
                    sub:    'Buenos Aires · 9 divisiones',
                    color:  const Color(0xFF1B5E20),
                    status: _status['URBA Top 14'],
                    onTap:  () => _go(context, 'URBA'),
                  ),
                _FolderRow(
                  name:  'URBA - Juveniles',
                  sub:   'M-19 · M-17 · M-16 · M-15',
                  color: const Color(0xFFB84800),
                  onTap: () => _go(context, 'URBA - Juveniles'),
                ),

                const _FooterWidget(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Strip bar con pulse dot ───────────────────────────────────────────────────

class _StripBar extends StatefulWidget {
  final int count;
  const _StripBar({required this.count});
  @override
  State<_StripBar> createState() => _StripBarState();
}

class _StripBarState extends State<_StripBar> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B5E20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (_, _) => Opacity(
              opacity: (1 - (_c.value - 0.5).abs() * 2).clamp(0.25, 1.0),
              child: Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.count} partido${widget.count != 1 ? "s" : ""} este fin de semana',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ── Hero card (torneo internacional activo) ───────────────────────────────────

class _HeroCard extends StatelessWidget {
  final String        league;
  final List<dynamic> matches;
  final int           total;
  final VoidCallback  onTap;
  const _HeroCard({required this.league, required this.matches,
      required this.total, required this.onTap});

  String _formatTime(dynamic m) {
    final raw = m['date'] as String? ?? '';
    final dt  = DateTime.tryParse(raw)?.toLocal();
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _dateLabel(List<dynamic> ms) {
    if (ms.isEmpty) return '';
    final raw = ms.first['date'] as String? ?? '';
    final dt  = DateTime.tryParse(raw)?.toLocal();
    if (dt == null) return '';
    const months = ['', 'ene', 'feb', 'mar', 'abr', 'may', 'jun',
                    'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${dt.day} de ${months[dt.month]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme      = leagueThemes[league];
    final primary    = theme?.primary ?? const Color(0xFF1B5E20);
    final logoUrl    = leagueLogoUrls[league];
    final logoAsset  = leagueLogoAssets[league];
    final dateStr    = _dateLabel(matches);
    final extra      = total - matches.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withValues(alpha: .25)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:   Alignment.bottomRight,
                  colors: [primary.withValues(alpha: .2), const Color(0xFF111111)],
                ),
              ),
              child: Row(
                children: [
                  if (logoAsset != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image.asset(logoAsset, width: 42, height: 42, fit: BoxFit.contain),
                    )
                  else if (logoUrl != null)
                    Container(
                      width: 42, height: 42,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(logoUrl, fit: BoxFit.contain),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(league,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                            fontSize: 16, letterSpacing: .2)),
                        if (dateStr.isNotEmpty || total > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            [if (dateStr.isNotEmpty) dateStr,
                             if (total > 0) '$total partido${total != 1 ? "s" : ""}']
                            .join(' · '),
                            style: TextStyle(color: Colors.white.withValues(alpha: .45),
                              fontSize: 10),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _Badge(status: _Status.active),
                ],
              ),
            ),

            // Lista de partidos
            ...matches.map((m) {
              final home = m['teams']?['home']?['name'] as String? ?? '';
              final away = m['teams']?['away']?['name'] as String? ?? '';
              final time = _formatTime(m);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white.withValues(alpha: .06))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('$home  vs  $away',
                        style: const TextStyle(color: Colors.white70, fontSize: 12,
                          fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    Text(time,
                      style: TextStyle(color: Colors.white.withValues(alpha: .3), fontSize: 10)),
                  ],
                ),
              );
            }),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(14, 7, 14, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: .06))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    extra > 0 ? '+ $extra partidos más  →' : 'VER TODOS LOS PARTIDOS  →',
                    style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 10,
                      fontWeight: FontWeight.w800, letterSpacing: .5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero mediana (URBA Top 14 activa) ────────────────────────────────────────

class _HeroMedCard extends StatelessWidget {
  final String       weekName;
  final int          matchCount;
  final VoidCallback onTap;
  const _HeroMedCard({required this.weekName, required this.matchCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final logoUrl = leagueLogoUrls['URBA Top 14'];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1B5E20).withValues(alpha: .25)),
        ),
        child: Row(
          children: [
            if (logoUrl != null)
              Container(
                width: 38, height: 38,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(3),
                child: Image.asset(logoUrl, fit: BoxFit.contain),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('URBA Top 14',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                  const SizedBox(height: 1),
                  Text(
                    [if (weekName.isNotEmpty) weekName,
                     if (matchCount > 0) '$matchCount partido${matchCount != 1 ? "s" : ""} este fin de semana']
                    .join(' · '),
                    style: TextStyle(color: Colors.white.withValues(alpha: .4), fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _Badge(status: _Status.active),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF2a2a2a), size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 6),
      child: Row(
        children: [
          Text(text.toUpperCase(),
            style: const TextStyle(color: Color(0xFF2a2a2a), fontSize: 9,
              fontWeight: FontWeight.w800, letterSpacing: 2.5)),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: const Color(0xFF141414))),
        ],
      ),
    );
  }
}

// ── League row ────────────────────────────────────────────────────────────────

class _LeagueRow extends StatelessWidget {
  final String    name;
  final String    sub;
  final _Status?  status;
  final VoidCallback onTap;
  const _LeagueRow({required this.name, required this.sub, this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme      = leagueThemes[name];
    final stripe     = theme?.primary ?? const Color(0xFF1B5E20);
    final logoUrl    = leagueLogoUrls[name];
    final logoAsset  = leagueLogoAssets[name];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: const Color(0xFF0F0F0F))),
        ),
        child: Row(
          children: [
            // Stripe
            Container(
              width: 3, height: 44,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: stripe,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Logo
            if (logoUrl != null)
              Container(
                width: 30, height: 30,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                padding: const EdgeInsets.all(3),
                child: Image.asset(logoUrl, fit: BoxFit.contain),
              )
            else if (logoAsset != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(logoAsset, width: 30, height: 30, fit: BoxFit.contain),
              )
            else
              Container(
                width: 30, height: 30,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: stripe.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(child: Text(name[0],
                  style: TextStyle(color: stripe, fontWeight: FontWeight.w900, fontSize: 14))),
              ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                      style: const TextStyle(color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 1),
                    Text(sub,
                      style: const TextStyle(color: Color(0xFF444444), fontSize: 10),
                      overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            // Badge + arrow
            if (status != null) ...[
              const SizedBox(width: 6),
              _Badge(status: status!),
            ],
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF1e1e1e), size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Folder row (URBA, Juveniles) ──────────────────────────────────────────────

class _FolderRow extends StatelessWidget {
  final String    name;
  final String    sub;
  final Color     color;
  final _Status?  status;
  final VoidCallback onTap;
  const _FolderRow({required this.name, required this.sub, required this.color,
      this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: const Color(0xFF0F0F0F))),
        ),
        child: Row(
          children: [
            // Stripe
            Container(
              width: 3, height: 44,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            ),
            // Icon
            Container(
              width: 30, height: 30,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(Icons.folder_open_rounded, color: color, size: 16),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                      style: const TextStyle(color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 1),
                    Text(sub,
                      style: const TextStyle(color: Color(0xFF444444), fontSize: 10),
                      overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            if (status != null) ...[
              const SizedBox(width: 6),
              _Badge(status: status!),
            ],
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF1e1e1e), size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Badge de estado ───────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final _Status status;
  const _Badge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      _Status.hot      => ('HOY',  const Color(0xFF4CAF50),       Colors.black),
      _Status.active   => ('ACT',  const Color(0x331B5E20),       const Color(0xFF4CAF50)),
      _Status.upcoming => ('PRÓ',  const Color(0x22FF9900),       const Color(0xFFFF9900)),
      _Status.finished => ('FIN',  const Color(0xFF1a1a1a),       const Color(0xFF3a3a3a)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
        style: TextStyle(color: fg, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: .5)),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _FooterWidget extends StatelessWidget {
  const _FooterWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: const Color(0xFF1B4332).withValues(alpha: .3))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0xFF1B4332),
                borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.sports_rugby_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('RUGBY SCORE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                fontSize: 14, letterSpacing: 2.5)),
          ]),
          const SizedBox(height: 8),
          Text('Resultados, tablas y fixtures del rugby argentino y mundial.',
            style: TextStyle(color: Colors.white.withValues(alpha: .35), fontSize: 12)),
          const SizedBox(height: 24),
          Container(height: 1, color: const Color(0xFF1a1a1a)),
          const SizedBox(height: 20),
          Text('CONTACTO',
            style: TextStyle(color: const Color(0xFF1B4332).withValues(alpha: .8),
              fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.mail_outline_rounded, size: 15, color: Colors.white.withValues(alpha: .3)),
            const SizedBox(width: 8),
            Text('rugbyscore01@gmail.com',
              style: TextStyle(color: Colors.white.withValues(alpha: .5), fontSize: 13)),
          ]),
          const SizedBox(height: 24),
          Container(height: 1, color: const Color(0xFF1a1a1a)),
          const SizedBox(height: 14),
          Text('© ${DateTime.now().year} Rugby Score. Datos: api-sports.io · urba.org.ar',
            style: TextStyle(color: Colors.white.withValues(alpha: .18), fontSize: 10)),
        ],
      ),
    );
  }
}
