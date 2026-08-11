/// App-wide constants: default contact numbers, team contacts, and bundled asset maps.
///
/// Centralizes values that were previously hard-coded across screens so the
/// business data stays in one place and the UI stays clean.
library;

import 'package:flutter/material.dart';

import 'admin_config.dart';

/// Data model representing a sales team contact representative.
class TeamContact {
  final String id;
  final String nameEn;
  final String nameAr;
  final String title;
  final String whatsappNumber;
  final String facebookUrl;
  final String initials;

  const TeamContact({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.title,
    required this.whatsappNumber,
    required this.facebookUrl,
    required this.initials,
  });

  /// Convenient accessor for primary display name (English at top)
  String get name => nameEn;
}

class AppConstants {
  AppConstants._();

  /// Whitelist of emails authorized to access the admin dashboard.
  static List<String> get allowedAdminEmails => AdminConfig.allowedAdminEmails;

  /// Sales Team Representatives: Mr. Mohamed Eldamen & Mr. Hamada Badea
  static const List<TeamContact> teamContacts = [
    TeamContact(
      id: 'eldamen',
      nameEn: 'Mr. Mohamed Eldamen',
      nameAr: 'أ. محمد الضامن',
      title: 'أ. محمد الضامن — مسؤول المبيعات والمعاينات',
      whatsappNumber: '+201555206857',
      facebookUrl: 'https://www.facebook.com/share/1BtUFpMkhX/?mibextid=wwXIfr',
      initials: 'M.E',
    ),
    TeamContact(
      id: 'badea',
      nameEn: 'Mr. Hamada Badea',
      nameAr: 'أ. حمادة بديع',
      title: 'أ. حمادة بديع — مسؤول المبيعات والمعاينات',
      whatsappNumber: '+201107861171',
      facebookUrl: 'https://www.facebook.com/share/1LqHtgX5SC/?mibextid=wwXIfr',
      initials: 'H.B',
    ),
  ];

  /// Default WhatsApp number used across the app (fallback).
  static const String defaultWhatsappNumber = '+201555206857';

  /// Default Facebook page link.
  static const String defaultFacebookUrl =
      'https://www.facebook.com/share/1BtUFpMkhX/?mibextid=wwXIfr';

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
    'الأندلس 1 و 2': Icons.villa_rounded,
    'الأندلس عائلي': Icons.family_restroom_rounded,
    'جاردينيا': Icons.park_rounded,
    'بيت الوطن': Icons.home_work_rounded,
    'النرجس': Icons.local_florist_rounded,
    'النرجس الجديدة': Icons.local_florist_rounded,
    'النرجس عمارات': Icons.apartment_rounded,
    'النرجس فيلات': Icons.villa_rounded,
    'البنفسج عمارات': Icons.apartment_rounded,
    'البنفسج فيلات': Icons.villa_rounded,
    'الياسمين الزوجي فيلات': Icons.villa_rounded,
    'الياسمين الفردي فيلات': Icons.villa_rounded,
  };

  /// Resolves the representative icon for [area], or a fallback.
  static IconData areaIconFor(String? area) {
    if (area == null) return Icons.apartment_rounded;
    return areaIcons[area] ?? Icons.apartment_rounded;
  }
}
