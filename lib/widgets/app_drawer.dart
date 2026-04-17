import 'package:flutter/material.dart';
import '../pages/proximos_page.dart';
import '../pages/live_page.dart';
import 'pulse_dot.dart';
import 'rugby_logo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF071A0E),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Branding ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Row(
                children: [
                  const RugbyLogo(size: 48, color: Colors.white),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RUGBY SCORE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2.0)),
                      SizedBox(height: 3),
                      Text('Resultados · Tablas · Fixtures',
                        style: TextStyle(color: Color(0xFF4A7C59), fontSize: 9, letterSpacing: 1.0)),
                    ],
                  ),
                ],
              ),
            ),

            Container(height: 1, color: const Color(0xFF1B4332), margin: const EdgeInsets.symmetric(horizontal: 16)),
            const SizedBox(height: 16),

            // ── Nav items ─────────────────────────────────────────────────
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (r) => r.isFirst);
              },
            ),
            _NavItem(
              icon: Icons.calendar_month_rounded,
              label: 'Próximos Partidos',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProximosPage()));
              },
            ),
            _NavItem(
              icon: Icons.circle,
              label: 'En Vivo',
              isLive: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LivePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Nav item con hover ────────────────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLive = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF1B4332).withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isLive ? Colors.redAccent : Colors.white70,
                size: widget.isLive ? 14 : 20,
              ),
              const SizedBox(width: 14),
              Text(widget.label,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              if (widget.isLive) ...[
                const SizedBox(width: 8),
                const PulseDot(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

