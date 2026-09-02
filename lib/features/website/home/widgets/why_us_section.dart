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
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideDesktop = constraints.maxWidth >= 960;
                  final isMobile = constraints.maxWidth < 600;

                  if (isWideDesktop) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < items.length; i++) ...[
                            if (i > 0) const SizedBox(width: 18),
                            Expanded(
                              child: RevealOnScroll(
                                direction: RevealDirection.flip3D,
                                delayMilliseconds: i * 90,
                                child: _buildItem(context, items[i], false),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  // 2-Column Responsive Layout for Mobile, Tablet & Medium Screens
                  final gap = isMobile ? 12.0 : 16.0;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildItem(context, items[0], isMobile),
                            SizedBox(height: gap),
                            _buildItem(context, items[2], isMobile),
                          ],
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        child: Column(
                          children: [
                            _buildItem(context, items[1], isMobile),
                            SizedBox(height: gap),
                            _buildItem(context, items[3], isMobile),
                          ],
                        ),
                      ),
                    ],
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
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 20,
        vertical: isMobile ? 16 : 26,
      ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.25),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: isMobile ? 12 : 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gradient
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 16),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: isMobile ? 8 : 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  item.icon,
                  size: isMobile ? 20 : 28,
                  color: AppColors.textOnPrimary,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 18),
              // Value Pill Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 14,
                  vertical: isMobile ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
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
                    fontSize: isMobile ? 11.5 : 15,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: isMobile ? 8 : 14),
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: isMobile ? 13 : 16.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isMobile ? 4 : 8),
              Text(
                item.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                  fontSize: isMobile ? 11 : 13,
                ),
                textAlign: TextAlign.center,
                maxLines: isMobile ? 3 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
  }
}
