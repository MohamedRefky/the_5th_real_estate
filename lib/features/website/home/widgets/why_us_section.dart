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
                                direction: RevealDirection.fromBottom,
                                delayMilliseconds: i * 60,
                                offset: 25,
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
        horizontal: isMobile ? 14 : 22,
        vertical: isMobile ? 18 : 28,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Architectural Monogram Icon
          Container(
            width: isMobile ? 44 : 52,
            height: isMobile ? 44 : 52,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                item.icon,
                size: isMobile ? 20 : 24,
                color: AppColors.accent,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 14 : 18),

          // Title
          Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontSize: isMobile ? 14 : 16.5,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isMobile ? 6 : 8),

          // Subtitle / Description
          Text(
            item.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
              fontSize: isMobile ? 11.5 : 13,
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
