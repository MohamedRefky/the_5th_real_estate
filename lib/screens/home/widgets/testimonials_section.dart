import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'section_bar.dart';

/// Testimonials section — Transparent & Glassmorphic.
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      (
        name: 'أحمد محمود',
        role: 'مشتري في بيت الوطن',
        comment:
            'تجربة ممتازة للغاية. المعاينة كانت دقيقة والمعلومات المطروحة عن جدول الإنشاءات صادقة 100%.',
        rating: 5,
      ),
      (
        name: 'م. سارة حسن',
        role: 'مستثمرة في الأندلس',
        comment:
            'التواصل عبر الواتساب المباشر والسريع وفر عليّ وقت طويل. أنصح بشركة The 5th Real Estate لراغبي الفخامة.',
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionBar(
                icon: Icons.format_quote_rounded,
                title: 'آراء العملاء',
                subtitle: 'ماذا يقول عملاؤنا عن تجربتهم مع The 5th Real Estate',
              ),
              const SizedBox(height: 44),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: testimonials
                          .map(
                              (t) => Expanded(child: _buildCard(context, t)))
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote icon + stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.accent.withValues(alpha: 0.7),
                      size: 32,
                    ),
                    Row(
                      children: List.generate(
                        testimonial.rating,
                        (i) => const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.star_rounded,
                            color: AppColors.accent,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Comment
                Text(
                  '"${testimonial.comment}"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.4),
                        AppColors.accent.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Author
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          testimonial.name[0],
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
                            color: AppColors.textPrimary,
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
        ),
      ),
    );
  }
}
