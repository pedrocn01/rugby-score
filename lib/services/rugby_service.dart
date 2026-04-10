import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/leagues.dart';

/// Servicio de acceso a la API de rugby.
///
/// En DESARROLLO (flutter run sin --dart-define):
///   • Llama directo a api-sports.io con la API key de desarrollo.
///
/// En PRODUCCIÓN (flutter build web --dart-define=API_BASE_URL=https://... --dart-define=API_KEY=):
///   • Llama al proxy de Cloudflare Workers.
///   • La API key queda vacía en el cliente; el Worker la inyecta en el servidor.
class RugbyService {
  static const _apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://v1.rugby.api-sports.io',
  );

  // En producción pasar --dart-define=API_KEY= (vacío).
  // El Worker de Cloudflare agrega la key real en el servidor.
  static const _apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'ae0c789862dd0f66a7f3fd261e879f3b', // solo para dev local
  );

  Map<String, String> _buildHeaders({bool noCache = false}) => {
    'Accept': 'application/json',
    if (_apiKey.isNotEmpty) 'x-apisports-key': _apiKey,
    if (noCache) 'X-Force-Fresh': '1',
  };

  int _seasonFor(int leagueId) => leagueSeasons[leagueId] ?? 2025;

  Future<List<dynamic>> fetchMatches(int leagueId, {bool noCache = false}) async {
    try {
      final uri = Uri.parse('$_apiBase/games?league=$leagueId&season=${_seasonFor(leagueId)}');
      final response = await http.get(uri, headers: _buildHeaders(noCache: noCache));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('response')) {
          return data['response'] as List<dynamic>;
        }
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar partidos: $e');
    }
  }

  Future<List<List<dynamic>>> fetchStandings(int leagueId) async {
    try {
      final uri = Uri.parse('$_apiBase/standings?league=$leagueId&season=${_seasonFor(leagueId)}');
      final response = await http.get(uri, headers: _buildHeaders());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('response')) {
          return (data['response'] as List<dynamic>)
              .map((g) => g as List<dynamic>)
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar tabla: $e');
    }
  }
}
