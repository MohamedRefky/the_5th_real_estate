import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Area card on the admin dashboard overview. Shows the neighborhood name,
/// its unit/building counts and one-tap add buttons for each type, so the
/// admin can add to any area without opening the list first.
class AdminAreaCard extends StatelessWidget {
  final String area;
  final int unitCount;
  final int buildingCount;
  final VoidCallback onOpen;
  final VoidCallback onAddUnit;
  final VoidCallback onAddBuilding;

  const AdminAreaCard({
    super.key,
    required this.area,
    required this.unitCount,
    required this.buildingCount,
    required this.onOpen,
    required this.onAddUnit,
    required this.onAddBuilding,
  });

  @override
  Widget build(BuildContext context) {
    final total = unitCount + buildingCount;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_city_rounded,
                          color: AppColors.accent, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            total == 0
                                ? 'لا توجد عقارات بعد'
                                : '$unitCount شقة/فيلا • $buildingCount عمارة',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_left_rounded,
                        color: AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _QuickAddButton(
                        icon: Icons.apartment_rounded,
                        label: 'شقة / فيلا',
                        foreground: AppColors.accent,
                        background: AppColors.accent.withValues(alpha: 0.14),
                        onPressed: onAddUnit,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAddButton(
                        icon: Icons.business_rounded,
                        label: 'عمارة',
                        foreground: const Color(0xFFC084FC),
                        background: const Color(0xFFC084FC).withValues(alpha: 0.14),
                        onPressed: onAddBuilding,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact tinted button used for the quick-add actions on [AdminAreaCard].
class _QuickAddButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;
  final VoidCallback onPressed;

  const _QuickAddButton({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
