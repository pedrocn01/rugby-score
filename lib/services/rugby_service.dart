import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/leagues.dart';

/// Servicio de acceso a la API de rugby.
///
/// En DESARROLLO: flutter run --dart-define=API_BASE_URL=https://v1.rugby.api-sports.io --dart-define=API_KEY=tu_clave
/// En PRODUCCIÓN: el Worker de Cloudflare inyecta la key; API_KEY se pasa vacío desde vercel-build.sh
class RugbyService {
  static const _apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://v1.rugby.api-sports.io',
  );

  static const _apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

  // Secreto compartido con el Worker para bloquear acceso externo.
  // En producción: --dart-define=APP_SECRET=el_mismo_valor_del_wrangler_secret
  static const _appSecret = String.fromEnvironment('APP_SECRET', defaultValue: '');

  Map<String, String> _buildHeaders({bool noCache = false}) => {
    'Accept': 'application/json',
    if (_apiKey.isNotEmpty)    'x-apisports-key': _apiKey,
    if (_appSecret.isNotEmpty) 'X-App-Secret':    _appSecret,
    if (noCache)               'X-Force-Fresh':   '1',
  };

  int _seasonFor(int leagueId) => leagueSeasons[leagueId] ?? 2025;

  Future<List<dynamic>> fetchMatches(int leagueId, {bool noCache = false}) async {
    try {
      final uri = Uri.parse('$_apiBase/games?league=$leagueId&season=${_seasonFor(leagueId)}');
      final response = await http.get(uri, headers: _buildHeaders(noCache: noCache))
          .timeout(const Duration(seconds: 10));
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
      final response = await http.get(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 10));
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
