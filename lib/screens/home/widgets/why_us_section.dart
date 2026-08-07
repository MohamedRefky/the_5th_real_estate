import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Trust Indicators / "Why Choose Us" section for Home Screen.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      (
        icon: Icons.business_rounded,
        title: '+50 مشروع حصري',
        subtitle: 'أرقى الكمبوندات والمشروعات'
      ),
      (
        icon: Icons.handshake_rounded,
        title: '+1000 عميل سعيد',
        subtitle: 'ثقة نعتز بها على مدار السنوات'
      ),
      (
        icon: Icons.bolt_rounded,
        title: 'استجابة فورية',
        subtitle: 'فريق متخصص لتلبية طلباتك'
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'لماذا العقار الخامس؟',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'نلتزم بتقديم أفضل خدمة عقارية بتجربة استثنائية',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 800;
                  if (isDesktop) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: items.map((item) => Expanded(child: _buildItem(context, item))).toList(),
                    );
                  }
                  return Column(
                    children: items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildItem(context, item),
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, ({IconData icon, String title, String subtitle}) item) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 36,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            item.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
