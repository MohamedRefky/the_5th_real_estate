import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import 'section_bar.dart';

/// Trust Indicators / "Why Choose Us" section — Transparent & Glassmorphic.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.business_rounded,
        value: 'مشاريع حصرية',
        title: 'شراكات مباشرة',
        subtitle: 'شراكات مباشرة مع كبرى شركات التطوير العقاري',
      ),
      (
        icon: Icons.verified_rounded,
        value: 'وكيل معتمد',
        title: 'شراكة موثوقة',
        subtitle: 'تعاقدات رسمية مع كبار الملاك والمطورين',
      ),
      (
        icon: Icons.handshake_rounded,
        value: 'ثقة وأمان',
        title: 'عملاء مستمرون',
        subtitle: 'سجل حافل من الصفقات الناجحة والثقة المتبادلة',
      ),
      (
        icon: Icons.bolt_rounded,
        value: 'استجابة سريعة',
        title: 'معاينة فوريه',
        subtitle: 'فريق متخصص لخدمتك في أي وقت وطوال الأسبوع',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionBar(
                icon: Icons.verified_rounded,
                title: 'لماذا The 5th Real Estate؟',
                subtitle: 'نلتزم بتقديم أفضل خدمة عقارية بتجربة استثنائية',
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 800;
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return Expanded(
                          child: RevealOnScroll(
                            direction: RevealDirection.flip3D,
                            delayMilliseconds: idx * 90,
                            child: _buildItem(context, item),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Column(
                    children: items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RevealOnScroll(
                          direction: RevealDirection.flip3D,
                          delayMilliseconds: idx * 90,
                          child: _buildItem(context, item),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    ({IconData icon, String value, String title, String subtitle}) item,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.25),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with gradient
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Icon(
                    item.icon,
                    size: 28,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                // Value Pill Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item.value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
