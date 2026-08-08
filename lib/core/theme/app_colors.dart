import 'package:flutter/material.dart';

/// The 5th Estate — World-Class Real Estate Color Palette
///
/// Ultra-Refined Cool Platinum Silver & Deep Steel Night Navy.
/// Tailored for high-end architectural luxury, metallic platinum shimmer, and dark mode perfection.
class AppColors {
  AppColors._();

  // ─── Core Brand Tones (Deep Steel Night Navy) ─────────────────
  /// Deep Steel Night Scaffold Background
  static const Color background = Color(0xFF0A111D);

  /// Elevated Steel Slate Card Surface Background
  static const Color surface = Color(0xFF121C2B);

  /// Secondary Section Container Surface
  static const Color cream = Color(0xFF0E1724);

  /// Primary Brand Anchor
  static const Color primary = Color(0xFF0D1623);

  /// Deepest Night Anchor
  static const Color primaryDark = Color(0xFF050911);

  /// Medium Steel Slate Border/Container Tone
  static const Color primaryMedium = Color(0xFF1E2C3F);

  // ─── Ultra-Refined Cool Platinum Accents ────────────────────────
  // Cool Platinum Silver — Highlights, icons, primary buttons
  static const Color accent = Color(0xFFC9CDD6);

  /// Luminous Diamond Silver — High-contrast badges & gradient highlights
  static const Color accentLight2 = Color(0xFFF0F2F6);

  /// Deep Steel Platinum — Active borders & gradient depth
  static const Color accentDark = Color(0xFF7D8494);

  /// Translucent Platinum Tint — Badges & icon backgrounds (12% opacity)
  static const Color accentLight = Color(0x1FC9CDD6);

  /// Cool Platinum Sheen — Near-white top highlight for metallic gradients
  static const Color accentHighlight = Color(0xFFFCFDFE);

  /// Soft Platinum Wash — Large subtle backgrounds (5% opacity)
  static const Color accentSoft = Color(0x0DC9CDD6);

  /// Deep Steel Line — Hairline strokes & separators below accentDark
  static const Color accentLine = Color(0xFF525A6A);

  /// Platinum Halo — Soft silver glow for premium shadows & ambient light
  static const Color accentGlow = Color(0x33C9CDD6);

  // ─── Dividers & Borders ─────────────────────────────────────────
  /// Crisp Steel Border
  static const Color divider = Color(0xFF1E2C3F);

  // ─── Text Hierarchy ─────────────────────────────────────────────
  /// Crisp Ice White — Main titles & headers
  static const Color textPrimary = Color(0xFFF5F7FA);

  /// Platinum Slate Silver — Subtitles & metadata
  static const Color textSecondary = Color(0xFF94A0B2);

  /// Steel Hint — Search placeholders
  static const Color textHint = Color(0xFF647285);

  /// Contrast Text — Deep Steel Slate inside bright platinum CTA buttons
  static const Color textOnPrimary = Color(0xFF0F1724);

  // ─── Status Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF60A5FA);

  // ─── Computed Variants ─────────────────────────────────────────
  static Color get primaryLight => accent.withValues(alpha: 0.12);

  static const Color shimmer = Color(0xFF1E2C3F);

  // ─── Harmonious Gradients ───────────────────────────────────────
  /// Deep Steel Hero Gradient
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF050911), Color(0xFF0A111D), Color(0xFF121C2B)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Ultra-Refined Cool Platinum Metallic Gradient (brushed-silver sheen)
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFFCFDFE),
      Color(0xFFF0F2F6),
      Color(0xFFC9CDD6),
      Color(0xFF7D8494),
    ],
    stops: [0.0, 0.4, 0.72, 1.0],
  );

  /// Platinum Halo Fade — Subtle silver light leaking across section ties
  static const LinearGradient platinumFade = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x00C9CDD6),
      Color(0x26C9CDD6),
      Color(0x00C9CDD6),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Section Background Gradient
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A111D), Color(0xFF0A111D)],
  );
}
