import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Testimonials section for Home Screen.
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final testimonials = [
      (
        name: 'أحمد محمود',
        role: 'مشتري في بيت الوطن',
        comment:
            'تجربة شريعة وممتازة للغاية. المعاينة كانت دقيقة والمعلومات المطروحة عن جدول الإنشاءات صادقة 100%.',
        rating: 5,
      ),
      (
        name: 'م. سارة حسن',
        role: 'مستثمرة في الأندلس',
        comment:
            'التواصل عبر الواتساب مباشر والسريع وفر عليا وقت طويل. أنصح بشركة العقار الخامس لراغبي الفخامة.',
        rating: 5,
      ),
      (
        name: 'د. طارق مصطفى',
        role: 'مشتري بنتهاوس بالنرجس',
        comment:
            'من أفضل تجارب الشراء في التجمع الخامس. احترافية عالية وشفافية في الأسعار والتسليم.',
        rating: 5,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.accent,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'آراء العملاء',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'ماذا يقول عملاؤنا عن تجربتهم مع العقار الخامس',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: testimonials
                          .map((t) => Expanded(child: _buildCard(context, t)))
                          .toList(),
                    );
                  }
                  return Column(
                    children: testimonials
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildCard(context, t),
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

  Widget _buildCard(
    BuildContext context,
    ({String name, String role, String comment, int rating}) testimonial,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                testimonial.rating,
                (i) => const Icon(
                  Icons.star_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '"${testimonial.comment}"',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.7,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 20,
                  child: Text(
                    testimonial.name[0],
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      testimonial.role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
