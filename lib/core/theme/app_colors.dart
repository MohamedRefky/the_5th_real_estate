import 'package:flutter/material.dart';

/// The 5th Estate — Luxurious Color Palette
///
/// All colors used throughout the app must come from this file.
/// Never hardcode color values in widgets.
class AppColors {
  AppColors._();

  // ─── Brand Colors ───────────────────────────────────────────────
  /// Deep Navy Blue — Primary brand color (headers, nav, CTAs)
  static const Color primary = Color(0xFF1B263B);

  /// Darker Navy — For gradients and depth
  static const Color primaryDark = Color(0xFF0D1B2A);

  /// Lighter Navy — For hover states on dark backgrounds
  static const Color primaryMedium = Color(0xFF243B53);

  /// Elegant Gold — Accent color (buttons, highlights, badges)
  static const Color accent = Color(0xFFC5A059);

  /// Lighter Gold — For gradient endpoints
  static const Color accentLight2 = Color(0xFFD4B36A);

  /// Darker Gold — For gradient starts and pressed states
  static const Color accentDark = Color(0xFFB08C42);

  // ─── Background & Surface ──────────────────────────────────────
  /// Off-White — Main scaffold background
  static const Color background = Color(0xFFF8F9FA);

  /// Pure white — Card surfaces, dialogs
  static const Color surface = Color(0xFFFFFFFF);

  /// Light grey — Dividers, subtle borders
  static const Color divider = Color(0xFFE0E0E0);

  /// Soft cream — Alternative card background for variety
  static const Color cream = Color(0xFFFAF7F2);

  // ─── Text Colors ───────────────────────────────────────────────
  /// Dark Charcoal — Primary text
  static const Color textPrimary = Color(0xFF333333);

  /// Medium grey — Secondary / caption text
  static const Color textSecondary = Color(0xFF757575);

  /// Hint grey — Placeholder text
  static const Color textHint = Color(0xFFBDBDBD);

  /// White text — On dark/primary backgrounds
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Status Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // ─── Computed Variants ─────────────────────────────────────────
  /// A lighter shade of the primary for hover states / chips
  static Color get primaryLight => primary.withValues(alpha: 0.08);

  /// A lighter shade of gold for tag backgrounds
  static Color get accentLight => accent.withValues(alpha: 0.15);

  /// Shimmer placeholder color
  static const Color shimmer = Color(0xFFEEEEEE);

  // ─── Premium Gradients ─────────────────────────────────────────
  /// Hero header gradient (vertical, deep navy)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B263B),
      Color(0xFF0D1B2A),
      Color(0xFF101D30),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  /// Gold button / accent gradient
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFD4B36A),
      Color(0xFFC5A059),
      Color(0xFFB08C42),
    ],
  );

  /// Subtle section background gradient (light)
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8F9FA),
      Color(0xFFF0F1F3),
    ],
  );
}
