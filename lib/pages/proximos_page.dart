import 'package:flutter/material.dart';
import '../services/match_cache.dart';
import '../widgets/app_drawer.dart';

class ProximosPage extends StatefulWidget {
  const ProximosPage({super.key});

  @override
  State<ProximosPage> createState() => _ProximosPageState();
}

class _ProximosPageState extends State<ProximosPage> {
  late Future<Map<String, List<dynamic>>> _future;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _future = MatchCache.instance.fetchAll(force: true);
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    final data = await MatchCache.instance.fetchAll(force: true);
    if (mounted) {
      setState(() {
        _refreshing = false;
        _future = Future.value(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF1B4332),
            elevation: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRÓXIMOS PARTIDOS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                    fontSize: 15, letterSpacing: 2.5)),
                Text('Todos los torneos',
                  style: TextStyle(color: Color(0xFF4A7C59), fontSize: 9, letterSpacing: 1.5)),
              ],
            ),
            actions: [
              _refreshing
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2)),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                      onPressed: _refresh,
                      tooltip: 'Actualizar',
                    ),
            ],
          ),

          // ── Contenido ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FutureBuilder<Map<String, List<dynamic>>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF1B4332)),
                          SizedBox(height: 16),
                          Text('Cargando partidos…',
                            style: TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                }

                final byDate = MatchCache.instance.getUpcoming();
                if (byDate.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, color: Colors.white24, size: 48),
                          SizedBox(height: 16),
                          Text('No hay próximos partidos',
                            style: TextStyle(color: Colors.white38, fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                }

                final sortedDates = byDate.keys.toList()..sort();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final dateStr in sortedDates) ...[
                      _DateHeader(dateStr: dateStr),
                      _MatchesByLeague(entries: byDate[dateStr]!),
                    ],
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Encabezado de fecha ───────────────────────────────────────────────────────

class _DateHeader extends StatelessWidget {
  final String dateStr;
  const _DateHeader({required this.dateStr});

  @override
  Widget build(BuildContext context) {
    final date   = DateTime.parse(dateStr);
    final now    = DateTime.now();
    final today  = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    String label;
    if (date.isAtSameMomentAs(today)) {
      label = 'HOY';
    } else if (date.isAtSameMomentAs(tomorrow)) {
      label = 'MAÑANA';
    } else {
      const days = ['', 'LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];
      const months = ['', 'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
                       'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
      label = '${days[date.weekday]} ${date.day} ${months[date.month]}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF1B4332),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800,
                fontSize: 11, letterSpacing: 2.0)),
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

// ── Matches agrupados por liga dentro de un día ───────────────────────────────

class _MatchesByLeague extends StatelessWidget {
  final List<MatchEntry> entries;
  const _MatchesByLeague({required this.entries});

  @override
  Widget build(BuildContext context) {
    // Agrupar por liga manteniendo el orden de aparición
    final Map<String, List<dynamic>> byLeague = {};
    for (final e in entries) {
      byLeague.putIfAbsent(e.league, () => []);
      byLeague[e.league]!.add(e.match);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final league in byLeague.keys) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(league,
              style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          ),
          for (final match in byLeague[league]!) _ProximoCard(match: match),
        ],
      ],
    );
  }
}

// ── Tarjeta de partido próximo ────────────────────────────────────────────────

class _ProximoCard extends StatelessWidget {
  final dynamic match;
  const _ProximoCard({required this.match});

  String _formatHora(String? date) {
    if (date == null || date.length < 16) return '';
    try {
      final dt = DateTime.parse(date).toLocal();
      final h  = dt.hour.toString().padLeft(2, '0');
      final m  = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final home         = match['teams']?['home']?['name'] as String? ?? 'Local';
    final away         = match['teams']?['away']?['name'] as String? ?? 'Visitante';
    final homeLogoUrl  = match['teams']?['home']?['logo'] as String?;
    final awayLogoUrl  = match['teams']?['away']?['logo'] as String?;
    final hora         = _formatHora(match['date'] as String?);
    final status       = match['status']?['short'] as String? ?? 'NS';
    final homeScore    = match['scores']?['home'];
    final awayScore    = match['scores']?['away'];

    const liveStatuses = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};
    const doneStatuses = {'FT', 'AET', 'PEN', 'AWD', 'Canc'};
    final isLive = liveStatuses.contains(status);
    final isDone = doneStatuses.contains(status);
    final hasScore = homeScore != null && awayScore != null;

    // Color del indicador izquierdo según estado
    final Color leftColor = isLive
        ? Colors.redAccent
        : isDone
            ? const Color(0xFF555555)
            : const Color(0xFF4A7C59);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLive ? Colors.redAccent.withValues(alpha: 0.4) : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: [
          // Hora / Marcador / Estado
          SizedBox(
            width: 48,
            child: hasScore
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$homeScore',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: leftColor, fontWeight: FontWeight.w900, fontSize: 14)),
                      Text('$awayScore',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: leftColor, fontWeight: FontWeight.w900, fontSize: 14)),
                    ],
                  )
                : Text(hora,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: leftColor, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
          Container(width: 1, height: 32, color: const Color(0xFF2A2A2A),
            margin: const EdgeInsets.symmetric(horizontal: 12)),
          // Equipos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (homeLogoUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Image.network(homeLogoUrl, width: 18, height: 18, fit: BoxFit.contain,
                          errorBuilder: (_, e, s) => const SizedBox(width: 18)),
                      ),
                    Expanded(
                      child: Text(home,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isDone && hasScore && (homeScore > awayScore) ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (awayLogoUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Image.network(awayLogoUrl, width: 18, height: 18, fit: BoxFit.contain,
                          errorBuilder: (_, e, s) => const SizedBox(width: 18)),
                      ),
                    Expanded(
                      child: Text(away,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontWeight: isDone && hasScore && (awayScore > homeScore) ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Badge estado
          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
              ),
              child: Text(_statusLabel(status),
                style: const TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.w800)),
            )
          else if (isDone)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('FT',
                style: TextStyle(color: Color(0xFF888888), fontSize: 9, fontWeight: FontWeight.w700)),
            )
          else
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF333333), size: 20),
        ],
      ),
    );
  }

  String _statusLabel(String s) => switch (s) {
    '1H' => '1T', 'HT' => 'HT', '2H' => '2T',
    'ET' => 'PR', 'BT' => 'ET', 'P'  => 'PEN',
    _ => s,
  };
}
