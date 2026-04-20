import 'package:flutter/material.dart';
import '../config/leagues.dart';
import '../config/logos.dart';
import '../config/themes.dart';
import '../pages/detalle_liga.dart';
import 'urba_logo.dart';


const _fallbackTheme = LeagueTheme(
  primary:    Color(0xFF1B4332),
  accent:     Color(0xFF40916C),
  background: Color(0xFFE8F5EE),
);

Widget leagueCard(BuildContext context, String nombre) {
  final theme      = leagueThemes[nombre] ?? _fallbackTheme;
  final logoUrl    = leagueLogo(nombre);
  final logoAsset  = leagueLogoAsset(nombre);
  return _LeagueCard(nombre: nombre, theme: theme, logoUrl: logoUrl, logoAsset: logoAsset);
}

class _LeagueCard extends StatefulWidget {
  final String nombre;
  final LeagueTheme theme;
  final String? logoUrl;
  final String? logoAsset;
  const _LeagueCard({required this.nombre, required this.theme, this.logoUrl, this.logoAsset});

  @override
  State<_LeagueCard> createState() => _LeagueCardState();
}

class _LeagueCardState extends State<_LeagueCard> {
  bool _hovered = false;

  void _navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleLiga(
          nombreLiga:            widget.nombre,
          leagueId:              leagueIds[widget.nombre] ?? 0,
          theme:                 widget.theme,
          isStatic:              staticLeagues.contains(widget.nombre),
          isStaticStandingsOnly: staticStandingsOnly.contains(widget.nombre),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary  = widget.theme.primary;
    final accent   = widget.theme.accent;
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    // ── Mobile: widget estático simple (sin AnimatedScale ni hover) ───────
    if (isMobile) {
      return GestureDetector(
        onTap: _navigate,
        child: RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
                colors: [primary, Color.lerp(primary, Colors.black, 0.38)!],
              ),
              boxShadow: [
                BoxShadow(
                  color:      primary.withValues(alpha: 0.22),
                  blurRadius: 6,
                  offset:     const Offset(0, 3),
                ),
              ],
            ),
            child: _CardContent(nombre: widget.nombre, accent: accent, logoUrl: widget.logoUrl, logoAsset: widget.logoAsset),
          ),
        ),
      );
    }

    // ── Desktop: hover effects completos ──────────────────────────────────
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _navigate,
        child: AnimatedScale(
          scale:    _hovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 160),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
                colors: [
                  primary,
                  Color.lerp(primary, Colors.black, _hovered ? 0.25 : 0.35)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:      primary.withValues(alpha: _hovered ? 0.50 : 0.28),
                  blurRadius: _hovered ? 22 : 10,
                  offset:     Offset(0, _hovered ? 8 : 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -12, bottom: -12,
                  child: Icon(Icons.sports_rugby_rounded, size: 90,
                    color: Colors.white.withValues(alpha: 0.07)),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end:   Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: _hovered ? 0.10 : 0.0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                _CardContent(nombre: widget.nombre, accent: accent, logoUrl: widget.logoUrl, logoAsset: widget.logoAsset),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Contenido compartido entre mobile y desktop ───────────────────────────────

class _CardContent extends StatelessWidget {
  final String  nombre;
  final Color   accent;
  final String? logoUrl;
  final String? logoAsset;
  const _CardContent({required this.nombre, required this.accent, this.logoUrl, this.logoAsset});

  @override
  Widget build(BuildContext context) {
    final urbaLogo = urbaLogoWidget(nombre);

    // ── Logo custom URBA ───────────────────────────────────────────────────
    if (urbaLogo != null) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                child: urbaLogo,
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
                  child: Text(nombre,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                ),
                Icon(Icons.arrow_forward_rounded, size: 12,
                  color: Colors.white.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ],
      );
    }

    // ── Con logo asset local ───────────────────────────────────────────────
    if (logoAsset != null) {
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Image.asset(logoAsset!, fit: BoxFit.contain),
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
                  child: Text(nombre,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                ),
                Icon(Icons.arrow_forward_rounded, size: 12,
                  color: Colors.white.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ],
      );
    }

    // ── Con logo URL: imagen grande + nombre en barra inferior ────────────
    // Logos con diseño oscuro sobre fondo transparente → filtro blanco para que
    // contrasten sobre el gradiente oscuro de la tarjeta.
    const whiteFilterLeagues = {'Champions Cup', 'Challenge Cup'};
    final useWhiteFilter = whiteFilterLeagues.contains(nombre);

    if (logoUrl != null) {
      Widget logoWidget = Image.asset(
        logoUrl!,
        fit: BoxFit.contain,
        errorBuilder: (ctx, e, s) =>
            Icon(Icons.sports_rugby_rounded, size: 36, color: accent),
      );
      if (useWhiteFilter) {
        logoWidget = ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          child: logoWidget,
        );
      }
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: logoWidget,
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
                  child: Text(nombre,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                ),
                Icon(Icons.arrow_forward_rounded, size: 12,
                  color: Colors.white.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ],
      );
    }

    // ── Sin logo: layout original con icono ───────────────────────────────
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color:        accent.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border:       Border.all(color: accent.withValues(alpha: 0.4), width: 1),
            ),
            child: Icon(Icons.sports_rugby_rounded, size: 12, color: accent),
          ),
          const Spacer(),
          Text(
            nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color:        Colors.white,
              fontWeight:   FontWeight.w900,
              fontSize:     13.5,
              height:       1.25,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.0),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 13,
                color: Colors.white.withValues(alpha: 0.6)),
            ],
          ),
        ],
      ),
    );
  }
}
