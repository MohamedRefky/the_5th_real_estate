import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/status_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../models/apartment.dart';

/// Title, badges and finishing status header for an apartment.
class TitleHeaderSection extends StatelessWidget {
  final Apartment apartment;

  const TitleHeaderSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges row
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            StatusBadge(
              label: apartment.finishingStatusLabel,
              color: finishingStatusColor(apartment.finishingStatus),
              gradient: finishingStatusGradient(apartment.finishingStatus),
              icon: finishingStatusIcon(apartment.finishingStatus),
            ),
            StatusBadge(
              label: apartment.unitTypeLabel,
              color: AppColors.primaryMedium,
              textColor: AppColors.accent,
              shadowColor: Colors.black26,
            ),
            StatusBadge(
              label: apartment.area,
              color: AppColors.surface,
              textColor: AppColors.textPrimary,
              shadowColor: Colors.black26,
            ),
            if (apartment.isUnderConstruction)
              const StatusBadge(label: 'تحت الإنشاء', color: AppColors.warning),
          ],
        ),

        const SizedBox(height: 18),

        // Title
        Text(
          apartment.title,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
