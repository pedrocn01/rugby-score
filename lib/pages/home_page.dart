import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/leagues.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../widgets/league_card.dart';
import '../widgets/rugby_logo.dart';
import 'carpeta_page.dart';
import 'detalle_liga.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: CustomScrollView(
        slivers: [
          // ─── Header ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned:          true,
            backgroundColor: const Color(0xFF1B4332),
            elevation:       0,
            iconTheme:       const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                tooltip: 'Buscar equipo',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                ),
              ),
            ],
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RugbyLogo(size: 32, color: Colors.white),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RUGBY SCORE',
                      style: TextStyle(
                        color:        Colors.white,
                        fontWeight:   FontWeight.w900,
                        fontSize:     15,
                        letterSpacing: 3.0,
                      ),
                    ),
                    Text(
                      'Resultados · Tablas · Fixtures',
                      style: TextStyle(
                        color:        Colors.white.withValues(alpha: 0.6),
                        fontSize:     8,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Secciones en carousel ─────────────────────────────────────────
          SliverList(
            delegate: SliverChildListDelegate(
              sections.entries.toList().asMap().entries.map((indexed) {
                final delay = indexed.key * 0.15;
                return _AnimatedSection(
                  delay:    delay,
                  fadeAnim: _fadeAnim,
                  child:    _buildSection(context, indexed.value.key, indexed.value.value),
                );
              }).toList(),
            ),
          ),

          // ─── Footer ────────────────────────────────────────────────────────
          const SliverToBoxAdapter(child: _FooterWidget()),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String titulo, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label de sección ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4332),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color:        Colors.white,
                      fontWeight:   FontWeight.w800,
                      fontSize:     10,
                      letterSpacing: 2.0,
                    ),
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
                const SizedBox(width: 16),
              ],
            ),
          ),
          // ── Carousel horizontal ──────────────────────────────────
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 6),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 130,
                    child: folders.containsKey(item)
                        ? _FolderTile(folderName: item)
                        : leagueCard(ctx, item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Folder tile (mismo tamaño que league card) ───────────────────────────────

class _FolderTile extends StatefulWidget {
  final String folderName;
  const _FolderTile({required this.folderName});

  @override
  State<_FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<_FolderTile> {
  bool _hovered = false;

  Color get _primary {
    switch (widget.folderName) {
      case 'Circuito 7s':        return const Color(0xFFFF6B00);
      case 'Torneo del Interior': return const Color(0xFF004B87);
      default:                   return const Color(0xFF1B4332);
    }
  }
  Color get _dark {
    switch (widget.folderName) {
      case 'Circuito 7s':        return const Color(0xFFCC4400);
      case 'Torneo del Interior': return const Color(0xFF001D3D);
      default:                   return const Color(0xFF071A0E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ligas      = folders[widget.folderName]!;
    final logoUrl    = folderLogoUrls[widget.folderName];
    final logoAsset  = folderLogoAssets[widget.folderName];
    final isMobile = MediaQuery.of(context).size.width < 700;

    void onTap() {
      if (ligas.length == 1) {
        final ligaNombre = ligas[0];
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => DetalleLiga(
            nombreLiga:            ligaNombre,
            leagueId:              leagueIds[ligaNombre] ?? 0,
            theme:                 leagueThemes[ligaNombre] ?? const LeagueTheme(
              primary:    Color(0xFF1B4332),
              accent:     Color(0xFF40916C),
              background: Color(0xFFE8F5EE),
            ),
            isStatic:              staticLeagues.contains(ligaNombre),
            isStaticStandingsOnly: staticStandingsOnly.contains(ligaNombre),
          ),
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => CarpetaPage(titulo: widget.folderName, ligas: ligas),
        ));
      }
    }

    if (isMobile) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primary, _dark],
            ),
          ),
          child: logoAsset != null ? _logoAssetContent(logoAsset, ligas) : logoUrl != null ? _logoContent(logoUrl, ligas) : _iconContent(ligas),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale:    _hovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 160),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
                colors: [
                  _primary,
                  Color.lerp(_primary, _dark, _hovered ? 0.3 : 0.5)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:      _primary.withValues(alpha: _hovered ? 0.6 : 0.3),
                  blurRadius: _hovered ? 20 : 8,
                  offset:     Offset(0, _hovered ? 6 : 3),
                ),
              ],
            ),
            child: logoAsset != null ? _logoAssetContent(logoAsset, ligas) : logoUrl != null ? _logoContent(logoUrl, ligas) : _iconContent(ligas),
          ),
        ),
      ),
    );
  }

  Widget _logoContent(String logoUrl, List<String> ligas) => Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
          child: Image.asset(logoUrl, fit: BoxFit.contain,
            errorBuilder: (ctx, e, s) => const Icon(Icons.folder_open_rounded, color: Colors.white54, size: 36)),
        ),
      ),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Row(children: [
          Expanded(child: Text(widget.folderName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
            child: Text('${ligas.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 9)),
          ),
        ]),
      ),
    ],
  );

  Widget _logoAssetContent(String assetPath, List<String> ligas) => Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
          child: SvgPicture.asset(assetPath, fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        ),
      ),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Row(children: [
          Expanded(child: Text(widget.folderName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
            child: Text('${ligas.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 9)),
          ),
        ]),
      ),
    ],
  );

  Widget _iconContent(List<String> ligas) => Stack(
    children: [
      Positioned(right: -6, bottom: -6,
        child: Icon(Icons.folder_open_rounded, size: 60, color: Colors.white.withValues(alpha: 0.07))),
      Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.folder_open_rounded, color: Colors.white70, size: 24),
            const Spacer(),
            Text(widget.folderName, maxLines: 2,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, height: 1.2)),
            const SizedBox(height: 4),
            Text('${ligas.length} torneos',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 10)),
          ],
        ),
      ),
    ],
  );
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
        border: Border(top: BorderSide(color: const Color(0xFF1B4332).withValues(alpha: 0.4), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo / nombre ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: const Color(0xFF1B4332), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.sports_rugby_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'RUGBY SCORE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Resultados, tablas y fixtures del rugby argentino y mundial.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
          ),

          const SizedBox(height: 28),
          Container(height: 1, color: const Color(0xFF222222)),
          const SizedBox(height: 24),

          // ── Contacto ────────────────────────────────────────────────────
          Text(
            'CONTACTO',
            style: TextStyle(
              color:        const Color(0xFF1B4332).withValues(alpha: 0.8),
              fontWeight:   FontWeight.w800,
              fontSize:     10,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.mail_outline_rounded, size: 16, color: Colors.white.withValues(alpha: 0.35)),
              const SizedBox(width: 8),
              Text(
                'rugbyscore01@gmail.com',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.60), fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 28),
          Container(height: 1, color: const Color(0xFF222222)),
          const SizedBox(height: 16),

          // ── Copyright ───────────────────────────────────────────────────
          Text(
            '© ${DateTime.now().year} Rugby Score. Datos provistos por api-sports.io.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.20), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ── Animación de entrada ──────────────────────────────────────────────────────

class _AnimatedSection extends StatelessWidget {
  final double delay;
  final Animation<double> fadeAnim;
  final Widget child;
  const _AnimatedSection({required this.delay, required this.fadeAnim, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnim,
      child: child,
      builder: (context, child) {
        final t = ((fadeAnim.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 20 * (1 - t)), child: child),
        );
      },
    );
  }
}
