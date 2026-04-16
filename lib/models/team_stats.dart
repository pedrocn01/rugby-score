/// Acumulador de estadísticas por equipo para calcular tablas de posiciones
/// desde los resultados de partidos (sin llamar al endpoint de standings).
class TeamStats {
  final String name;
  String? logoUrl;
  int pj = 0; // partidos jugados
  int g  = 0; // ganados
  int e  = 0; // empatados
  int p  = 0; // perdidos
  int pts = 0; // puntos (G=4, E=2, P=0)

  TeamStats(this.name);
}
