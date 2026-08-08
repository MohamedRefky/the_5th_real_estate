import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import 'section_bar.dart';

/// Trust Indicators / "Why Choose Us" section — Transparent & Glassmorphic.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.business_rounded,
        value: '+50',
        title: 'مشروع حصري',
        subtitle: 'أرقى الكمبوندات والمشروعات العقارية'
      ),
      (
        icon: Icons.handshake_rounded,
        value: '+1000',
        title: 'عميل سعيد',
        subtitle: 'ثقة نعتز بها على مدار السنوات'
      ),
      (
        icon: Icons.bolt_rounded,
        value: '24/7',
        title: 'استجابة فورية',
        subtitle: 'فريق متخصص لتلبية طلباتك في أي وقت'
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
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
                      children: items.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        final direction = idx == 0
                            ? RevealDirection.fromRight
                            : (idx == 1 ? RevealDirection.scale : RevealDirection.fromLeft);
                        return Expanded(
                          child: RevealOnScroll(
                            direction: direction,
                            delayMilliseconds: idx * 80,
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
                      final direction = idx % 2 == 0
                          ? RevealDirection.fromRight
                          : RevealDirection.fromLeft;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RevealOnScroll(
                          direction: direction,
                          delayMilliseconds: idx * 80,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(28),
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
                const SizedBox(height: 20),
                // Value
                Text(
                  item.value,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
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
