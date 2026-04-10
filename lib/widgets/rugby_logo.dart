import 'package:flutter/material.dart';

/// Logo option A — postes H de rugby + pelota puntiaguda debajo.
/// Usar con [color: Colors.white] sobre fondos oscuros.
class RugbyLogo extends StatelessWidget {
  final double size;
  final Color color;

  const RugbyLogo({super.key, this.size = 40, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    // Proporción del SVG original: 72 × 86
    return SizedBox(
      width: size * 72 / 86,
      height: size,
      child: CustomPaint(painter: _LogoPainter(color: color)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size s) {
    final sx = s.width  / 72;
    final sy = s.height / 86;

    final postPaint = Paint()
      ..color      = color
      ..strokeWidth = 4.0 * sx
      ..strokeCap  = StrokeCap.round
      ..style      = PaintingStyle.stroke;

    // ── Postes H de rugby ──────────────────────────────────────────────────
    // Palo izquierdo (de arriba a abajo)
    canvas.drawLine(Offset(20 * sx, 4  * sy), Offset(20 * sx, 60 * sy), postPaint);
    // Palo derecho
    canvas.drawLine(Offset(52 * sx, 4  * sy), Offset(52 * sx, 60 * sy), postPaint);
    // Travesaño bajo (cerca del fondo, estilo rugby)
    canvas.drawLine(Offset(20 * sx, 44 * sy), Offset(52 * sx, 44 * sy), postPaint);

    // ── Pelota puntiaguda ──────────────────────────────────────────────────
    final ballPath = Path()
      ..moveTo(16 * sx, 75 * sy)
      ..quadraticBezierTo(36 * sx, 64 * sy, 56 * sx, 75 * sy)
      ..quadraticBezierTo(36 * sx, 86 * sy, 16 * sx, 75 * sy)
      ..close();

    canvas.drawPath(ballPath, Paint()
      ..color = color
      ..style = PaintingStyle.fill);

    // Detalles de la pelota (semitransparentes del mismo color)
    final detailPaint = Paint()
      ..color      = color.withValues(alpha: 0.38)
      ..strokeWidth = 1.1 * sx
      ..strokeCap  = StrokeCap.round
      ..style      = PaintingStyle.stroke;

    // Línea central horizontal
    canvas.drawLine(Offset(16 * sx, 75 * sy), Offset(56 * sx, 75 * sy), detailPaint);

    // Curvas laterales
    canvas.drawPath(
      Path()..moveTo(36*sx, 65*sy)..quadraticBezierTo(42*sx, 75*sy, 36*sx, 85*sy),
      detailPaint,
    );
    canvas.drawPath(
      Path()..moveTo(36*sx, 65*sy)..quadraticBezierTo(30*sx, 75*sy, 36*sx, 85*sy),
      detailPaint,
    );

    // Puntadas de costura (3 líneas en el centro)
    for (final dy in [72.0, 75.0, 78.0]) {
      canvas.drawLine(
        Offset(32 * sx, dy * sy),
        Offset(40 * sx, dy * sy),
        detailPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.color != color;
}
