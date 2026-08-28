import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
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
            'التواصل عبر الواتساب المباشر والسريع وفر عليّ وقت طويل. أنصح التعامل مع  The 5th Real Estate.',
        rating: 5,
      ),
      (
        name: 'د. طارق مصطفى',
        role: 'مشتري فى النرجس الجديدة',
        comment:
            'من أفضل تجارب الشراء في التجمع الخامس. احترافية عالية وشفافية في الأسعار وتسليم الاوراق.',
        rating: 5,
      ),
    ];

    return Container(
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;
                  final isMobile = constraints.maxWidth < 600;

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: testimonials.asMap().entries
                          .map(
                            (entry) => Expanded(
                              child: RevealOnScroll(
                                direction: RevealDirection.polaroidTilt,
                                delayMilliseconds: entry.key * 90,
                                child: _buildCard(context, entry.value, false),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                  return Column(
                    children: testimonials.asMap().entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RevealOnScroll(
                                direction: RevealDirection.polaroidTilt,
                                delayMilliseconds: entry.key * 90,
                                child: _buildCard(context, entry.value, isMobile),
                              ),
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
    bool isMobile,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 16 : 28),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote icon + stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.accent.withValues(alpha: 0.7),
                      size: isMobile ? 22 : 32,
                    ),
                    Row(
                      children: List.generate(
                        testimonial.rating,
                        (i) => Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.star_rounded,
                            color: const Color(0xFFFFB800),
                            size: isMobile ? 15 : 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 10 : 16),

                // Comment
                Text(
                  testimonial.comment,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    fontSize: isMobile ? 13 : 14.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isMobile ? 14 : 24),

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
                SizedBox(height: isMobile ? 10 : 16),

                // Author
                Row(
                  children: [
                    Container(
                      width: isMobile ? 36 : 44,
                      height: isMobile ? 36 : 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(isMobile ? 10 : 14),
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
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 14 : 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testimonial.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: isMobile ? 13.5 : 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            testimonial.role,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: isMobile ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
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
}
