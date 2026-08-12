import 'package:flutter/material.dart';

import '../../models/apartment.dart';

/// Maps a [FinishingStatus] to its accent color.
Color finishingStatusColor(FinishingStatus? status) {
  try {
    if (status == null) return const Color(0xFF3B82F6);
    switch (status) {
      case FinishingStatus.superLux:
        return const Color(0xFF10B981); // Emerald Lux
      case FinishingStatus.underConstruction:
        return const Color(0xFFF59E0B); // Glowing Amber
      case FinishingStatus.semiFinished:
        return const Color(0xFF3B82F6); // Electric Ice Blue
    }
  } catch (_) {
    return const Color(0xFF3B82F6);
  }
}

/// Returns a luxury gradient for [FinishingStatus] badge background.
Gradient finishingStatusGradient(FinishingStatus? status) {
  try {
    if (status == null) {
      return const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
      );
    }
    switch (status) {
      case FinishingStatus.superLux:
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF047857)],
        );
      case FinishingStatus.underConstruction:
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFB45309)],
        );
      case FinishingStatus.semiFinished:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        );
    }
  } catch (_) {
    return const LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
    );
  }
}

/// Returns a fitting icon for each [FinishingStatus].
IconData finishingStatusIcon(FinishingStatus? status) {
  try {
    if (status == null) return Icons.architecture_rounded;
    switch (status) {
      case FinishingStatus.superLux:
        return Icons.stars_rounded;
      case FinishingStatus.underConstruction:
        return Icons.construction_rounded;
      case FinishingStatus.semiFinished:
        return Icons.architecture_rounded;
    }
  } catch (_) {
    return Icons.architecture_rounded;
  }
}
