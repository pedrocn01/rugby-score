import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  static const _key = 'favorite_teams';
  List<String> _favorites = [];

  List<String> get favorites => List.unmodifiable(_favorites);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(_key) ?? [];
  }

  bool isFavorite(String teamName) => _favorites.contains(teamName);

  Future<void> toggle(String teamName) async {
    if (_favorites.contains(teamName)) {
      _favorites.remove(teamName);
    } else {
      _favorites.add(teamName);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _favorites);
    notifyListeners();
  }
}
