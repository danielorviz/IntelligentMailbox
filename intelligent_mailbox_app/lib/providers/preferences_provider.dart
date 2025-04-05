import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _notificationsEnabled = false;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadPreferences(String mailboxId) async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled =
        prefs.getBool('${mailboxId}_notificationsEnabled') ?? false;
    notifyListeners();
  }

  Future<void> updateNotificationState(String mailboxId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${mailboxId}_notificationsEnabled', value);
    _notificationsEnabled = value;
    notifyListeners();
  }
}