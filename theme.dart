import 'package:flutter/material.dart';

class HakTheme {
  static const bg = Color(0xFF0A0614);
  static const surface = Color(0xFF16122A);
  static const accent = Color(0xFF7C4DFF);
  static const purple = Color(0xFFB388FF);
  static const text = Color(0xFFF3EEFF);
  static const muted = Color(0xFFB0A8C8);

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
          surface: surface,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: .06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
