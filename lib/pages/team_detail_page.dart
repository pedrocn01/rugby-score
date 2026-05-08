import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../services/favorites_service.dart';
import '../services/notifications_service.dart';
import '../services/push_notification_service.dart';
import '../data/static_data.dart';
import '../services/match_cache.dart';
import '../services/urba_service.dart';

// ─── Modelo interno ───────────────────────────────────────────────────────────

class _Entry {
  final String league;
  final dynamic match;
  const _Entry(this.league, this.match);
}

// ─── Página ───────────────────────────────────────────────────────────────────

class TeamDetailPage extends StatefulWidget {
  final String teamName;
  const TeamDetailPage({super.key, required this.teamName});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  static const _urbaLeagues   = ['URBA Top 14', 'URBA Primera A', 'URBA Primera B', 'URBA Primera C'];
  static const _doneStatuses  = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};
  static const _liveStatuses  = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};

  bool _loading = true;
  final List<_Entry> _matches = [];  // todos los partidos del equipo

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final all = <_Entry>[];

    // API-Sports
    final cache = await MatchCache.instance.fetchAll();
    for (final e in cache.entries) {
      for (final m in e.value) {
        if (_hasTeam(m, widget.teamName)) all.add(_Entry(e.key, m));
      }
    }

    // URBA
    final urba = UrbaService();
    final results = await Future.wait(
      _urbaLeagues.map((l) => urba.fetchMatches(l).catchError((_) => <dynamic>[])),
    );
    for (int i = 0; i < _urbaLeagues.length; i++) {
      for (final m in results[i]) {
        if (_hasTeam(m, widget.teamName)) all.add(_Entry(_urbaLeagues[i], m));
      }
    }

    for (final raw in StaticDataService.getMatches('TDI A 2026')) {
      final m = Map<String, dynamic>.from(raw as Map);
      if (!m.containsKey('timestamp')) {
        final dt = DateTime.tryParse(m['date'] as String? ?? '');
        m['timestamp'] = dt != null ? dt.millisecondsSinceEpoch ~/ 1000 : 0;
      }
      if (_hasTeam(m, widget.teamName)) all.add(_Entry('TDI A 2026', m));
    }

    if (!mounted) return;
    setState(() {
      _matches.addAll(all);
      _loading = false;
    });
  }

  bool _hasTeam(dynamic m, String name) {
    final home = m['teams']?['home']?['name']?.toString() ?? '';
    final away = m['teams']?['away']?['name']?.toString() ?? '';
    return home == name || away == name;
  }

  // ── Stats ──────────────────────────────────────────────────────────────────

  int get _pj => _matches.where((e) => _doneStatuses.contains(e.match['status']?['short'])).length;

  int get _ganados => _matches.where((e) {
    final s  = e.match['status']?['short'] as String? ?? '';
    if (!_doneStatuses.contains(s)) return false;
    final hs = e.match['scores']?['home'] as num?;
    final as_ = e.match['scores']?['away'] as num?;
    if (hs == null || as_ == null) return false;
    final isHome = (e.match['teams']?['home']?['name'] as String?) == widget.teamName;
    return isHome ? hs > as_ : as_ > hs;
  }).length;

  int get _perdidos => _pj - _ganados -
      _matches.where((e) {
        final s  = e.match['status']?['short'] as String? ?? '';
        if (!_doneStatuses.contains(s)) return false;
        final hs = e.match['scores']?['home'] as num?;
        final as_ = e.match['scores']?['away'] as num?;
        return hs != null && as_ != null && hs == as_;
      }).length;

  String get _primaryLeague {
    for (final e in _matches) {
      return e.league;
    }
    return '';
  }

  List<_Entry> get _live => _matches
      .where((e) => _liveStatuses.contains(e.match['status']?['short']))
      .toList();

  List<_Entry> get _recent {
    final done = _matches
        .where((e) => _doneStatuses.contains(e.match['status']?['short']))
        .toList()
      ..sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return tb.compareTo(ta);
      });
    return done.take(6).toList();
  }

  List<_Entry> get _upcoming => _matches
      .where((e) => e.match['status']?['short'] == 'NS')
      .toList()
    ..sort((a, b) {
      final ta = a.match['timestamp'] as int? ?? 0;
      final tb = b.match['timestamp'] as int? ?? 0;
      return ta.compareTo(tb);
    });

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final logoPath = clubLogo(widget.teamName);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          // ── App bar con hero ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: const Color(0xFF1B4332),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              ListenableBuilder(
                listenable: Listenable.merge([
                  FavoritesService.instance,
                  NotificationsService.instance,
                ]),
                builder: (context, _) {
                  final fav   = FavoritesService.instance.isFavorite(widget.teamName);
                  final notif = NotificationsService.instance.isSubscribed(widget.teamName);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          notif ? Icons.notifications_rounded : Icons.notifications_none_rounded,
                          color: notif ? const Color(0xFF4CAF50) : Colors.white70,
                        ),
                        tooltip: notif ? 'Desactivar notificaciones' : 'Activar notificaciones',
                        onPressed: () async {
                          final ok = await PushNotificationService.instance.toggleTeam(widget.teamName);
                          if (!ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Permití las notificaciones en el navegador para activarlas'),
                                duration: Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          fav ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: fav ? const Color(0xFFFFB300) : Colors.white70,
                        ),
                        onPressed: () => FavoritesService.instance.toggle(widget.teamName),
                      ),
                    ],
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B4332), Color(0xFF0A0A0A)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: logoPath != null
                            ? Image.asset(logoPath, fit: BoxFit.contain,
                                errorBuilder: (_, e, st) => _initials(widget.teamName))
                            : _initials(widget.teamName),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Nombre
                    Text(
                      widget.teamName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_primaryLeague.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                          border: Border.all(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _primaryLeague.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (_loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF1B4332)),
              ),
            )
          else if (_matches.isEmpty)
            const SliverFillRemaining(
              child: _NoData(),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats ───────────────────────────────────────────────────
                _StatsRow(pj: _pj, g: _ganados, p: _perdidos),

                // ── En vivo ─────────────────────────────────────────────────
                if (_live.isNotEmpty) ...[
                  _SectionHead('EN VIVO', isLive: true),
                  ..._live.map((e) => _MatchRow(entry: e, teamName: widget.teamName)),
                ],

                // ── Últimos resultados ───────────────────────────────────────
                if (_recent.isNotEmpty) ...[
                  _SectionHead('ÚLTIMOS RESULTADOS'),
                  ..._recent.map((e) => _MatchRow(entry: e, teamName: widget.teamName, isDone: true)),
                ],

                // ── Próximos ─────────────────────────────────────────────────
                if (_upcoming.isNotEmpty) ...[
                  _SectionHead('PRÓXIMOS'),
                  ..._upcoming.take(5).map((e) => _MatchRow(entry: e, teamName: widget.teamName)),
                ],

                const SizedBox(height: 32),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _initials(String name) {
    final parts = name.split(' ');
    final text  = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.substring(0, name.length.clamp(0, 2)).toUpperCase();
    return Center(
      child: Text(text,
        style: const TextStyle(
          color: Colors.white54, fontSize: 22, fontWeight: FontWeight.w900)),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int pj, g, p;
  const _StatsRow({required this.pj, required this.g, required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: Row(
        children: [
          _Stat(label: 'JUGADOS',  value: '$pj'),
          _Stat(label: 'GANADOS',  value: '$g',  color: const Color(0xFF4CAF50)),
          _Stat(label: 'PERDIDOS', value: '$p',  color: const Color(0xFFEF5350)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _Stat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
        ),
        child: Column(
          children: [
            Text(value,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              )),
            const SizedBox(height: 2),
            Text(label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              )),
          ],
        ),
      ),
    );
  }
}

// ─── Section head ─────────────────────────────────────────────────────────────

class _SectionHead extends StatelessWidget {
  final String title;
  final bool isLive;
  const _SectionHead(this.title, {this.isLive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isLive ? const Color(0xFFD32F2F) : const Color(0xFF1B4332),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(title,
              style: const TextStyle(
                color: Colors.white, fontSize: 11,
                fontWeight: FontWeight.w800, letterSpacing: 2.0)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
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
}

// ─── Tarjeta de partido ───────────────────────────────────────────────────────

class _MatchRow extends StatelessWidget {
  final _Entry entry;
  final String teamName;
  final bool   isDone;
  const _MatchRow({required this.entry, required this.teamName, this.isDone = false});

  static const _doneStatuses = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};
  static const _liveStatuses = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};

  bool get _isLive => _liveStatuses.contains(entry.match['status']?['short']);

  String _formatDate(dynamic match) {
    final raw = match['date'] as String? ?? '';
    if (raw.length < 10) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                       'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      final h = dt.hour.toString().padLeft(2, '0');
      final mn = dt.minute.toString().padLeft(2, '0');
      final time = (dt.hour == 0 && dt.minute == 0) ? '' : ' $h:$mn';
      return '${dt.day} ${months[dt.month]}$time';
    } catch (_) { return ''; }
  }

  @override
  Widget build(BuildContext context) {
    final m         = entry.match;
    final home      = m['teams']?['home']?['name'] as String? ?? '?';
    final away      = m['teams']?['away']?['name'] as String? ?? '?';
    final homeScore = m['scores']?['home'] as num?;
    final awayScore = m['scores']?['away'] as num?;
    final hasScore  = homeScore != null && awayScore != null;
    final status    = m['status']?['short'] as String? ?? '';
    final week      = m['week'] as String? ?? '';
    final dateStr   = _formatDate(m);
    final theme     = leagueThemes[entry.league];
    final leagueColor = theme?.primary ?? const Color(0xFF1B4332);

    final isMyTeamHome = home == teamName;
    final isDoneMatch  = _doneStatuses.contains(status);
    final iWon = isDoneMatch && hasScore &&
        (isMyTeamHome ? homeScore > awayScore : awayScore > homeScore);
    final iLost = isDoneMatch && hasScore && !iWon &&
        homeScore != awayScore;

    final borderColor = _isLive
        ? const Color(0xFFD32F2F)
        : iWon  ? const Color(0xFF4CAF50)
        : iLost ? const Color(0xFFEF5350)
        : Colors.transparent;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Liga + jornada + fecha
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: leagueColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: Row(
              children: [
                Text(entry.league,
                  style: TextStyle(
                    color: leagueColor, fontSize: 10,
                    fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                if (week.isNotEmpty) ...[
                  Text(' · ', style: TextStyle(color: leagueColor.withValues(alpha: 0.5), fontSize: 10)),
                  Expanded(
                    child: Text(week,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: leagueColor.withValues(alpha: 0.8),
                        fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ] else
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
                      _TeamLogo(name: home, apiUrl: m['teams']?['home']?['logo'] as String?),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(home,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: home == teamName ? Colors.white : Colors.white60,
                            fontWeight: home == teamName ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13,
                          )),
                      ),
                    ],
                  ),
                ),
                // Centro
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _isLive
                        ? const Color(0xFFD32F2F).withValues(alpha: 0.15)
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: hasScore
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$homeScore – $awayScore',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              )),
                            Text(
                              _isLive ? status : 'FT',
                              style: TextStyle(
                                color: _isLive ? const Color(0xFFFF5252) : Colors.white38,
                                fontSize: 9, fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              )),
                          ],
                        )
                      : Text(_isLive ? status : dateStr.isEmpty ? 'vs' : dateStr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          )),
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
                            color: away == teamName ? Colors.white : Colors.white60,
                            fontWeight: away == teamName ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13,
                          )),
                      ),
                      const SizedBox(width: 6),
                      _TeamLogo(name: away, apiUrl: m['teams']?['away']?['logo'] as String?),
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

class _TeamLogo extends StatelessWidget {
  final String  name;
  final String? apiUrl;
  const _TeamLogo({required this.name, this.apiUrl});

  @override
  Widget build(BuildContext context) {
    final url = clubLogo(name) ?? apiUrl;
    if (url == null) return const SizedBox(width: 22, height: 22);
    if (url.startsWith('assets/')) {
      return Image.asset(url, width: 22, height: 22, fit: BoxFit.contain,
        errorBuilder: (_, e, st) => const SizedBox(width: 22));
    }
    return Image.network(url, width: 22, height: 22, fit: BoxFit.contain,
      cacheWidth: 44,
      errorBuilder: (_, e, st) => const SizedBox(width: 22));
  }
}

// ─── Sin datos ────────────────────────────────────────────────────────────────

class _NoData extends StatelessWidget {
  const _NoData();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.sports_rugby_rounded, color: Colors.white12, size: 56),
        SizedBox(height: 16),
        Text('Sin partidos disponibles',
          style: TextStyle(color: Colors.white38, fontSize: 14)),
      ],
    ),
  );
}
