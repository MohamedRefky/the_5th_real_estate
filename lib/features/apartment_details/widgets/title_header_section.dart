import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/status_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/apartment.dart';

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
              label: apartment.finishingStatus.label,
              color: finishingStatusColor(apartment.finishingStatus),
            ),
            StatusBadge(label: apartment.unitType.label, color: AppColors.accent),
            StatusBadge(label: apartment.area, color: AppColors.accentLight2),
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
