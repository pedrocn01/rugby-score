import 'package:flutter/material.dart';

/// Logos vectoriales de los torneos URBA, dibujados en código Flutter.
/// Se usan en las tarjetas del home y en el AppBar de cada torneo.

// ─── API pública ──────────────────────────────────────────────────────────────

/// Devuelve el widget-logo correspondiente o null si la liga no es URBA.
Widget? urbaLogoWidget(String liga, {double size = 80}) {
  switch (liga) {
    // ── Carpetas URBA ─────────────────────────────────────────────────────────
    case 'TOP 14':    return _Top14Logo(size: size);
    case 'Primera A': return _PrimeraLogo(letra: 'A', color: const Color(0xFF0A2240), size: size);
    case 'Primera B': return _PrimeraLogo(letra: 'B', color: const Color(0xFFB35A00), size: size);
    case 'Primera C': return _PrimeraLogo(letra: 'C', color: const Color(0xFFAA1500), size: size);
    // ── División Superior ─────────────────────────────────────────────────────
    case 'URBA Top 14':    return _Top14Logo(size: size);
    case 'URBA Primera A': return _PrimeraLogo(letra: 'A', color: const Color(0xFF0A2240), size: size);
    case 'URBA Primera B': return _PrimeraLogo(letra: 'B', color: const Color(0xFFB35A00), size: size);
    case 'URBA Primera C': return _PrimeraLogo(letra: 'C', color: const Color(0xFFAA1500), size: size);
    // ── Segunda / Tercera / Desarrollo / Femenino ─────────────────────────────
    case 'Segunda':    return _OrdinalLogo(numero: '2', color: const Color(0xFF003A70), size: size);
    case 'Tercera':    return _OrdinalLogo(numero: '3', color: const Color(0xFF1B5E20), size: size);
    case 'Desarrollo': return _AbbrevLogo(abbrev: 'DES', color: const Color(0xFF00695C), size: size);
    case 'Femenino':   return _AbbrevLogo(abbrev: 'FEM', color: const Color(0xFF880E4F), size: size);
    // ── TOP 14 sub-categorías ────────────────────────────────────────────────
    case 'TOP 14 Intermedia':       return _Top14SubdivisionLogo(div: 'INT',   size: size);
    case 'TOP 14 Pre-Intermedia A': return _Top14SubdivisionLogo(div: 'PRE A', size: size);
    case 'TOP 14 Pre-Intermedia B': return _Top14SubdivisionLogo(div: 'PRE B', size: size);
    case 'TOP 14 Pre-Intermedia C': return _Top14SubdivisionLogo(div: 'PRE C', size: size);
    case 'TOP 14 Pre-Intermedia D': return _Top14SubdivisionLogo(div: 'PRE D', size: size);
    case 'TOP 14 Pre-Intermedia E': return _Top14SubdivisionLogo(div: 'PRE E', size: size);
    case 'TOP 14 Pre-Intermedia F': return _Top14SubdivisionLogo(div: 'PRE F', size: size);
    case 'TOP 14 M-22':             return _Top14SubdivisionLogo(div: 'M-22',  size: size);
    // ── Primera A ─────────────────────────────────────────────────────────────
    case '1A Intermedia':       return _SubdivisionLogo(cat: 'A', div: 'INT',   color: const Color(0xFF0A2240), size: size);
    case '1A Pre-Intermedia':   return _SubdivisionLogo(cat: 'A', div: 'PRE',   color: const Color(0xFF0A2240), size: size);
    case '1A Pre-Intermedia B': return _SubdivisionLogo(cat: 'A', div: 'PRE B', color: const Color(0xFF0A2240), size: size);
    case '1A Pre-Intermedia C': return _SubdivisionLogo(cat: 'A', div: 'PRE C', color: const Color(0xFF0A2240), size: size);
    case '1A Pre-Intermedia D': return _SubdivisionLogo(cat: 'A', div: 'PRE D', color: const Color(0xFF0A2240), size: size);
    // ── Primera B ─────────────────────────────────────────────────────────────
    case '1B Intermedia':       return _SubdivisionLogo(cat: 'B', div: 'INT',   color: const Color(0xFFB35A00), size: size);
    case '1B Pre-Intermedia':   return _SubdivisionLogo(cat: 'B', div: 'PRE',   color: const Color(0xFFB35A00), size: size);
    case '1B Pre-Intermedia B': return _SubdivisionLogo(cat: 'B', div: 'PRE B', color: const Color(0xFFB35A00), size: size);
    case '1B Pre-Intermedia C': return _SubdivisionLogo(cat: 'B', div: 'PRE C', color: const Color(0xFFB35A00), size: size);
    // ── Primera C ─────────────────────────────────────────────────────────────
    case '1C Intermedia':       return _SubdivisionLogo(cat: 'C', div: 'INT',   color: const Color(0xFFAA1500), size: size);
    case '1C Pre-Intermedia':   return _SubdivisionLogo(cat: 'C', div: 'PRE',   color: const Color(0xFFAA1500), size: size);
    case '1C Pre-Intermedia B': return _SubdivisionLogo(cat: 'C', div: 'PRE B', color: const Color(0xFFAA1500), size: size);
    // ── Carpetas Juveniles ────────────────────────────────────────────────────
    case 'M-19': return _JuvenilFolderLogo(cat: 'M-19', size: size);
    case 'M-17': return _JuvenilFolderLogo(cat: 'M-17', size: size);
    case 'M-16': return _JuvenilFolderLogo(cat: 'M-16', size: size);
    case 'M-15': return _JuvenilFolderLogo(cat: 'M-15', size: size);
    default:
      if (_isJuvenilLeague(liga)) return _JuvenilLogo(name: liga, size: size);
      return null;
  }
}

