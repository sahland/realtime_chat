import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  final SharedPreferences _prefs;

  static const _key = 'theme_mode';

  ThemeStorage({required SharedPreferences prefs}) : _prefs = prefs;

  ThemeMode load() {
    final value = _prefs.getString(_key);
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> save(ThemeMode mode) async {
    await _prefs.setString(_key, mode.name);
  }
}
