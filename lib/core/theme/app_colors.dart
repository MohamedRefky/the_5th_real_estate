import 'package:flutter/material.dart';

/// The 5th Estate — World-Class Real Estate Color Palette
///
/// Deep Midnight Navy (#081120) and Refined Champagne Gold (#D4B06A).
/// Clean, harmonious contrast with crisp typography.
class AppColors {
  AppColors._();

  // ─── Core Brand Tones ───────────────────────────────────────────
  /// Rich Deep Midnight Navy Background — Main scaffold background
  static const Color background = Color(0xFF081120);

  /// Card Surface — Elevated card background
  static const Color surface = Color(0xFF0F1B2D);

  /// Section Alt Surface — Secondary cards & containers
  static const Color cream = Color(0xFF0C1626);

  /// Primary Brand Anchor
  static const Color primary = Color(0xFF0A1526);

  /// Deepest Navy Anchor
  static const Color primaryDark = Color(0xFF040914);

  /// Medium Navy Slate Accent
  static const Color primaryMedium = Color(0xFF1B2A40);

  // ─── Refined Gold Accents ───────────────────────────────────────
  /// Refined Champagne Gold — Highlights, icons, primary buttons
  static const Color accent = Color(0xFFD4B06A);

  /// Light Champagne Gold
  static const Color accentLight2 = Color(0xFFEAD9A8);

  /// Rich Bronze Gold
  static const Color accentDark = Color(0xFFA8842F);

  /// Translucent Gold Tint — Badges & icon backgrounds (12% opacity)
  static const Color accentLight = Color(0x1FD4B06A);

  // ─── Dividers & Borders ─────────────────────────────────────────
  /// Crisp 1px Border Navy Slate
  static const Color divider = Color(0xFF1E2A3E);

  // ─── Text Hierarchy ─────────────────────────────────────────────
  /// Crisp Bright Navy-White — Main titles & body
  static const Color textPrimary = Color(0xFFF2F5FA);

  /// Smooth Navy Grey — Subtitles & metadata
  static const Color textSecondary = Color(0xFF93A4BF);

  /// Dark Navy Hint — Search placeholders
  static const Color textHint = Color(0xFF5E6E8C);

  /// Contrast Text — On bright gold / gradient surfaces
  static const Color textOnPrimary = Color(0xFF1A1206);

  // ─── Status Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF60A5FA);

  // ─── Computed Variants ─────────────────────────────────────────
  static Color get primaryLight => accent.withValues(alpha: 0.12);

  static const Color shimmer = Color(0xFF1E2A3E);

  // ─── Harmonious Gradients ───────────────────────────────────────
  /// Smooth Hero Gradient
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF040914),
      Color(0xFF081120),
      Color(0xFF0F1B2D),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gold Accent Gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFEAD9A8),
      Color(0xFFD4B06A),
      Color(0xFFA8842F),
    ],
  );

  /// Section Background Gradient
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF081120),
      Color(0xFF081120),
    ],
  );
}
