import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/apartment.dart';

/// Price callout: gradient price badge + optional delivery date tag.
class PriceSection extends StatelessWidget {
  final Apartment apartment;

  const PriceSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Compact Metallic Price Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.sell_rounded,
                size: 20,
                color: AppColors.textOnPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'السعر: ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                apartment.formattedPrice,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        // Delivery date tag (if under construction)
        if (apartment.isUnderConstruction &&
            apartment.formattedDeliveryDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.event_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  'التسليم المتوقع: ${apartment.formattedDeliveryDate}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
