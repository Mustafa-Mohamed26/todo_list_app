import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  /// change the Theme from Light mode into Dark mode and vise verse
  /// 
  /// this method updates the given [bool] data in the application
  /// using [ThemeMode.dark] and [ThemeMode.light] 

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}