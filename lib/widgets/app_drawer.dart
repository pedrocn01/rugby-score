import 'package:flutter/material.dart';
import '../pages/proximos_page.dart';
import '../pages/live_page.dart';

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
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B4332),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.sports_rugby_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RUGBY SCORE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2.0)),
                      SizedBox(height: 2),
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
                _PulseDot(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Punto rojo pulsante ───────────────────────────────────────────────────────

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Container(
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: Color.lerp(Colors.redAccent, Colors.red.shade900, _anim.value),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.6 * (1 - _anim.value)),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
