import 'package:flutter/material.dart';

/// The 5th Estate — Luxurious Dark Mode Palette
///
/// Ultra-prestigious Obsidian Midnight Navy & Radiant Champagne Gold.
/// Sleek, high-contrast, futuristic, and luxurious.
class AppColors {
  AppColors._();

  // ─── Dark Brand Colors ──────────────────────────────────────────
  /// Obsidian Midnight — Main dark background
  static const Color background = Color(0xFF0B0F19);

  /// Dark Slate Surface — Card backgrounds
  static const Color surface = Color(0xFF111827);

  /// Dark Sapphire Surface Alt — Secondary section backgrounds
  static const Color cream = Color(0xFF162032);

  /// Deep Navy Accent — Brand header & elevated surfaces
  static const Color primary = Color(0xFF1E293B);

  /// Dark Anchor — Gradient endpoint
  static const Color primaryDark = Color(0xFF070A10);

  /// Active Dark Sapphire — Hover / interactive states
  static const Color primaryMedium = Color(0xFF1E3A8A);

  // ─── Accent Colors (Champagne Gold) ─────────────────────────────
  /// Radiant Champagne Gold — Primary accent & CTAs
  static const Color accent = Color(0xFFF59E0B);

  /// Bright Gold — Highlights & gradient endpoints
  static const Color accentLight2 = Color(0xFFFBBF24);

  /// Rich Bronze Gold — Borders & shadows
  static const Color accentDark = Color(0xFFD97706);

  /// Dark Gold Tint — Badge backgrounds & icon containers
  static const Color accentLight = Color(0xFF281E0D);

  // ─── Divider & Borders ─────────────────────────────────────────
  /// Dark Slate Divider
  static const Color divider = Color(0xFF1E293B);

  // ─── Text Colors (Dark Mode High Contrast) ─────────────────────
  /// Crisp White Slate — Primary body text
  static const Color textPrimary = Color(0xFFF8FAFC);

  /// Muted Slate Grey — Secondary text
  static const Color textSecondary = Color(0xFF94A3B8);

  /// Dark Slate Hint — Placeholder text
  static const Color textHint = Color(0xFF64748B);

  /// Pure White — Buttons & badges
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Status Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─── Computed Variants ─────────────────────────────────────────
  /// Hover state light overlay
  static Color get primaryLight => accent.withValues(alpha: 0.15);

  /// Shimmer placeholder color
  static const Color shimmer = Color(0xFF1E293B);

  // ─── Dark Gradients ────────────────────────────────────────────
  /// Deep Obsidian Hero Gradient
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF070A10),
      Color(0xFF0B0F19),
      Color(0xFF111827),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Radiant Gold Gradient
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFFBBF24),
      Color(0xFFF59E0B),
      Color(0xFFD97706),
    ],
  );

  /// Dark Section Gradient
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0B0F19),
      Color(0xFF111827),
    ],
  );
}
