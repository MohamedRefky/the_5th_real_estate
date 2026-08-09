import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/apartment.dart';

/// Full description card with optional free-text note.
class DescriptionSection extends StatelessWidget {
  final Apartment apartment;

  const DescriptionSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'الوصف والتفاصيل الكاملة',
          icon: Icons.description_rounded,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.divider.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                apartment.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: AppColors.textPrimary,
                ),
              ),
              if (apartment.freeDescription != null &&
                  apartment.freeDescription!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.note_alt_rounded,
                        size: 18,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          apartment.freeDescription!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
