import 'dart:ui' show Color;

import '../../models/apartment.dart';
import '../theme/app_colors.dart';

/// Maps a [FinishingStatus] to its accent color.
///
/// Previously duplicated in `apartment_card.dart` and the apartment details
/// title header; centralized here so UI code stays free of color decisions.
Color finishingStatusColor(FinishingStatus status) {
  switch (status) {
    case FinishingStatus.superLux:
      return AppColors.success;
    case FinishingStatus.semiFinished:
      return AppColors.info;
    case FinishingStatus.underConstruction:
      return AppColors.warning;
  }
}
