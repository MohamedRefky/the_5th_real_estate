import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../models/building.dart';

/// Title, badges and construction status header for a building.
class TitleHeaderSection extends StatelessWidget {
  final Building building;

  const TitleHeaderSection({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusBadge(
              label: building.isUnderConstruction
                  ? 'تحت الإنشاء'
                  : 'جاهز للتسليم',
              color: building.isUnderConstruction
                  ? AppColors.warning
                  : AppColors.success,
              filled: false,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            ),
            StatusBadge(
              label: building.area,
              color: AppColors.accentLight2,
              filled: false,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            ),
            if (building.orientation != null)
              StatusBadge(
                label: building.orientation!,
                color: AppColors.accent,
                filled: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              ),
            if (building.areaSqm != null)
              StatusBadge(
                label: '${building.areaSqm!.toInt()}م²',
                color: AppColors.primary,
                filled: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Title
        Text(
          building.name,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
