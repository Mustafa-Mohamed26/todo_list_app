import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  /// Toggle the theme mode between dark and light, and store the new mode to
  /// the local storage. This also notifies the listeners of the change.
  ///
  /// [isDarkMode] is true if the theme should be set to dark mode, and false
  /// if it should be set to light mode.
  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode();
    notifyListeners();
  }

  /// Loads the theme mode from local storage and updates the [_themeMode].
  ///
  /// Retrieves the 'isDarkMode' preference from [SharedPreferences]. If the
  /// preference is not set, defaults to light mode. Notifies listeners of the
  /// change.

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Saves the [_themeMode] to local storage.
  //
  /// Stores the 'isDarkMode' preference in [SharedPreferences], with the value
  /// being true if [_themeMode] is [ThemeMode.dark], and false if it is
  /// [ThemeMode.light].
  void _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }
}
