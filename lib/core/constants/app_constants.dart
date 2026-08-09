/// App-wide constants: default contact numbers and bundled asset maps.
///
/// Centralizes values that were previously hard-coded across screens so the
/// business data stays in one place and the UI stays clean.
library;

import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  /// Default WhatsApp number used across the app (fallback).
  static const String defaultWhatsappNumber = '+201000000001';

  /// Mapping from area name to its bundled cover image asset.
  static const Map<String, String> areaImageAssets = {
    'بيت الوطن': 'assets/image/bait_elwatan.webp',
    'جاردينيا': 'assets/image/gardenia.webp',
  };

  /// Resolves the bundled cover image for [area], or `null` if unknown.
  static String? areaImageAssetFor(String? area) {
    if (area == null) return null;
    return areaImageAssets[area];
  }

  /// Mapping from area name to its representative icon.
  static const Map<String, IconData> areaIcons = {
    'المستثمرين': Icons.business_rounded,
    'الأندلس': Icons.villa_rounded,
    'جاردينيا': Icons.park_rounded,
    'بيت الوطن': Icons.home_work_rounded,
    'النرجس': Icons.local_florist_rounded,
    'النرجس الجديدة': Icons.local_florist_rounded,
  };

  /// Resolves the representative icon for [area], or a fallback.
  static IconData areaIconFor(String? area) {
    if (area == null) return Icons.apartment_rounded;
    return areaIcons[area] ?? Icons.apartment_rounded;
  }
}

