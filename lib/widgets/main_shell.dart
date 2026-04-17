import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/live_page.dart';
import '../pages/proximos_page.dart';
import 'pulse_dot.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          ProximosPage(),
          LivePage(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

// ── Barra inferior ────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: Color(0xFF1B4332), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavTab(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Inicio',
              active: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavTab(
              icon: Icons.calendar_month_outlined,
              activeIcon: Icons.calendar_month_rounded,
              label: 'Próximos',
              active: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _LiveTab(
              active: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab genérico ──────────────────────────────────────────────────────────────

class _NavTab extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF4CAF50);
    final inactiveColor = Colors.white.withValues(alpha: 0.35);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: active ? activeColor : Colors.transparent,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
              ),
            ),
            const SizedBox(height: 10),
            Icon(
              active ? activeIcon : icon,
              color: active ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? activeColor : inactiveColor,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ── Tab En Vivo (con punto pulsante) ─────────────────────────────────────────

class _LiveTab extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _LiveTab({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const activeColor = Colors.redAccent;
    final inactiveColor = Colors.white.withValues(alpha: 0.35);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: active ? activeColor : Colors.transparent,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.circle,
                  color: active ? activeColor : inactiveColor,
                  size: 16,
                ),
                if (active)
                  const Positioned(
                    top: -3, right: -5,
                    child: PulseDot(size: 7),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'En Vivo',
              style: TextStyle(
                color: active ? activeColor : inactiveColor,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
