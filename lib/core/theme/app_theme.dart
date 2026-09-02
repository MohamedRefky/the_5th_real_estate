import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Centralised theme configuration for "The 5th Estate".
class AppTheme {
  AppTheme._();

  static String? get cairoFontFamily {
    try {
      return GoogleFonts.cairo().fontFamily;
    } catch (_) {
      return null;
    }
  }

  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      fontFamily: cairoFontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      fontFamily: cairoFontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      fontFamily: cairoFontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppColors.textOnPrimary,
      fontFamily: cairoFontFamily,
    ),
  );

  static ThemeData get light => dark;

  static ThemeData get dark {
    final fontFamily = cairoFontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,

      // Colors
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.divider,

      // Typography
      textTheme: _textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontFamily: fontFamily,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),

      // Elevated Buttons (Gold CTA with Dark Slate Text)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          color: AppColors.textHint,
          fontFamily: fontFamily,
        ),
      ),

      // Text Selection & Cursor Theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accentLight2,
        selectionColor: AppColors.accent.withValues(alpha: 0.35),
        selectionHandleColor: AppColors.accentLight2,
      ),
    );
  }
}
