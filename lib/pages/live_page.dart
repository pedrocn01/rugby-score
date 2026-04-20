import 'dart:async';
import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../services/match_cache.dart';
import '../widgets/pulse_dot.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  List<MatchEntry> _live = [];
  bool _loading = true;
  bool _fetching = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    // Refresca cada 60 segundos
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (_fetching) return;
    _fetching = true;
    if (!silent) setState(() => _loading = true);
    try {
      await MatchCache.instance.fetchAll(force: true);
      if (mounted) {
        final fresh = MatchCache.instance.getLive();
        if (fresh.length != _live.length || _loading) {
          setState(() { _live = fresh; _loading = false; });
        } else {
          _loading = false;
        }
      }
    } finally {
      _fetching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF1A0505),
            elevation: 0,
            title: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EN VIVO',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                        fontSize: 15, letterSpacing: 2.5)),
                    Text('Partidos en curso',
                      style: TextStyle(color: Color(0xFF994444), fontSize: 9, letterSpacing: 1.5)),
                  ],
                ),
                const SizedBox(width: 10),
                const PulseDot(size: 10),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                onPressed: _load,
                tooltip: 'Actualizar',
              ),
            ],
          ),

          // ── Contenido ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _loading
                ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.redAccent),
                          SizedBox(height: 16),
                          Text('Buscando partidos en vivo…',
                            style: TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                    ),
                  )
                : _live.isEmpty
                    ? const SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sports_rugby_rounded, color: Colors.white12, size: 56),
                              SizedBox(height: 16),
                              Text('No hay partidos en vivo ahora',
                                style: TextStyle(color: Colors.white38, fontSize: 14)),
                              SizedBox(height: 8),
                              Text('Se actualiza cada 60 segundos',
                                style: TextStyle(color: Colors.white24, fontSize: 11)),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 16),
                          ..._live.map((e) => _LiveCard(key: ValueKey(e.match['id']), entry: e)),
                          const SizedBox(height: 32),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de partido en vivo ────────────────────────────────────────────────

class _LiveCard extends StatelessWidget {
  final MatchEntry entry;
  const _LiveCard({super.key, required this.entry});

  String _statusLabel(String s) {
    return switch (s) {
      '1H'  => '1er Tiempo',
      'HT'  => 'Descanso',
      '2H'  => '2do Tiempo',
      'ET'  => 'Prórroga',
      'BT'  => 'Descanso ET',
      'P'   => 'Penales',
      _     => s,
    };
  }

  @override
  Widget build(BuildContext context) {
    final m            = entry.match;
    final home         = m['teams']?['home']?['name'] as String? ?? 'Local';
    final away         = m['teams']?['away']?['name'] as String? ?? 'Visitante';
    final homeLogoUrl  = clubLogo(home) ?? m['teams']?['home']?['logo']?.toString();
    final awayLogoUrl  = clubLogo(away) ?? m['teams']?['away']?['logo']?.toString();
    final homeScore    = m['scores']?['home'] ?? '-';
    final awayScore    = m['scores']?['away'] ?? '-';
    final status       = m['status']?['short'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Liga + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.league,
                  style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 10,
                    fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 6, height: 6,
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Text(_statusLabel(status),
                        style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Score row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (homeLogoUrl != null)
                        homeLogoUrl.startsWith('assets/')
                          ? Image.asset(homeLogoUrl, width: 32, height: 32, fit: BoxFit.contain)
                          : Image.network(homeLogoUrl, width: 32, height: 32, fit: BoxFit.contain,
                              cacheWidth: 64, cacheHeight: 64,
                              errorBuilder: (_, e, s) => const SizedBox(height: 32)),
                      const SizedBox(height: 4),
                      Text(home, textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Text('$homeScore - $awayScore',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                      fontSize: 20, letterSpacing: 1.5)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (awayLogoUrl != null)
                        awayLogoUrl.startsWith('assets/')
                          ? Image.asset(awayLogoUrl, width: 32, height: 32, fit: BoxFit.contain)
                          : Image.network(awayLogoUrl, width: 32, height: 32, fit: BoxFit.contain,
                              cacheWidth: 64, cacheHeight: 64,
                              errorBuilder: (_, e, s) => const SizedBox(height: 32)),
                      const SizedBox(height: 4),
                      Text(away, textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

