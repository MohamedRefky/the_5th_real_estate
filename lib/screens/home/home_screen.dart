import 'package:flutter/material.dart';
import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_background.dart';
import '../../data/dummy_data.dart';
import 'widgets/area_card.dart';
import 'widgets/featured_properties_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/recent_properties_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_us_section.dart';

/// Home Screen — Premium landing page for "The 5th Estate".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── 1. Hero Header with Animated Background ─────────
            _HeroSection(theme: theme),

            // ── 2. Why Choose Us (Trust Indicators) ─────────────
            const WhyUsSection(),

            // ── 3. Featured Properties ──────────────────────────
            const FeaturedPropertiesSection(),

            const SizedBox(height: 16),

            // ── 4. Neighborhood Grid (Choose Area) ──────────────
            _SectionDivider(),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.location_city_rounded,
                      color: AppColors.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'اختر الحي',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تصفح الشقق المتاحة في أرقى أحياء التجمع الخامس',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
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
                          childAspectRatio: 1.05,
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

            // ── 5. Recently Added Properties ────────────────────
            const RecentPropertiesSection(),

            // ── 6. How It Works ─────────────────────────────────
            const HowItWorksSection(),

            // ── 7. Testimonials ─────────────────────────────────
            const TestimonialsSection(),

            // ── 8. Footer ───────────────────────────────────────
            _Footer(theme: theme),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 900) return 3;
    if (width >= 550) return 2;
    return 1;
  }
}

// ═══════════════════════════════════════════════════════════════════
// Section Divider
// ═══════════════════════════════════════════════════════════════════

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0),
                  AppColors.accent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent,
                  AppColors.accent.withValues(alpha: 0),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Hero Section — with Animated Background
// ═══════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final ThemeData theme;
  const _HeroSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      shapeColor: AppColors.accent,
      shapeCount: 18,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    // ── Gold decorative line ───────────────────
                    _GoldLine(),

                    const SizedBox(height: 32),

                    // ── Brand icon ─────────────────────────────
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.accent.withValues(alpha: 0.15),
                            AppColors.accent.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.domain_rounded,
                        size: 38,
                        color: AppColors.accent,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── App title ──────────────────────────────
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.goldGradient.createShader(bounds),
                      child: Text(
                        'العقار الخامس',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Tagline ────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '✦  وجهتك الأولى للعقارات الفاخرة  ✦',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'اكتشف أرقى الشقق في أفضل الأحياء السكنية\nبأسعار تنافسية وخطط سداد مرنة',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Stats Row ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _HeroStat(value: '+50', label: 'مشروع'),
                        _HeroStatDivider(),
                        _HeroStat(value: '+1000', label: 'عميل'),
                        _HeroStatDivider(),
                        _HeroStat(value: '5', label: 'أحياء'),
                      ],
                    ),

                    const SizedBox(height: 32),

                    _GoldLine(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 3,
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.accent.withValues(alpha: 0.3),
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
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Center(
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.goldGradient.createShader(bounds),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.domain_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'العقار الخامس',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '© 2026 العقار الخامس — جميع الحقوق محفوظة',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
