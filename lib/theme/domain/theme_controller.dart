import 'package:flutter/material.dart';

import '../data/theme_repository.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  final ThemeRepository _repository;

  ThemeController({required ThemeRepository repository})
      : _repository = repository,
        super(repository.load());

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _repository.save(value);
  }
}
