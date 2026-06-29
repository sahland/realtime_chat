import 'package:flutter/material.dart';

import '../storage/theme_storage.dart';

class ThemeRepository {
  final ThemeStorage _storage;

  ThemeRepository({required ThemeStorage storage}) : _storage = storage;

  ThemeMode load() => _storage.load();

  Future<void> save(ThemeMode mode) => _storage.save(mode);
}
