// TODO: Implement by team member
// File: theme\app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color brick = Color(0xFFA13F30);
  static const Color roast = Color(0xFF2C1B16);
  static const Color cocoa = Color(0xFF6B4132);
  static const Color amber = Color(0xFFD59B57);
  static const Color cream = Color(0xFFFBF4EA);
  static const Color sand = Color(0xFFF4EADF);
  static const Color moss = Color(0xFF66785E);
  static const Color ink = Color(0xFF241612);

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    final textTheme = base.textTheme.copyWith(
      displayLarge: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 46,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 34,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleMedium: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF6B5148),
      ),
      labelLarge: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );

    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: brick,
      onPrimary: Colors.white,
      secondary: amber,
      onSecondary: roast,
      tertiary: moss,
      onTertiary: Colors.white,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: cream,
      onSurface: ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: sand,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: cream,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF8B7066),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: brick,
            width: 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFB3261E),
            width: 1.1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFB3261E),
            width: 1.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        labelStyle: textTheme.bodyMedium!.copyWith(
          color: ink,
          fontWeight: FontWeight.w700,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: brick,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: roast,
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
      dividerColor: const Color(0xFFE4D3C1),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final textTheme = base.textTheme.copyWith(
      displayLarge: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 46,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 34,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: brick,
      brightness: Brightness.dark,
      primary: amber,
      secondary: moss,
      surface: const Color(0xFF1A120F),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF130D0B),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF241612),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: amber, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: amber,
          foregroundColor: roast,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2C1B16),
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}
