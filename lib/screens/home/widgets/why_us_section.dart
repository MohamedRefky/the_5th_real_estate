import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Trust Indicators / "Why Choose Us" section — Dark Mode.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section header badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'لماذا العقار الخامس؟',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'نلتزم بتقديم أفضل خدمة عقارية بتجربة استثنائية',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 800;
                  if (isDesktop) {
                    return Row(
                      children: items
                          .map((item) => Expanded(
                                child: _buildItem(context, item),
                              ))
                          .toList(),
                    );
                  }
                  return Column(
                    children: items
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildItem(context, item),
                            ))
                        .toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon with gold gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 12,
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
                fontWeight: FontWeight.w800,
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
    );
  }
}
