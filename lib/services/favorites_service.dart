import 'package:flutter/foundation.dart';
import 'user_service.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  Future<void> init() async {
    UserService.instance.addListener(notifyListeners);
  }

  List<String> get favorites => UserService.instance.profile?.favoriteTeams ?? [];
  bool isFavorite(String teamName) => UserService.instance.isFavorite(teamName);

  Future<void> toggle(String teamName) async {
    await UserService.instance.toggleFavorite(teamName);
  }
}
