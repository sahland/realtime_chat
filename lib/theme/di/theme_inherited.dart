import 'package:flutter/material.dart';

import '../domain/theme_controller.dart';

class ThemeInherited extends InheritedWidget {
  final ThemeController controller;

  const ThemeInherited({
    super.key,
    required this.controller,
    required super.child,
  });

  static ThemeController of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<ThemeInherited>();
    return widget!.controller;
  }

  @override
  bool updateShouldNotify(ThemeInherited oldWidget) =>
      controller != oldWidget.controller;
}
