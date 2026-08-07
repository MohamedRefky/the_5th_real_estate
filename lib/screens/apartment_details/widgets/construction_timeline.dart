import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/apartment.dart';

/// Visual construction timeline with progress indicator.
///
/// Displays milestones as a vertical stepper with:
/// - Completed steps (gold filled circle + checkmark)
/// - Pending steps (outlined circle)
/// - Connecting lines between steps
/// - Overall progress bar at the top
class ConstructionTimeline extends StatelessWidget {
  final Apartment apartment;

  const ConstructionTimeline({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مراحل البناء',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (apartment.formattedDeliveryDate != null)
                      Text(
                        'هيتسلم ${apartment.formattedDeliveryDate}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Progress Bar ─────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'نسبة الإنجاز',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(apartment.constructionProgress * 100).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: apartment.constructionProgress,
                  minHeight: 10,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progressColor(apartment.constructionProgress),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Milestones ───────────────────────────────────────
          ...List.generate(apartment.milestones.length, (index) {
            final milestone = apartment.milestones[index];
            final isLast = index == apartment.milestones.length - 1;
            return _MilestoneItem(
              milestone: milestone,
              isLast: isLast,
              theme: theme,
            );
          }),
        ],
      ),
    );
  }

  Color _progressColor(double progress) {
    if (progress >= 0.8) return AppColors.success;
    if (progress >= 0.5) return AppColors.accent;
    return AppColors.warning;
  }
}

// ═══════════════════════════════════════════════════════════════════

class _MilestoneItem extends StatelessWidget {
  final ConstructionMilestone milestone;
  final bool isLast;
  final ThemeData theme;

  const _MilestoneItem({
    required this.milestone,
    required this.isLast,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline indicator ───────────────────────────────
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: milestone.isCompleted
                        ? AppColors.accent
                        : AppColors.surface,
                    border: Border.all(
                      color: milestone.isCompleted
                          ? AppColors.accent
                          : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: milestone.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: AppColors.textOnPrimary,
                        )
                      : Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.divider,
                            ),
                          ),
                        ),
                ),

                // Connecting line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: milestone.isCompleted
                          ? AppColors.accent
                          : AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Content ──────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: milestone.isCompleted
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(milestone.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: milestone.isCompleted
                          ? AppColors.accent
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Status badge ─────────────────────────────────────
          if (milestone.isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'مكتمل',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'قيد التنفيذ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل',
      'مايو', 'يونيو', 'يوليو', 'أغسطس',
      'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
