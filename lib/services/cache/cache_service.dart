import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharevoices/services/theme/dark_theme.dart';
import 'package:sharevoices/services/theme/light_theme.dart';

final cacheServiceProvider = Provider((ref) => CacheService());

class CacheService {
  SharedPreferences? pref;

  Future<ThemeData> loadSavedTheme() async {
    if (pref == null) await initPrefs();
    bool isDarkMode = pref?.getBool('isDarkMode') ?? false;
    if (isDarkMode) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  Future<void> saveTheme(bool isDarkTheme) async {
    if (pref == null) await initPrefs();
    await pref?.setBool('isDarkMode', isDarkTheme);
  }

  Future<void> initPrefs() async {
    pref = await SharedPreferences.getInstance();
  }
}
