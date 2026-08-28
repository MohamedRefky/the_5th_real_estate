import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/metallic_gloss.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 1. Glowing Translucent Glass Icon Badge ──────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 11 : 16),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      blurRadius: isMobile ? 12 : 20,
                      spreadRadius: isMobile ? 1 : 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      icon,
                      color: AppColors.accent,
                      size: isMobile ? 20 : 28,
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: MetallicGloss(
                          borderRadius: isMobile ? 16 : 20,
                          strength: 0.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: isMobile ? 10 : 16),

          // ── 2. Gold Title ──────────────────────────────────────────
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
              fontSize: isMobile ? 20 : 26,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
                Shadow(
                  color: AppColors.accentLight2.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),

          if (subtitle.isNotEmpty) ...[
            SizedBox(height: isMobile ? 5 : 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isMobile ? 320 : 550),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                  fontSize: isMobile ? 12.5 : 14,
                ),
              ),
            ),
          ],

          SizedBox(height: isMobile ? 10 : 16),

          // ── 3. Sparkling Accent Underline ───────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 22 : 32,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0),
                      AppColors.accent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: isMobile ? 5 : 7,
                height: isMobile ? 5 : 7,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: isMobile ? 22 : 32,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent,
                      AppColors.accent.withValues(alpha: 0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
