import 'dart:ui';
import 'package:flutter/material.dart';

import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../data/dummy_data.dart';
import 'widgets/area_card.dart';
import 'widgets/contact_section.dart';
import 'widgets/featured_properties_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/recent_properties_section.dart';
import 'widgets/section_bar.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_us_section.dart';

/// Glassmorphic container wrapper with blur filter and subtle gold border.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 0.5,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? AppColors.accent.withValues(alpha: 0.3),
                width: borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Home Screen — Ultra-Premium Landing Page with Full Glassmorphism & 3D Scroll Zoom Effect.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _browseKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Calculate scroll progress (normalized 0.0 to 1.0 based on screen height or content length)
    final double maxScrollExtent = _scrollController.hasClients &&
            _scrollController.position.maxScrollExtent > 0
        ? _scrollController.position.maxScrollExtent
        : (size.height * 3);
    final double scrollProgress = (_scrollOffset / maxScrollExtent).clamp(0.0, 1.0);

    // 3D Depth Parameters:
    // Scale starts at exactly 1.0 (natural size) at top, then expands down to 1.25 as user scrolls
    final double imageScale = 1.0 + (scrollProgress * 0.25);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. Full-Page Natural & Immersive 3D Zoom Background ──────
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRect(
                child: Transform.scale(
                  scale: imageScale,
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/image/background.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // ── 2. Light Clear Gradient Overlay for Vivid Image Visibility ─
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: 0.35),
                      AppColors.background.withValues(alpha: 0.55),
                      AppColors.background.withValues(alpha: 0.75),
                      AppColors.background.withValues(alpha: 0.88),
                    ],
                    stops: const [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Ambient Gold Particles & Glow Layer ────────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBackground(
                shapeColor: AppColors.accent,
                shapeCount: 8,
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // ── 4. Main Scrollable Page Content ───────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // ── 1. Massive Full-Width Hero Section ───────────────────
                RevealOnScroll(
                  duration: const Duration(milliseconds: 900),
                  offset: 20,
                  child: _HeroSection(
                    theme: theme,
                    onBrowseAll: () => _scrollTo(_browseKey),
                    onContact: () => _scrollTo(_contactKey),
                  ),
                ),

                const SizedBox(height: 64),

                // ── 2. Why Choose Us (Trust Indicators) ──────────────────
                const RevealOnScroll(child: WhyUsSection()),

                const SizedBox(height: 64),

                // ── 3. Featured Properties Carousel ──────────────────────
                RevealOnScroll(
                  key: _browseKey,
                  child: const FeaturedPropertiesSection(),
                ),

                const SizedBox(height: 64),

                // ── 4. Neighborhood Grid (Choose Area) ───────────────────
                const RevealOnScroll(
                  child: SectionBar(
                    index: 4,
                    icon: Icons.location_city_rounded,
                    title: 'اختر الحي',
                    subtitle: 'تصفح الشقق المتاحة في أرقى أحياء التجمع الخامس',
                  ),
                ),

                const SizedBox(height: 36),

                RevealOnScroll(
                  delayMilliseconds: 150,
                  child: Padding(
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
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
                ),

                const SizedBox(height: 64),

                // ── 5. Recently Added Properties ────────────────────────
                const RevealOnScroll(child: RecentPropertiesSection()),

                const SizedBox(height: 64),

                // ── 6. How It Works (3 Steps) ────────────────────────────
                const RevealOnScroll(child: HowItWorksSection()),

                const SizedBox(height: 64),

                // ── 7. Testimonials ─────────────────────────────────────
                const RevealOnScroll(child: TestimonialsSection()),

                const SizedBox(height: 64),

                // ── 8. Contact Us (WhatsApp & Facebook) ──────────────────
                RevealOnScroll(
                  key: _contactKey,
                  child: const ContactSection(),
                ),

                const SizedBox(height: 64),

                // ── 9. Footer ───────────────────────────────────────────
                const RevealOnScroll(child: _Footer()),
              ],
            ),
          ),
        ],
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
// Massive Full-Width Hero Section
// ═══════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback? onBrowseAll;
  final VoidCallback? onContact;

  const _HeroSection({
    required this.theme,
    this.onBrowseAll,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                children: [
                      // Gold Decorative Line
                      Container(
                        width: 90,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Brand Chip
                      GlassContainer(
                        borderRadius: 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 9,
                        ),
                        borderColor: AppColors.accent.withValues(alpha: 0.4),
                        borderWidth: 0.5,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.accent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'The 5th Real Estate',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Main Title with Shader Mask Gold Gradient
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.accentGradient.createShader(bounds),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'عقارات\nالتجمع الخامس',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 58,
                              height: 1.12,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Glass Tagline Pill
                      GlassContainer(
                        borderRadius: 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 10,
                        ),
                        borderColor: AppColors.accent.withValues(alpha: 0.5),
                        borderWidth: 0.5,
                        child: Text(
                          '✦  كل العقارات المتاحة في مكان واحد  ✦',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Text(
                        'تصفح كل شقق وبنتهاوس وفيّلات التجمع الخامس من منصة واحدة —\nأسعار مباشرة، صور حقيقية، وتواصل فوري لتحديد معاينتك اليوم',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.9,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 34),

                      // Stats Row with Glassmorphism Cards
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _GlassHeroStat(value: '+50', label: 'مشروع فاخر'),
                          _GlassHeroStat(value: '5', label: 'أحياء راقية'),
                          _GlassHeroStat(value: '+1000', label: 'عميل سعيد'),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // CTA Buttons
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: onBrowseAll,
                              icon: const Icon(Icons.explore_rounded, size: 22),
                              label: const Text('تصفح جميع العقارات'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.textOnPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 34,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: onContact,
                            icon: const Icon(Icons.chat_rounded, size: 20),
                            label: const Text('تواصل معنا'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accent,
                              side: BorderSide(
                                color: AppColors.accent.withValues(alpha: 0.55),
                                width: 1.2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      Container(
                        width: 90,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
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

class _GlassHeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _GlassHeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderColor: AppColors.accent.withValues(alpha: 0.2),
      borderWidth: 0.5,
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Footer
// ═══════════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.domain_rounded,
                    color: AppColors.textOnPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'The 5th Real Estate',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '© 2026 The 5th Real Estate — جميع الحقوق محفوظة',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
