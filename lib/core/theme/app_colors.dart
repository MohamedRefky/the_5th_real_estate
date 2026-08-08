import 'package:flutter/material.dart';

/// The 5th Estate — World-Class Real Estate Color Palette
///
/// Warm Dusky Twilight Blues and Refined Warm Gold — designed to
/// harmonize perfectly with the twilight compound background image.
class AppColors {
  AppColors._();

  // ─── Core Brand Tones (Warm Twilight Blues) ─────────────────────
  /// Deep Twilight Blue — Main scaffold background
  static const Color background = Color(0xFF0C1A2E);

  /// Card Surface — Elevated card background (warm navy)
  static const Color surface = Color(0xFF122240);

  /// Section Alt Surface — Secondary cards & containers
  static const Color cream = Color(0xFF0F1D34);

  /// Primary Brand Anchor
  static const Color primary = Color(0xFF0E1C32);

  /// Deepest Twilight Anchor
  static const Color primaryDark = Color(0xFF070F1E);

  /// Medium Twilight Slate
  static const Color primaryMedium = Color(0xFF1D3050);

  // ─── Refined Warm Gold Accents ──────────────────────────────────
  /// Warm Gold — Matches the golden building lights in the image
  static const Color accent = Color(0xFFDCBB6E);

  /// Light Warm Gold
  static const Color accentLight2 = Color(0xFFF0DDA6);

  /// Rich Amber Gold
  static const Color accentDark = Color(0xFFB8923A);

  /// Translucent Gold Tint — Badges & icon backgrounds (12% opacity)
  static const Color accentLight = Color(0x1FDCBB6E);

  // ─── Dividers & Borders ─────────────────────────────────────────
  /// Warm Navy Border
  static const Color divider = Color(0xFF243650);

  // ─── Text Hierarchy ─────────────────────────────────────────────
  /// Warm Bright White — Main titles & body
  static const Color textPrimary = Color(0xFFF5F2EC);

  /// Warm Silver — Subtitles & metadata
  static const Color textSecondary = Color(0xFFA0B0C4);

  /// Warm Hint — Search placeholders
  static const Color textHint = Color(0xFF687C96);

  /// Contrast Text — On bright gold / gradient surfaces
  static const Color textOnPrimary = Color(0xFF1A1206);

  // ─── Status Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF60A5FA);

  // ─── Computed Variants ─────────────────────────────────────────
  static Color get primaryLight => accent.withValues(alpha: 0.12);

  static const Color shimmer = Color(0xFF243650);

  // ─── Harmonious Gradients ───────────────────────────────────────
  /// Smooth Twilight Hero Gradient
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF070F1E),
      Color(0xFF0C1A2E),
      Color(0xFF122240),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Warm Gold Accent Gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFE5C878),
      Color(0xFFDCBB6E),
      Color(0xFFB8923A),
    ],
  );

  /// Section Background Gradient
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0C1A2E),
      Color(0xFF0C1A2E),
    ],
  );
}
