import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Gold-gradient price pill used as a floating tag on card cover images.
class PriceTagPill extends StatelessWidget {
  final String price;

  const PriceTagPill({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        price,
        style: theme.textTheme.titleSmall?.copyWith(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
