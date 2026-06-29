import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeInherited.of(context);
    final isDark = controller.value == ThemeMode.dark;

    return IconButton(
      onPressed: controller.toggle,
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
    );
  }
}
