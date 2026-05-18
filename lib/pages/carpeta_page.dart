import 'package:flutter/material.dart';
import '../config/leagues.dart';
import '../config/themes.dart';
import '../pages/detalle_liga.dart';
import '../widgets/app_drawer.dart';
import '../widgets/urba_logo.dart';

class CarpetaPage extends StatefulWidget {
  final String titulo;
  final List<String> ligas;
  const CarpetaPage({super.key, required this.titulo, required this.ligas});

  @override
  State<CarpetaPage> createState() => _CarpetaPageState();
}

class _CarpetaPageState extends State<CarpetaPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450))
      ..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Auto-groups by G1/G2 pattern. Returns {'': all} if no pattern found.
  Map<String, List<String>> _group(List<String> items) {
    final g1 = items.where((s) => RegExp(r'\bG1\b').hasMatch(s)).toList();
    final g2 = items.where((s) => RegExp(r'\bG2\b').hasMatch(s)).toList();
    final other =
        items.where((s) => !RegExp(r'\bG[12]\b').hasMatch(s)).toList();

    if (g1.isEmpty && g2.isEmpty) return {'': items};

    final result = <String, List<String>>{};
    if (other.isNotEmpty) result[''] = other;
    if (g1.isNotEmpty) result['G1'] = g1;
    if (g2.isNotEmpty) result['G2'] = g2;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _group(widget.ligas);

    // Flatten into a list of typed entries for the SliverList
    final entries = <_Entry>[];
    grouped.forEach((groupName, items) {
      if (groupName.isNotEmpty) entries.add(_Entry.header(groupName));
      for (final item in items) {
        entries.add(_Entry.item(item, folders.containsKey(item)));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 110,
            backgroundColor: const Color(0xFF1B4332),
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
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
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0A1F13), Color(0xFF1B4332)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: Icon(Icons.folder_open_rounded,
                        size: 110,
                        color: Colors.white.withValues(alpha: 0.05)),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final entry = entries[i];
                final delay = (i * 0.04).clamp(0.0, 0.45);
                return AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) {
                    final t = ((_anim.value - delay) / (1.0 - delay))
                        .clamp(0.0, 1.0);
                    return Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, 14 * (1 - t)),
                        child: entry.isHeader
                            ? _SectionHeader(label: entry.name)
                            : entry.isFolder
                                ? _FolderRow(folderName: entry.name)
                                : _LeagueRow(leagueName: entry.name),
                      ),
                    );
                  },
                );
              },
              childCount: entries.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

// ── Entry types ───────────────────────────────────────────────────────────────

class _Entry {
  final String name;
  final bool isHeader;
  final bool isFolder;

  const _Entry.header(this.name)
      : isHeader = true,
        isFolder = false;
  const _Entry.item(this.name, this.isFolder) : isHeader = false;
}

// ── Section header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 6),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF40916C),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF40916C),
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFF40916C).withValues(alpha: 0.30),
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

// ── League row ────────────────────────────────────────────────────────────────

class _LeagueRow extends StatefulWidget {
  final String leagueName;
  const _LeagueRow({required this.leagueName});

  @override
  State<_LeagueRow> createState() => _LeagueRowState();
}

class _LeagueRowState extends State<_LeagueRow> {
  bool _hovered = false;

  void _navigate(BuildContext context) {
    const fallback = LeagueTheme(
      primary: Color(0xFF1B4332),
      accent: Color(0xFF40916C),
      background: Color(0xFFE8F5EE),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleLiga(
          nombreLiga: widget.leagueName,
          leagueId: leagueIds[widget.leagueName] ?? 0,
          theme: leagueThemes[widget.leagueName] ?? fallback,
          isStatic: staticLeagues.contains(widget.leagueName),
          isStaticStandingsOnly:
              staticStandingsOnly.contains(widget.leagueName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => _navigate(context),
        splashColor: const Color(0xFF1B4332).withValues(alpha: 0.2),
        highlightColor: const Color(0xFF1B4332).withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF1B4332).withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: _hovered
                    ? const Color(0xFF40916C)
                    : const Color(0xFF263D2F),
                width: 3,
              ),
              bottom: BorderSide(
                color: const Color(0xFF1A1A1A),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.leagueName,
                  style: TextStyle(
                    color: _hovered
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 140),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: _hovered
                      ? const Color(0xFF40916C)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Folder row (sub-carpetas) ─────────────────────────────────────────────────

class _FolderRow extends StatefulWidget {
  final String folderName;
  const _FolderRow({required this.folderName});

  @override
  State<_FolderRow> createState() => _FolderRowState();
}

class _FolderRowState extends State<_FolderRow> {
  bool _hovered = false;

  Color get _accent {
    switch (widget.folderName) {
      case 'TOP 14':    return const Color(0xFF1B2F7A);
      case 'Primera A': return const Color(0xFF0A2240);
      case 'Primera B': return const Color(0xFFB35A00);
      case 'Primera C': return const Color(0xFFAA1500);
      case 'Segunda':   return const Color(0xFF003A70);
      case 'Tercera':   return const Color(0xFF1B5E20);
      case 'Desarrollo':return const Color(0xFF00695C);
      case 'Femenino':  return const Color(0xFF880E4F);
      case 'M-19':      return const Color(0xFFB84800);
      case 'M-17':      return const Color(0xFF9E3700);
      case 'M-16':      return const Color(0xFF8A2F00);
      case 'M-15':      return const Color(0xFF742600);
      default:          return const Color(0xFF1B4332);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ligas = folders[widget.folderName]!;
    final accent = _accent;
    final logo = urbaLogoWidget(widget.folderName, size: 28);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CarpetaPage(titulo: widget.folderName, ligas: ligas),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  accent,
                  Color.lerp(accent, Colors.black, _hovered ? 0.30 : 0.48)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: _hovered ? 0.35 : 0.12),
                  blurRadius: _hovered ? 14 : 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: logo ??
                      const Icon(Icons.folder_open_rounded,
                          color: Colors.white70, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.folderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    '${ligas.length}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: _hovered ? 0.8 : 0.35),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
