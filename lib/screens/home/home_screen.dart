import 'package:flutter/material.dart';

import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import 'widgets/area_card.dart';
import 'widgets/featured_properties_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/recent_properties_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_us_section.dart';

/// Home Screen — the main landing page of "The 5th Estate".
///
/// Complete Landing Page Flow:
/// 1. Hero Header
/// 2. Trust Indicators (Why Choose Us)
/// 3. Featured Properties Carousel
/// 4. Neighborhood Grid (Choose Area)
/// 5. Recently Added Properties
/// 6. How It Works (3 Steps)
/// 7. Customer Testimonials
/// 8. Footer
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── 1. Hero Header ──────────────────────────────────────
            _HeroSection(theme: theme),

            // ── 2. Why Choose Us (Trust Indicators) ─────────────────
            const WhyUsSection(),

            const SizedBox(height: 32),

            // ── 3. Featured Properties ──────────────────────────────
            const FeaturedPropertiesSection(),

            const SizedBox(height: 32),

            // ── 4. Neighborhood Grid (Choose Area) ──────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'اختر الحي',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'تصفح الشقق المتاحة في أرقى أحياء التجمع الخامس',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = _getCrossAxisCount(
                        constraints.maxWidth,
                      );
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: DummyData.areas.length,
                        itemBuilder: (context, index) {
                          final area = DummyData.areas[index];
                          return AreaCard(
                            areaName: area,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesNames.area,
                                arguments: area,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ── 5. Recently Added Properties ────────────────────────
            const RecentPropertiesSection(),

            const SizedBox(height: 32),

            // ── 6. How It Works ─────────────────────────────────────
            const HowItWorksSection(),

            // ── 7. Testimonials ─────────────────────────────────────
            const TestimonialsSection(),

            const SizedBox(height: 32),

            // ── 8. Footer ───────────────────────────────────────────
            _Footer(theme: theme),
          ],
        ),
      ),
    );
  }

  /// Responsive column count based on screen width.
  int _getCrossAxisCount(double width) {
    if (width >= 900) return 3;
    if (width >= 550) return 2;
    return 1;
  }
}

// ═══════════════════════════════════════════════════════════════════
// Hero Section
// ═══════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final ThemeData theme;
  const _HeroSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            Color(0xFF0D1B2A), // Deeper navy for depth
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  // ── Gold decorative line ───────────────────────
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Brand icon ─────────────────────────────────
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.domain_rounded,
                      size: 36,
                      color: AppColors.accent,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── App title ──────────────────────────────────
                  Text(
                    'العقار الخامس',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Tagline ────────────────────────────────────
                  Text(
                    'وجهتك الأولى للعقارات الفاخرة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'اكتشف أرقى الشقق في أفضل الأحياء السكنية\nبأسعار تنافسية وخطط سداد مرنة',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Gold decorative line ───────────────────────
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Footer
// ═══════════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  final ThemeData theme;
  const _Footer({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: AppColors.primary,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.domain_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'العقار الخامس',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '© 2026 العقار الخامس — جميع الحقوق محفوظة',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