// ─── Logo 1A / 1B / 1C ───────────────────────────────────────────────────────

class _PrimeraLogo extends StatelessWidget {
  final String letra;
  final Color  color;
  final double size;
  const _PrimeraLogo({required this.letra, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(color, Colors.black, 0.55)!;
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [color, darkColor],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Número "1" + letra en una fila
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '1',
                style: TextStyle(
                  color:      Colors.white,
                  fontSize:   size * 0.50,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                ),
              ),
              Text(
                letra,
                style: TextStyle(
                  color:      Colors.white,
                  fontSize:   size * 0.32,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: size * 0.04),
          // "URBA" abajo
          Text(
            'URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.80),
              fontSize:      size * 0.13,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.025,
              height:        1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo URBA Top 14 ─────────────────────────────────────────────────────────

class _Top14Logo extends StatelessWidget {
  final double size;
  const _Top14Logo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  size,
      height: size * 0.85,
      child: CustomPaint(painter: _Top14Painter()),
    );
  }
}

class _Top14Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // ── Fondo blanco oval ──────────────────────────────────────────────────
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w, height: h), bgPaint);

    // ── Anillo rojo exterior ───────────────────────────────────────────────
    final redRingPaint = Paint()
      ..color       = const Color(0xFFCC1122)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = w * 0.075;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: w * 0.93, height: h * 0.91),
      redRingPaint,
    );

    // ── Arco azul inferior ────────────────────────────────────────────────
    final bluePaint = Paint()
      ..color       = const Color(0xFF1B2F7A)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = w * 0.065;
    final arcRect = Rect.fromCenter(
      center: Offset(cx, cy + h * 0.07),
      width:  w * 0.72,
      height: h * 0.72,
    );
    canvas.drawArc(arcRect, 0.18, 2.78, false, bluePaint);

    // ── Texto "URBA" ────────────────────────────────────────────────────────
    final urbaStyle = TextStyle(
      color:      const Color(0xFFCC1122),
      fontSize:   w * 0.16,
      fontWeight: FontWeight.w900,
      letterSpacing: w * 0.02,
    );
    _drawText(canvas, 'URBA', urbaStyle, Offset(cx, h * 0.30));

    // ── Texto "TOP 14" ──────────────────────────────────────────────────────
    final top14Style = TextStyle(
      color:      const Color(0xFF1B2F7A),
      fontSize:   w * 0.22,
      fontWeight: FontWeight.w900,
    );
    _drawText(canvas, 'TOP 14', top14Style, Offset(cx, h * 0.58));
  }

  void _drawText(Canvas canvas, String text, TextStyle style, Offset center) {
    final tp = TextPainter(
      text:            TextSpan(text: text, style: style),
      textDirection:   TextDirection.ltr,
      textAlign:       TextAlign.center,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Logo TOP 14 subdivisiones (Intermedia / Pre-Intermedia / M-22) ──────────

class _Top14SubdivisionLogo extends StatelessWidget {
  final String div;
  final double size;
  const _Top14SubdivisionLogo({required this.div, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [Color(0xFF1B2F7A), Color(0xFF0A1540)],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'TOP 14',
            style: TextStyle(
              color:         const Color(0xFFCC1122),
              fontSize:      size * 0.18,
              fontWeight:    FontWeight.w900,
              letterSpacing: size * 0.01,
              height:        1.0,
            ),
          ),
          SizedBox(height: size * 0.04),
          Text(
            div,
            style: TextStyle(
              color:         Colors.white,
              fontSize:      size * 0.13,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.005,
              height:        1.0,
            ),
          ),
          SizedBox(height: size * 0.03),
          Text(
            'URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.45),
              fontSize:      size * 0.10,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.02,
              height:        1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers Juveniles ────────────────────────────────────────────────────────

bool _isJuvenilLeague(String name) =>
    name.startsWith('M-19 ') || name.startsWith('M-17 ') ||
    name.startsWith('M-16 ') || name.startsWith('M-15 ');

Color _juvenilColor(String cat) {
  switch (cat) {
    case 'M-19': return const Color(0xFFB84800);
    case 'M-17': return const Color(0xFF9E3700);
    case 'M-16': return const Color(0xFF8A2F00);
    case 'M-15': return const Color(0xFF742600);
    default:     return const Color(0xFF8A2F00);
  }
}

String _juvenilLabel(String name) {
  final spaceIdx = name.indexOf(' ');
  if (spaceIdx == -1) return name;
  return name.substring(spaceIdx + 1)
      .replaceAll('Formativa ', 'Form ')
      .replaceAll('Formativo ', 'Form ')
      .replaceAll('Nivel 1 ', 'N1-')
      .replaceAll('Nivel 2 ', 'N2-')
      .replaceAll('Desarrollo', 'Des')
      .replaceAll(' Eq B', ' B');
}

// ─── Logo carpeta M-19 / M-17 / M-16 / M-15 ─────────────────────────────────

class _JuvenilFolderLogo extends StatelessWidget {
  final String cat;
  final double size;
  const _JuvenilFolderLogo({required this.cat, required this.size});

  @override
  Widget build(BuildContext context) {
    final color = _juvenilColor(cat);
    final dark  = Color.lerp(color, Colors.black, 0.55)!;
    final parts  = cat.split('-');
    final letter = parts[0];
    final number = parts.length > 1 ? parts[1] : '';
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [color, dark],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(letter,
                style: TextStyle(
                  color:      Colors.white.withValues(alpha: 0.65),
                  fontSize:   size * 0.22,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                )),
              Text('-',
                style: TextStyle(
                  color:      Colors.white.withValues(alpha: 0.45),
                  fontSize:   size * 0.18,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                )),
              Text(number,
                style: TextStyle(
                  color:      Colors.white,
                  fontSize:   size * 0.40,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                )),
            ],
          ),
          SizedBox(height: size * 0.04),
          Text('URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.55),
              fontSize:      size * 0.13,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.025,
              height:        1.0,
            )),
          Text('JUVENILES',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.35),
              fontSize:      size * 0.09,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.018,
              height:        1.3,
            )),
        ],
      ),
    );
  }
}

