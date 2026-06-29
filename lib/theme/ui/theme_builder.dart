import 'package:flutter/material.dart';

import '../domain/theme_controller.dart';

class ThemeBuilder extends StatelessWidget {
  final ThemeController controller;
  final Widget Function(BuildContext context, ThemeMode mode) builder;

  const ThemeBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller,
      builder: (context, mode, _) => builder(context, mode),
    );
  }
}
