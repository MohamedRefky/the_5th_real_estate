import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Section header used across detail screens.
///
/// [gradient] renders the premium gradient icon tile; otherwise a flat
/// accent-colored tile (used by the building details screen).
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool gradient;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.gradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (gradient) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.textOnPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.accent),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
