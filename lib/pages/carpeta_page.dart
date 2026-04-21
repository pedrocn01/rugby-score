import 'package:flutter/material.dart';
import '../config/leagues.dart';
import '../widgets/league_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/urba_logo.dart';

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
            backgroundColor: const Color(0xFF1B4332),
            elevation:       0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
            iconTheme:       const IconThemeData(color: Colors.white),
            actions: [
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
            ],
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
                  final liga      = widget.ligas[index];
                  final delay     = (index * 0.08).clamp(0.0, 0.6);
                  final isFolder  = folders.containsKey(liga);
                  return AnimatedBuilder(
                    animation: _anim,
                    builder: (context, _) {
                      final t = ((_anim.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
                      return Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - t)),
                          child: isFolder
                              ? _SubFolderTile(folderName: liga)
                              : leagueCard(context, liga),
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

class _SubFolderTile extends StatelessWidget {
  final String folderName;
  const _SubFolderTile({required this.folderName});

  Color get _primary {
    switch (folderName) {
      case 'TOP 14':     return const Color(0xFF1B2F7A);
      case 'Primera A':  return const Color(0xFF0A2240);
      case 'Primera B':  return const Color(0xFFB35A00);
      case 'Primera C':  return const Color(0xFFAA1500);
      default:           return const Color(0xFF1B4332);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ligas   = folders[folderName]!;
    final primary = _primary;
    final dark    = Color.lerp(primary, Colors.black, 0.55)!;
    final logo    = urbaLogoWidget(folderName, size: 72);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => CarpetaPage(titulo: folderName, ligas: ligas),
      )),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end:   Alignment.bottomRight,
            colors: [primary, dark],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: logo ?? Icon(Icons.folder_open_rounded,
                    color: Colors.white70, size: 40),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(folderName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                  ),
                  Text('${ligas.length}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.50), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
