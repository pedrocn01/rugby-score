import 'package:flutter/material.dart';
import '../config/leagues.dart';
import '../config/logos.dart';
import '../widgets/app_drawer.dart';
import '../widgets/urba_logo.dart';
import '../config/themes.dart';
import '../data/static_data.dart';
import '../services/rugby_service.dart';
import '../services/urba_service.dart';

class DetalleLiga extends StatefulWidget {
  final String nombreLiga;
  final int leagueId;
  final LeagueTheme theme;
  final bool isStatic;
  final bool isStaticStandingsOnly;

  const DetalleLiga({
    super.key,
    required this.nombreLiga,
    required this.leagueId,
    required this.theme,
    this.isStatic = false,
    this.isStaticStandingsOnly = false,
  });

  @override
  State<DetalleLiga> createState() => _DetalleLigaState();
}

class _DetalleLigaState extends State<DetalleLiga> {
  final RugbyService _service = RugbyService();
  final UrbaService  _urba   = UrbaService();
  late Future<List<dynamic>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData({bool noCache = false}) {
    if (urbaApiStandingsLeagues.contains(widget.nombreLiga)) {
      _matchesFuture = _urba.fetchMatches(widget.nombreLiga);
    } else if (widget.isStatic) {
      _matchesFuture = Future.value(StaticDataService.getMatches(widget.nombreLiga));
    } else {
      _matchesFuture = _service.fetchMatches(widget.leagueId, noCache: noCache);
    }
  }

  void _refresh() {
    setState(() => _loadData(noCache: true));
  }

  // ── Filtro de partidos — solo competencia principal (7s) ─────────────────

  bool _isMainDrawMatch(dynamic partido) {
    final week = partido['week']?.toString().toLowerCase() ?? '';
    if (week.isEmpty) return true;      // null week = pool match SVNS
    if (week.startsWith('pool')) return true;
    // Exclusiones antes del chequeo de "svns" para que "SVNS City - Plate/Bowl/..." queden afuera
    if (week.contains('plate')) return false;
    if (week.contains('bowl')) return false;
    if (week.contains('shield')) return false;
    if (week.contains('challenge')) return false;
    if (week.contains('svns')) return true;
    if (week.contains('cup')) return true;
    return true;
  }

  // ── Formateo de fechas ───────────────────────────────────────────────────

