import 'package:flutter/material.dart';
import '../widgets/league_card.dart';
import '../widgets/app_drawer.dart';

class CarpetaPage extends StatefulWidget {
  final String titulo;
  final List<String> ligas;

  const CarpetaPage({super.key, required this.titulo, required this.ligas});

  @override
  State<CarpetaPage> createState() => _CarpetaPageState();
}

class _CarpetaPageState extends State<CarpetaPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned:          true,
            expandedHeight:  110,
            backgroundColor: const Color(0xFF0A1F13),
            elevation:       0,
            iconTheme:       const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 18),
              title: Text(
                widget.titulo,
                style: const TextStyle(
                  color:        Colors.white,
                  fontWeight:   FontWeight.w900,
                  fontSize:     16,
                  letterSpacing: 1.5,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin:  Alignment.topLeft,
                        end:    Alignment.bottomRight,
                        colors: [Color(0xFF0A1F13), Color(0xFF1B4332)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -15, bottom: -15,
                    child: Icon(Icons.folder_open_rounded, size: 110, color: Colors.white.withValues(alpha: 0.05)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 40),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                crossAxisSpacing:   10,
                mainAxisSpacing:    10,
                childAspectRatio:   1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final liga  = widget.ligas[index];
                  final delay = (index * 0.08).clamp(0.0, 0.6);
                  return AnimatedBuilder(
                    animation: _anim,
                    builder: (context, _) {
                      final t = ((_anim.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
                      return Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - t)),
                          child: leagueCard(context, liga),
                        ),
                      );
                    },
                  );
                },
                childCount: widget.ligas.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
