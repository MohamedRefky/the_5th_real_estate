import 'package:flutter/material.dart';

/// The 5th Estate — World-Class Real Estate Color Palette
///
/// Refined Slate 900 (#0F172A) and Warm Luxury Gold (#EAB308).
/// Clean, harmonious contrast with crisp typography.
class AppColors {
  AppColors._();

  // ─── Core Brand Tones ───────────────────────────────────────────
  /// Rich Dark Slate Background — Main scaffold background
  static const Color background = Color(0xFF0F172A);

  /// Card Surface — Elevated card background
  static const Color surface = Color(0xFF1E293B);

  /// Section Alt Surface — Secondary cards & containers
  static const Color cream = Color(0xFF1E293B);

  /// Primary Brand Anchor
  static const Color primary = Color(0xFF0F172A);

  /// Deep Navy Anchor
  static const Color primaryDark = Color(0xFF020617);

  /// Medium Slate Accent
  static const Color primaryMedium = Color(0xFF334155);

  // ─── Luxury Gold Accents ────────────────────────────────────────
  /// Refined Luxury Gold — Highlights, icons, primary buttons
  static const Color accent = Color(0xFFEAB308);

  /// Light Champagne Gold
  static const Color accentLight2 = Color(0xFFFACC15);

  /// Rich Bronze Gold
  static const Color accentDark = Color(0xFFCA8A04);

  /// Translucent Gold Tint — Badges & icon backgrounds (12% gold opacity)
  static const Color accentLight = Color(0x1FEAB308);

  // ─── Dividers & Borders ─────────────────────────────────────────
  /// Crisp 1px Border Slate
  static const Color divider = Color(0xFF334155);

  // ─── Text Hierarchy ─────────────────────────────────────────────
  /// Crisp Bright Slate White — Main titles & body
  static const Color textPrimary = Color(0xFFF8FAFC);

  /// Smooth Slate Grey — Subtitles & metadata
  static const Color textSecondary = Color(0xFF94A3B8);

  /// Dark Slate Hint — Search placeholders
  static const Color textHint = Color(0xFF64748B);

  /// Contrast Text — On dark gold / primary buttons
  static const Color textOnPrimary = Color(0xFF0F172A);

  // ─── Status Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─── Computed Variants ─────────────────────────────────────────
  static Color get primaryLight => accent.withValues(alpha: 0.12);

  static const Color shimmer = Color(0xFF334155);

  // ─── Harmonious Gradients ───────────────────────────────────────
  /// Smooth Hero Gradient
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF020617),
      Color(0xFF0F172A),
      Color(0xFF1E293B),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gold Accent Gradient
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFFACC15),
      Color(0xFFEAB308),
      Color(0xFFCA8A04),
    ],
  );

  /// Section Background Gradient
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF0F172A),
    ],
  );
}
