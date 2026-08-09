import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Auto-wrapping row of accent-tinted amenity chips.
class AmenityChips extends StatelessWidget {
  final List<String> amenities;

  const AmenityChips({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.25),
              width: 0.6,
            ),
          ),
          child: Text(
            amenity,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.accentLight2,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
