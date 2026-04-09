import 'package:flutter/material.dart';
import '../config/leagues.dart';
import '../config/themes.dart';
import '../pages/detalle_liga.dart';

const _fallbackTheme = LeagueTheme(
  primary:    Color(0xFF1B4332),
  accent:     Color(0xFF40916C),
  background: Color(0xFFE8F5EE),
);

/// Card de liga en formato tile (para grillas).
Widget leagueCard(BuildContext context, String nombre) {
  final theme = leagueThemes[nombre] ?? _fallbackTheme;
  return _LeagueCard(nombre: nombre, theme: theme);
}

class _LeagueCard extends StatefulWidget {
  final String nombre;
  final LeagueTheme theme;
  const _LeagueCard({required this.nombre, required this.theme});

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
    final primary = widget.theme.primary;
    final accent  = widget.theme.accent;

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
                // ── Watermark ───────────────────────────────────────────
                Positioned(
                  right: -12, bottom: -12,
                  child: Icon(
                    Icons.sports_rugby_rounded,
                    size:  90,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
                // ── Brillo en hover ─────────────────────────────────────
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
                // ── Contenido ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Accent pill / badge
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
                      // Nombre
                      Text(
                        widget.nombre,
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
                      // Arrow indicador
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
                          Icon(
                            Icons.arrow_forward_rounded,
                            size:  13,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
