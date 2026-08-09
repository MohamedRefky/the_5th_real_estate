import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/building.dart';

/// Key building stats (floors / total units / available units) as a compact
/// frosted row of `_StatItem`s separated by dividers.
class BuildingStatsRow extends StatelessWidget {
  final Building building;

  const BuildingStatsRow({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.layers_rounded,
            label: 'الأدوار',
            value: '${building.totalFloors} أدوار',
          ),
          _buildDivider(),
          _StatItem(
            icon: Icons.grid_view_rounded,
            label: 'إجمالي الوحدات',
            value: '${building.totalUnits} شقة',
          ),
          _buildDivider(),
          _StatItem(
            icon: Icons.door_front_door_rounded,
            label: 'المتاح حالياً',
            value: '${building.availableUnits} شقة',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

Widget _buildDivider() {
  return Container(
    height: 24,
    width: 1,
    color: Colors.white.withValues(alpha: 0.12),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: highlight ? AppColors.accent : AppColors.textSecondary,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.accent : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textHint,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
