import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/building.dart';

/// Key stats for a building displayed in a bordered container.
class StatsSection extends StatelessWidget {
  final Building building;

  const StatsSection({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final stats = [
      if (building.areaSqm != null)
        (
          icon: Icons.square_foot_rounded,
          label: 'مساحة الأرض',
          value: '${building.areaSqm!.toInt()} م²',
        )
      else
        (
          icon: Icons.layers_rounded,
          label: 'إجمالي الأدوار',
          value: '${building.totalFloors} أدوار',
        ),
      (
        icon: Icons.domain_rounded,
        label: 'إجمالي الشقق',
        value: '${building.totalUnits} شقة',
      ),
      (
        icon: Icons.door_front_door_rounded,
        label: 'المتاح للبيع',
        value: '${building.availableUnits} شقة',
      ),
      (
        icon: Icons.brush_rounded,
        label: 'مستوى التشطيب',
        value: building.finishingStatus.label,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(s.icon, color: AppColors.accent, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                s.value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                s.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
