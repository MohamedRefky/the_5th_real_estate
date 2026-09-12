import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Ultra-premium section header bar.
///
/// Features a glowing translucent icon badge, luxury gold gradient title,
/// crisp subtitle, and a sparkling decorative underline.
class SectionBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SectionBar({
    super.key,
    int? index, // Kept optional for backward compatibility
    required this.icon,
    required this.title,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Architectural Monogram Pill ──────────────────────────
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: AppColors.accent,
                    size: isMobile ? 15 : 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isMobile ? 12 : 16),

            // ── Section Headline (Clean & Architectural) ─────────────
            if (subtitle.isNotEmpty) ...[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? 320 : 620),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 18 : 24,
                    height: 1.35,
                  ),
                ),
              ),
            ] else ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 20 : 26,
                  height: 1.3,
                ),
              ),
            ],

            SizedBox(height: isMobile ? 8 : 12),

            // ── Elegant Architectural Hairline ───────────────────────
            Container(
              width: isMobile ? 40 : 56,
              height: 1.5,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