// ─── Logo liga juvenil individual (M-19 G1 A, M-17 G2 Nivel 1 B, etc.) ───────

class _JuvenilLogo extends StatelessWidget {
  final String name;
  final double size;
  const _JuvenilLogo({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    final cat   = name.split(' ').first;
    final label = _juvenilLabel(name);
    final color = _juvenilColor(cat);
    final dark  = Color.lerp(color, Colors.black, 0.55)!;
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [color, dark],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(cat,
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.85),
              fontSize:      size * 0.18,
              fontWeight:    FontWeight.w900,
              letterSpacing: size * 0.005,
              height:        1.0,
            )),
          SizedBox(height: size * 0.05),
          SizedBox(
            width: size * 0.88,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:         Colors.white,
                  fontSize:      size * 0.14,
                  fontWeight:    FontWeight.w700,
                  letterSpacing: size * 0.004,
                  height:        1.2,
                )),
            ),
          ),
          SizedBox(height: size * 0.04),
          Text('URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.40),
              fontSize:      size * 0.10,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.02,
              height:        1.0,
            )),
        ],
      ),
    );
  }
}

// ─── Logo Segunda / Tercera ───────────────────────────────────────────────────

class _OrdinalLogo extends StatelessWidget {
  final String numero;
  final Color  color;
  final double size;
  const _OrdinalLogo({required this.numero, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(color, Colors.black, 0.55)!;
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [color, darkColor],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                numero,
                style: TextStyle(
                  color:      Colors.white,
                  fontSize:   size * 0.50,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                ),
              ),
              Text(
                'ª',
                style: TextStyle(
                  color:      Colors.white.withValues(alpha: 0.75),
                  fontSize:   size * 0.26,
                  fontWeight: FontWeight.w900,
                  height:     1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: size * 0.04),
          Text(
            'URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.80),
              fontSize:      size * 0.13,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.025,
              height:        1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo Desarrollo / Femenino ───────────────────────────────────────────────

class _AbbrevLogo extends StatelessWidget {
  final String abbrev;
  final Color  color;
  final double size;
  const _AbbrevLogo({required this.abbrev, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(color, Colors.black, 0.55)!;
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [color, darkColor],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            abbrev,
            style: TextStyle(
              color:         Colors.white,
              fontSize:      size * 0.32,
              fontWeight:    FontWeight.w900,
              letterSpacing: size * 0.01,
              height:        1.0,
            ),
          ),
          SizedBox(height: size * 0.04),
          Text(
            'URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.80),
              fontSize:      size * 0.13,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.025,
              height:        1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo subdivisiones (Intermedia / Pre-Intermedia) ─────────────────────────

class _SubdivisionLogo extends StatelessWidget {
  final String cat;   // 'A', 'B' o 'C'
  final String div;   // 'INT', 'PRE', 'PRE B', etc.
  final Color  color;
  final double size;
  const _SubdivisionLogo({required this.cat, required this.div, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(color, Colors.black, 0.55)!;
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [color, darkColor],
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('1', style: TextStyle(color: Colors.white, fontSize: size * 0.38, fontWeight: FontWeight.w900, height: 1.0)),
              Text(cat,  style: TextStyle(color: Colors.white, fontSize: size * 0.25, fontWeight: FontWeight.w900, height: 1.0)),
            ],
          ),
          SizedBox(height: size * 0.04),
          Text(div,
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.85),
              fontSize:      size * 0.12,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.01,
              height:        1.0,
            ),
          ),
          SizedBox(height: size * 0.02),
          Text('URBA',
            style: TextStyle(
              color:         Colors.white.withValues(alpha: 0.50),
              fontSize:      size * 0.10,
              fontWeight:    FontWeight.w700,
              letterSpacing: size * 0.02,
              height:        1.0,
            ),
          ),
        ],
      ),
    );
  }
}
