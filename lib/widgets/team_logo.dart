import 'package:flutter/material.dart';
import '../config/logos.dart';

/// Logo de equipo con fondo blanco redondeado.
/// Necesario porque logos con fondo negro/oscuro son invisibles sobre el fondo dark de la app.
class TeamLogo extends StatelessWidget {
  final String  name;
  final String? apiUrl;
  final double  size;

  const TeamLogo({super.key, required this.name, this.apiUrl, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final url = clubLogo(name) ?? apiUrl;
    final pad = size * 0.1;

    Widget img;
    if (url == null) {
      return SizedBox(width: size, height: size);
    } else if (url.startsWith('assets/')) {
      img = Image.asset(url, fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const SizedBox.shrink());
    } else {
      img = Image.network(url, fit: BoxFit.contain,
        cacheWidth: (size * 2).toInt(),
        errorBuilder: (_, _, _) => const SizedBox.shrink());
    }

    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.18),
      ),
      padding: EdgeInsets.all(pad),
      child: img,
    );
  }
}