  String _formatFecha(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const dias   = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      const meses  = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
      return '${dias[dt.weekday - 1]} ${dt.day} ${meses[dt.month - 1]}';
    } catch (_) {
      return dateStr.substring(0, 10);
    }
  }

  String _formatHora(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  // ── Etiquetas de jornada ────────────────────────────────────────────────

  String _labelJornada(String week) {
    final num = int.tryParse(week);
    if (num != null) return 'FECHA $num';
    // Formato SVNS: "SVNS City - Phase" → extraer fase
    final w = week.toLowerCase();
    if (w == 'fase de grupos') return 'FASE DE GRUPOS';
    if (w.contains('svns')) {
      if (w.endsWith('- final'))       return 'FINAL';
      if (w.endsWith('- semi-finals')) return 'SEMIFINALES';
      if (w.endsWith('- 3rd place'))   return 'TERCER PUESTO';
      if (w.endsWith('- 5th place'))   return '5º PUESTO';
      if (w.endsWith('- 7th place'))   return '7º PUESTO';
      if (w.endsWith('- 9th place'))   return '9º PUESTO';
      if (w.contains('quarter'))       return 'CUARTOS DE FINAL';
    }
    const fases = {
      'quarter-finals':     'CUARTOS DE FINAL',
      'semi-finals':        'SEMIFINALES',
      'final':              'FINAL',
      'bronze final':       'TERCER PUESTO',
      'round of 16':        'OCTAVOS DE FINAL',
      'round-of-16':        'OCTAVOS DE FINAL',
      'playoffs':           'PLAYOFFS',
      'octavos':            'OCTAVOS DE FINAL',
      // 7s pools
      'pool a':             'POOL A',
      'pool b':             'POOL B',
      'pool c':             'POOL C',
      'pool d':             'POOL D',
      // 7s Cup knockouts
      'cup quarter-finals':   'CUARTOS — CUP',
      'cup semi-finals':      'SEMIFINALES — CUP',
      'cup final':            'FINAL — CUP',
      // 7s otras ramas
      '5th place':            '5º PUESTO',
      '7th place':            '7º PUESTO',
      '9th place':            '9º PUESTO',
      'plate quarter-finals': 'CUARTOS — PLATE',
      'plate semi-finals':    'SEMIFINALES — PLATE',
      'plate final':          'FINAL — PLATE',
      'bowl semi-finals':     'SEMIFINALES — BOWL',
      'bowl final':           'FINAL — BOWL',
      'shield final':         'FINAL — SHIELD',
      'challenge final':      'FINAL — CHALLENGE',
    };
    return fases[week.toLowerCase()] ?? week.toUpperCase();
  }

  String _inferirInstancia(dynamic partido) {
    final w = partido['week']?.toString();
    if (w != null && w != 'null') return w;
    // week null en 7s = partido de fase de grupos
    return sevensLeagues.contains(widget.nombreLiga) ? 'Fase de Grupos' : 'Round of 16';
  }

  /// Reasigna matches con week=null (agrupados como 'Round of 16') a la ronda
  /// nombrada más cercana por timestamp. Útil cuando la API deja sin semana
  /// a uno de los dos partidos de una misma fase (ej. una semi en Champions Cup).
  void _reasignarNullWeeks(Map<String, List<dynamic>> porJornada) {
    const nullKey = 'Round of 16';
    if (!porJornada.containsKey(nullKey)) return;
    // Solo actuar si TODOS los matches de ese bucket son realmente null-week
    final nullMatches = List<dynamic>.from(porJornada[nullKey]!);
    if (!nullMatches.every((m) => m['week'] == null || m['week'] == 'null')) return;
    porJornada.remove(nullKey);
    if (porJornada.isEmpty) { porJornada[nullKey] = nullMatches; return; }

    // Bucket de fallback: la fase con mayor timestamp promedio (la más reciente)
    String fallbackKey = porJornada.keys.first;
    int maxTs = 0;
    for (final entry in porJornada.entries) {
      for (final m in entry.value) {
        final mTs = m['timestamp'] as int? ?? 0;
        if (mTs > maxTs) { maxTs = mTs; fallbackKey = entry.key; }
      }
    }

    for (final match in nullMatches) {
      final ts = match['timestamp'] as int? ?? 0;
      String best = fallbackKey; // si no hay timestamp, va a la fase más reciente
      int minDiff = 999999999;
      for (final entry in porJornada.entries) {
        for (final m in entry.value) {
          final mTs = m['timestamp'] as int? ?? 0;
          if (mTs == 0) continue;
          final diff = (ts - mTs).abs();
          if (diff < minDiff) { minDiff = diff; best = entry.key; }
        }
      }
      porJornada.putIfAbsent(best, () => []).add(match);
    }
  }

  List<String> _ordenarJornadas(Iterable<String> jornadas, {bool proximosAscendente = false}) {
    // 7s: final primero, pools al final
    // Liga regular: fecha más reciente primero (descendente)
    const ordenFases = [
      // Copa (7s Cup knockout) — primero
      'cup final',
      'cup semi-finals',
      'cup quarter-finals',
      // Finales de otras ramas (7s)
      'bronze final',
      '5th place',
      '7th place',
      '9th place',
      'plate final',
      'plate semi-finals',
      'plate quarter-finals',
      'bowl final',
      'bowl semi-finals',
      // Liga regular
      'final',
      'semi-finals',
      'quarter-finals',
      'round of 16',
      'round-of-16',
      'playoffs',
      'octavos',
      // Pools 7s — al final
      'pool a',
      'pool b',
      'pool c',
      'pool d',
    ];
    // Extrae el número de strings como "Fecha 3", "Round 5", "Jornada 2", "3", etc.
    int? numericKey(String s) {
      final direct = int.tryParse(s.trim());
      if (direct != null) return direct;
      final m = RegExp(r'\b(\d+)\b').firstMatch(s);
      return m != null ? int.tryParse(m.group(1)!) : null;
    }

    final lista = jornadas.toList();
    lista.sort((a, b) {
      final ia = numericKey(a);
      final ib = numericKey(b);
      if (ia != null && ib != null) return proximosAscendente ? ia.compareTo(ib) : ib.compareTo(ia);
      if (ia != null) return proximosAscendente ? -1 : 1;
      if (ib != null) return proximosAscendente ? 1 : -1;
      final oa = ordenFases.indexOf(a.toLowerCase());
      final ob = ordenFases.indexOf(b.toLowerCase());
      if (oa == -1 && ob == -1) return a.compareTo(b);
      return (oa == -1 ? 999 : oa).compareTo(ob == -1 ? 999 : ob);
    });
    return lista;
  }

  // ── Build principal ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        drawer: const AppDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: urbaLogoWidget(widget.nombreLiga, size: 38) ??
              Text(
                widget.nombreLiga,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
              ),
          backgroundColor: widget.theme.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            if (!widget.isStatic)
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                onPressed: _refresh,
                tooltip: 'Actualizar',
              ),
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor:       widget.theme.accent,
            indicatorWeight:      3,
            labelColor:           Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            tabs: const [Tab(text: 'RESULTADOS'), Tab(text: 'PRÓXIMOS')],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
                future: _matchesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: widget.theme.primary));
                  }
                  if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

                  final partidos = snapshot.data ?? [];
                  final isSevensTournament = sevensLeagues.contains(widget.nombreLiga);

                  final jugados = partidos
                      .where((p) => p['scores']?['home'] != null)
                      .where((p) => !isSevensTournament || _isMainDrawMatch(p))
                      .toList()
                    ..sort((a, b) {
                      final da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2000);
                      final db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2000);
                      return db.compareTo(da);
                    });

                  final proximos = partidos
                      .where((p) => p['scores']?['home'] == null)
                      .where((p) => !isSevensTournament || _isMainDrawMatch(p))
                      .toList()
                    ..sort((a, b) {
                      final da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2099);
                      final db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2099);
                      return da.compareTo(db);
                    });

                  return TabBarView(
                    children: [_listaResultados(jugados), _listaProximos(proximos)],
                  );
                },
              ),
      ),
    );
  }

  // ── Tab: Resultados ──────────────────────────────────────────────────────

  Widget _listaResultados(List<dynamic> data) {
    if (data.isEmpty) return _emptyState('No hay resultados disponibles');

    final Map<String, List<dynamic>> porJornada = {};
    for (final p in data) {
      porJornada.putIfAbsent(_inferirInstancia(p), () => []).add(p);
    }
    _reasignarNullWeeks(porJornada);
    final jornadas = _ordenarJornadas(porJornada.keys);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: jornadas.map((j) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(
              _labelJornada(j),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: widget.theme.primary, letterSpacing: 1.5),
            ),
          ),
          ...porJornada[j]!.map(_cardResultado),
        ],
      )).toList(),
    );
  }

  Widget _cardResultado(dynamic partido) {
    final homeTeam    = partido['teams']?['home']?['name'] ?? 'Local';
    final awayTeam    = partido['teams']?['away']?['name'] ?? 'Visitante';
    final homeLogoUrl = partido['teams']?['home']?['logo']?.toString();
    final awayLogoUrl = partido['teams']?['away']?['logo']?.toString();
    final homeScore   = partido['scores']?['home'] ?? '-';
    final awayScore   = partido['scores']?['away'] ?? '-';
    final homePT1     = partido['periods']?['first']?['home'];
    final awayPT1     = partido['periods']?['first']?['away'];
    final homePT2     = partido['periods']?['second']?['home'];
    final awayPT2     = partido['periods']?['second']?['away'];
    final fecha       = _formatFecha(partido['date']);
    final hora        = _formatHora(partido['date']);
    final status      = partido['status']?['short'] ?? '';
    final homeWon     = (homeScore is int && awayScore is int) && homeScore > awayScore;
    final awayWon     = (homeScore is int && awayScore is int) && awayScore > homeScore;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$fecha · $hora', style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                if (status.isNotEmpty) _statusChip(status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _teamLogo(homeTeam, size: 28, apiLogoUrl: homeLogoUrl),
                      const SizedBox(height: 4),
                      Text(
                        homeTeam,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: homeWon ? FontWeight.w800 : FontWeight.w500,
                          fontSize:   13,
                          color:      homeWon ? const Color(0xFF1A1A1A) : const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: widget.theme.primary, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '$homeScore - $awayScore',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _teamLogo(awayTeam, size: 28, apiLogoUrl: awayLogoUrl),
                      const SizedBox(height: 4),
                      Text(
                        awayTeam,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: awayWon ? FontWeight.w800 : FontWeight.w500,
                          fontSize:   13,
                          color:      awayWon ? const Color(0xFF1A1A1A) : const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (homePT1 != null && awayPT1 != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('1T: $homePT1-$awayPT1', style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                  if (homePT2 != null && awayPT2 != null) ...[
                    const Text('  ·  ', style: TextStyle(color: Color(0xFFCCCCCC))),
                    Text('2T: $homePT2-$awayPT2', style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _teamInitials(String teamName, double size) {
    final initial = teamName.isNotEmpty ? teamName[0].toUpperCase() : '?';
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: widget.theme.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.w800,
            color: widget.theme.primary,
          ),
        ),
      ),
    );
  }

  Widget _teamLogo(String teamName, {double size = 28, String? apiLogoUrl}) {
    final staticUrl = clubLogo(teamName);
    final url = staticUrl ?? apiLogoUrl;
    if (url == null) return _teamInitials(teamName, size);
    return Image.network(
      url,
      width: size, height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, e, s) {
        if (staticUrl != null && apiLogoUrl != null) {
          return Image.network(apiLogoUrl, width: size, height: size, fit: BoxFit.contain,
            errorBuilder: (_, e2, s2) => _teamInitials(teamName, size));
        }
        return _teamInitials(teamName, size);
      },
    );
  }

  static const _liveStatuses = {'1H', '2H', 'HT', 'ET', 'BT', 'P'};

  Widget _statusChip(String status) {
    final Color bg;
    final Color fg;
    final String label;
    final bool isLive = _liveStatuses.contains(status);
    switch (status) {
      case 'FT':
        bg = const Color(0xFFE8F5EE); fg = const Color(0xFF2D6A4F); label = 'Final';
      case 'AET':
        bg = const Color(0xFFFFF3E8); fg = const Color(0xFFE85D04); label = 'Prórroga';
      case '1H':
        bg = const Color(0xFFFFEBEB); fg = const Color(0xFFD32F2F); label = '1er Tiempo';
      case '2H':
        bg = const Color(0xFFFFEBEB); fg = const Color(0xFFD32F2F); label = '2do Tiempo';
      case 'HT':
        bg = const Color(0xFFFFEBEB); fg = const Color(0xFFD32F2F); label = 'Entretiempo';
      case 'ET':
        bg = const Color(0xFFFFEBEB); fg = const Color(0xFFD32F2F); label = 'Prórroga';
      case 'BT':
        bg = const Color(0xFFFFEBEB); fg = const Color(0xFFD32F2F); label = 'Descanso';
      case 'P':
        bg = const Color(0xFFFFEBEB); fg = const Color(0xFFD32F2F); label = 'Penales';
      default:
        bg = const Color(0xFFEEF2FF); fg = widget.theme.primary;    label = status;
    }
    if (isLive) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7, height: 7,
            decoration: const BoxDecoration(color: Color(0xFFD32F2F), shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
            child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
          ),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  // ── Tab: Próximos ────────────────────────────────────────────────────────

  Widget _listaProximos(List<dynamic> data) {
    if (data.isEmpty) return _emptyState('No hay próximos partidos programados');

    final Map<String, List<dynamic>> porJornada = {};
    for (final p in data) {
      porJornada.putIfAbsent(_inferirInstancia(p), () => []).add(p);
    }
    _reasignarNullWeeks(porJornada);
    final jornadas = _ordenarJornadas(porJornada.keys, proximosAscendente: true);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: jornadas.map((j) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(
              _labelJornada(j),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: widget.theme.primary, letterSpacing: 1.5),
            ),
          ),
          ...porJornada[j]!.map(_cardProximo),
        ],
      )).toList(),
    );
  }

  Widget _cardProximo(dynamic partido) {
    final homeTeam    = partido['teams']?['home']?['name'] ?? 'Local';
    final awayTeam    = partido['teams']?['away']?['name'] ?? 'Visitante';
    final homeLogoUrl = partido['teams']?['home']?['logo']?.toString();
    final awayLogoUrl = partido['teams']?['away']?['logo']?.toString();
    final fecha       = _formatFecha(partido['date']);
    final hora        = _formatHora(partido['date']);
    final status      = partido['status']?['short'] as String? ?? '';
    final isLive      = _liveStatuses.contains(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: widget.theme.primary.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: widget.theme.primary),
                    const SizedBox(width: 5),
                    Text('$fecha · $hora hs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: widget.theme.primary)),
                  ],
                ),
                if (isLive) _statusChip(status),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _teamLogo(homeTeam, size: 28, apiLogoUrl: homeLogoUrl),
                      const SizedBox(height: 4),
                      Text(homeTeam, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A1A))),
                    ],
                  ),
                ),
                Container(
                  margin:     const EdgeInsets.symmetric(horizontal: 14),
                  padding:    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color:        widget.theme.background,
                    borderRadius: BorderRadius.circular(10),
                    border:       Border.all(color: widget.theme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text('VS', style: TextStyle(color: widget.theme.primary, fontWeight: FontWeight.w900, fontSize: 14)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _teamLogo(awayTeam, size: 28, apiLogoUrl: awayLogoUrl),
                      const SizedBox(height: 4),
                      Text(awayTeam, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A1A))),
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

  // ── Empty state ──────────────────────────────────────────────────────────

  Widget _emptyState(String mensaje) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_rugby, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF888888), fontSize: 14)),
        ],
      ),
    );
  }
}
