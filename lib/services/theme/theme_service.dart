import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/services/cache/cache_service.dart';
import 'package:sharevoices/services/theme/dark_theme.dart';
import 'package:sharevoices/services/theme/light_theme.dart';

final themeProvider = ChangeNotifierProvider((ref) => ThemeService(ref.read(cacheServiceProvider)));

class ThemeService extends ChangeNotifier {
  final CacheService cacheService;

  ThemeService(this.cacheService);

  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool isDarkTheme() => _themeData == darkTheme;

  void toggleTheme() {
    themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    cacheService.saveTheme(isDarkTheme());
    notifyListeners();
  }

  Future<void> loadSavedTheme() async {
    themeData = await cacheService.loadSavedTheme();
    notifyListeners();
  }
}
