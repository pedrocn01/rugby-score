import 'package:flutter/material.dart';

/// Logos vectoriales de los torneos URBA, dibujados en código Flutter.
/// Se usan en las tarjetas del home y en el AppBar de cada torneo.

// ─── API pública ──────────────────────────────────────────────────────────────

/// Devuelve el widget-logo correspondiente o null si la liga no es URBA.
Widget? urbaLogoWidget(String liga, {double size = 80}) {
  switch (liga) {
    case 'URBA Top 14':   return _Top14Logo(size: size);
    case 'URBA Primera A': return _PrimeraLogo(letra: 'A', color: const Color(0xFF0A2240), size: size);
    case 'URBA Primera B': return _PrimeraLogo(letra: 'B', color: const Color(0xFFB35A00), size: size);
    case 'URBA Primera C': return _PrimeraLogo(letra: 'C', color: const Color(0xFFAA1500), size: size);
    default: return null;
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
