import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsService extends ChangeNotifier {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();

  static const _key = 'notification_teams';
  List<String> _teams = [];

  List<String> get teams => List.unmodifiable(_teams);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _teams = prefs.getStringList(_key) ?? [];
  }

  bool isSubscribed(String teamName) => _teams.contains(teamName);

  Future<void> toggle(String teamName) async {
    if (_teams.contains(teamName)) {
      _teams.remove(teamName);
    } else {
      _teams.add(teamName);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _teams);
    notifyListeners();
  }
}
