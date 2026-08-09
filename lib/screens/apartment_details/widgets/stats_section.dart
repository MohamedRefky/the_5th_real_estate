import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/apartment.dart';

/// Key stats (rooms, baths, area, floor) shown as premium cards.
class StatsSection extends StatelessWidget {
  final Apartment apartment;

  const StatsSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatCard(
          icon: Icons.bed_rounded,
          value: '${apartment.rooms} غرف',
          label: 'غرف النوم',
        ),
        _StatCard(
          icon: Icons.bathtub_rounded,
          value: '${apartment.bathrooms} حمامات',
          label: 'الحمامات',
        ),
        _StatCard(
          icon: Icons.square_foot_rounded,
          value: '${apartment.areaSqm.toInt()} م²',
          label: 'المساحة',
        ),
        _StatCard(
          icon: Icons.layers_rounded,
          value: apartment.floorLabel,
          label: 'الدور',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: AppColors.textOnPrimary),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
