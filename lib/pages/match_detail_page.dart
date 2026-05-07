import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../services/match_cache.dart';
import '../services/urba_service.dart';
import 'team_detail_page.dart';

class _Entry {
  final String league;
  final dynamic match;
  const _Entry(this.league, this.match);
}

class MatchDetailPage extends StatefulWidget {
  final dynamic match;
  final String league;
  const MatchDetailPage({super.key, required this.match, required this.league});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  static const _urbaLeagues  = ['URBA Top 14', 'URBA Primera A', 'URBA Primera B', 'URBA Primera C'];
  static const _doneStatuses = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};
  static const _liveStatuses = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};

  bool _loading = true;
  final List<_Entry> _homeHistory = [];
  final List<_Entry> _awayHistory = [];

  late String _homeName;
  late String _awayName;

  @override
  void initState() {
    super.initState();
    _homeName = widget.match['teams']?['home']?['name'] as String? ?? 'Local';
    _awayName = widget.match['teams']?['away']?['name'] as String? ?? 'Visitante';
    _loadData();
  }

  Future<void> _loadData() async {
    final homeAll = <_Entry>[];
    final awayAll = <_Entry>[];

    final cache = await MatchCache.instance.fetchAll();
    for (final e in cache.entries) {
      for (final m in e.value) {
        if (_hasTeam(m, _homeName)) homeAll.add(_Entry(e.key, m));
        if (_hasTeam(m, _awayName)) awayAll.add(_Entry(e.key, m));
      }
    }

    final urba = UrbaService();
    final results = await Future.wait(
      _urbaLeagues.map((l) => urba.fetchMatches(l).catchError((_) => <dynamic>[])),
    );
    for (int i = 0; i < _urbaLeagues.length; i++) {
      for (final m in results[i]) {
        if (_hasTeam(m, _homeName)) homeAll.add(_Entry(_urbaLeagues[i], m));
        if (_hasTeam(m, _awayName)) awayAll.add(_Entry(_urbaLeagues[i], m));
      }
    }

    if (!mounted) return;
    setState(() {
      _homeHistory.addAll(_recentOf(homeAll));
      _awayHistory.addAll(_recentOf(awayAll));
      _loading = false;
    });
  }

  bool _hasTeam(dynamic m, String name) {
    final home = m['teams']?['home']?['name']?.toString() ?? '';
    final away = m['teams']?['away']?['name']?.toString() ?? '';
    return home == name || away == name;
  }

  List<_Entry> _recentOf(List<_Entry> all) {
    return (all
        .where((e) => _doneStatuses.contains(e.match['status']?['short']))
        .toList()
      ..sort((a, b) {
        final ta = a.match['timestamp'] as int? ?? 0;
        final tb = b.match['timestamp'] as int? ?? 0;
        return tb.compareTo(ta);
      }))
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final m           = widget.match;
    final homeScore   = m['scores']?['home'];
    final awayScore   = m['scores']?['away'];
    final hasScore    = homeScore != null && awayScore != null;
    final status      = m['status']?['short'] as String? ?? '';
    final isLive      = _liveStatuses.contains(status);
    final theme       = leagueThemes[widget.league];
    final leagueColor = theme?.primary ?? const Color(0xFF1B4332);
    final homeLogoUrl = clubLogo(_homeName) ?? m['teams']?['home']?['logo']?.toString();
    final awayLogoUrl = clubLogo(_awayName) ?? m['teams']?['away']?['logo']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: leagueColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [leagueColor, const Color(0xFF0A0A0A)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(widget.league.toUpperCase(),
                            style: const TextStyle(color: Colors.white70, fontSize: 9,
                              fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => TeamDetailPage(teamName: _homeName))),
                                child: Column(
                                  children: [
                                    _Logo(url: homeLogoUrl, name: _homeName, size: 48),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(_homeName,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w800, fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: hasScore
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('$homeScore – $awayScore',
                                          style: const TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: 1)),
                                        Text(isLive ? status : 'FT',
                                          style: TextStyle(
                                            color: isLive ? const Color(0xFFFF5252) : Colors.white38,
                                            fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                                      ],
                                    )
                                  : Text('VS',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20)),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => TeamDetailPage(teamName: _awayName))),
                                child: Column(
                                  children: [
                                    _Logo(url: awayLogoUrl, name: _awayName, size: 48),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(_awayName,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white70,
                                          fontWeight: FontWeight.w700, fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF1B4332))),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate([
                _SectionHead(_homeName),
                if (_homeHistory.isEmpty) const _NoMatches(),
                ..._homeHistory.map((e) => _MatchRow(entry: e, teamName: _homeName)),

                _SectionHead(_awayName),
                if (_awayHistory.isEmpty) const _NoMatches(),
                ..._awayHistory.map((e) => _MatchRow(entry: e, teamName: _awayName)),

                const SizedBox(height: 32),
              ]),
            ),
        ],
      ),
    );
  }
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  final String? url;
  final String  name;
  final double  size;
  const _Logo({required this.url, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    if (url == null) return _initials(name, size);
    if (url!.startsWith('assets/')) {
      return Image.asset(url!, width: size, height: size, fit: BoxFit.contain,
        errorBuilder: (_, e, s) => _initials(name, size));
    }
    return Image.network(url!, width: size, height: size, fit: BoxFit.contain,
      cacheWidth: (size * 2).toInt(),
      errorBuilder: (_, e, s) => _initials(name, size));
  }

  Widget _initials(String n, double s) {
    final parts = n.split(' ');
    final text  = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : n.substring(0, n.length.clamp(0, 2)).toUpperCase();
    return SizedBox(
      width: s, height: s,
      child: Center(
        child: Text(text,
          style: TextStyle(color: Colors.white54,
            fontSize: s * 0.35, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

// ─── Section head ─────────────────────────────────────────────────────────────

class _SectionHead extends StatelessWidget {
  final String title;
  const _SectionHead(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1B4332),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10,
                  fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            ),
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

// ─── Match row ────────────────────────────────────────────────────────────────

class _MatchRow extends StatelessWidget {
  final _Entry entry;
  final String teamName;
  const _MatchRow({required this.entry, required this.teamName});

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
      final h  = dt.hour.toString().padLeft(2, '0');
      final mn = dt.minute.toString().padLeft(2, '0');
      final time = (dt.hour == 0 && dt.minute == 0) ? '' : ' $h:$mn';
      return '${dt.day} ${months[dt.month]}$time';
    } catch (_) {
      return '';
    }
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

    final isMyHome  = home == teamName;
    final isDone    = _doneStatuses.contains(status);
    final iWon      = isDone && hasScore &&
        (isMyHome ? homeScore > awayScore : awayScore > homeScore);
    final iLost     = isDone && hasScore && !iWon && homeScore != awayScore;

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: leagueColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: Row(
              children: [
                Text(entry.league,
                  style: TextStyle(color: leagueColor, fontSize: 10,
                    fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                if (week.isNotEmpty) ...[
                  Text(' · ', style: TextStyle(color: leagueColor.withValues(alpha: 0.5), fontSize: 10)),
                  Expanded(
                    child: Text(week, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: leagueColor.withValues(alpha: 0.8),
                        fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ] else
                  const Spacer(),
                Text(dateStr, style: const TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _TeamLogo(name: home, apiUrl: m['teams']?['home']?['logo'] as String?),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(home, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: home == teamName ? Colors.white : Colors.white60,
                            fontWeight: home == teamName ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13)),
                      ),
                    ],
                  ),
                ),
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
                              style: const TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.5)),
                            Text(_isLive ? status : 'FT',
                              style: TextStyle(
                                color: _isLive ? const Color(0xFFFF5252) : Colors.white38,
                                fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                          ],
                        )
                      : Text(_isLive ? status : dateStr.isEmpty ? 'vs' : dateStr,
                          style: const TextStyle(color: Colors.white38,
                            fontWeight: FontWeight.w700, fontSize: 12)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(away, textAlign: TextAlign.end, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: away == teamName ? Colors.white : Colors.white60,
                            fontWeight: away == teamName ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13)),
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

// ─── Team logo ────────────────────────────────────────────────────────────────

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
        errorBuilder: (_, e, s) => const SizedBox(width: 22));
    }
    return Image.network(url, width: 22, height: 22, fit: BoxFit.contain,
      cacheWidth: 44,
      errorBuilder: (_, e, s) => const SizedBox(width: 22));
  }
}

// ─── Sin partidos ─────────────────────────────────────────────────────────────

class _NoMatches extends StatelessWidget {
  const _NoMatches();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
    child: Text('Sin resultados recientes',
      style: TextStyle(color: Colors.white24, fontSize: 12)),
  );
}
