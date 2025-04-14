import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  final Map<String, bool> _notificationsState = {};

  bool isNotificationEnabled(String userId, String mailboxId) {
    final key = '${userId}_${mailboxId}_notificationsEnabled';
    return _notificationsState[key] ?? false;
  }

  Future<void> loadPreferences(String userId, String mailboxId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userId}_${mailboxId}_notificationsEnabled';
    _notificationsState[key] = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  Future<void> updateNotificationState(String userId, String mailboxId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userId}_${mailboxId}_notificationsEnabled';
    await prefs.setBool(key, value);
    _notificationsState[key] = value;
    notifyListeners();
  }

}
