import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isPremium = false;
  bool _isDarkMode = true;
  SharedPreferences? _prefs;

  bool get isPremium => _isPremium;
  bool get isDarkMode => _isDarkMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _isPremium = _prefs?.getBool('isPremium') ?? false;
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? true;
    notifyListeners();
  }

  Future<void> setPremium(bool value) async {
    _isPremium = value;
    await _prefs?.setBool('isPremium', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs?.setBool('isDarkMode', value);
    notifyListeners();
  }
} 