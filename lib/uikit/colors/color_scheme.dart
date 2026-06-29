import 'package:flutter/material.dart';

import 'color_palette.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color scaffold;
  final Color surface;
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color onPrimary;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color error;
  final Color surfaceContainerHighest;
  final Color inverseSurface;

  const AppColorScheme({
    required this.scaffold,
    required this.surface,
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.onPrimary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.surfaceContainerHighest,
    required this.inverseSurface,
  });

  static const light = AppColorScheme(
    scaffold: LightColorPalette.scaffold,
    surface: LightColorPalette.surface,
    primary: LightColorPalette.primary,
    primaryContainer: LightColorPalette.primaryContainer,
    secondary: LightColorPalette.secondary,
    onPrimary: LightColorPalette.onPrimary,
    onSurface: LightColorPalette.onSurface,
    onSurfaceVariant: LightColorPalette.onSurfaceVariant,
    outline: LightColorPalette.outline,
    outlineVariant: LightColorPalette.outlineVariant,
    error: LightColorPalette.error,
    surfaceContainerHighest: LightColorPalette.surfaceContainerHighest,
    inverseSurface: LightColorPalette.inverseSurface,
  );

  static const dark = AppColorScheme(
    scaffold: DarkColorPalette.scaffold,
    surface: DarkColorPalette.surface,
    primary: DarkColorPalette.primary,
    primaryContainer: DarkColorPalette.primaryContainer,
    secondary: DarkColorPalette.secondary,
    onPrimary: DarkColorPalette.onPrimary,
    onSurface: DarkColorPalette.onSurface,
    onSurfaceVariant: DarkColorPalette.onSurfaceVariant,
    outline: DarkColorPalette.outline,
    outlineVariant: DarkColorPalette.outlineVariant,
    error: DarkColorPalette.error,
    surfaceContainerHighest: DarkColorPalette.surfaceContainerHighest,
    inverseSurface: DarkColorPalette.inverseSurface,
  );

  @override
  ThemeExtension<AppColorScheme> copyWith({
    Color? scaffold,
    Color? surface,
    Color? primary,
    Color? primaryContainer,
    Color? secondary,
    Color? onPrimary,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? surfaceContainerHighest,
    Color? inverseSurface,
  }) {
    return AppColorScheme(
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondary: secondary ?? this.secondary,
      onPrimary: onPrimary ?? this.onPrimary,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      inverseSurface: inverseSurface ?? this.inverseSurface,
    );
  }

  @override
  ThemeExtension<AppColorScheme> lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      surfaceContainerHighest: Color.lerp(
          surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      inverseSurface:
          Color.lerp(inverseSurface, other.inverseSurface, t)!,
    );
  }
}
