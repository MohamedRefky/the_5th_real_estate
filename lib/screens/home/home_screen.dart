import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
// ignore: unused_import
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/metallic_gloss.dart';
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // ── Scroll-driven animation parameters ──────────────────────────
    double maxScroll = size.height * 3;
    if (_scrollController.hasClients) {
      try {
        final pos = _scrollController.position;
        if (pos.hasContentDimensions && pos.maxScrollExtent > 0) {
          maxScroll = pos.maxScrollExtent;
        }
      } catch (_) {
        // Fallback safely if scroll position is not attached yet
      }
    }
    final double scrollProgress =
        (_scrollOffset / maxScroll).clamp(0.0, 1.0);

    // Background: gentle zoom as you scroll (1.0 → 1.20)
    final double imageScale = 1.0 + (scrollProgress * 0.20);

    // Hero content: fades out and drifts up as user scrolls past it
    final double heroScrollRatio =
        (_scrollOffset / (size.height * 0.65)).clamp(0.0, 1.0);
    final double heroOpacity = (1.0 - heroScrollRatio).clamp(0.0, 1.0);
    final double heroDriftY = heroScrollRatio * -60;

    // Overlay: darkens gradually as you scroll deeper into content
    final double overlayTopAlpha =
        (0.35 + scrollProgress * 0.30).clamp(0.0, 1.0);
    final double overlayBottomAlpha =
        (0.88 + scrollProgress * 0.08).clamp(0.0, 1.0);

    // Scroll-to-top FAB visibility
    final bool showScrollToTop = _scrollOffset > size.height * 0.8;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. Full-Page 3D Zoom Background ─────────────────────────
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

          // ── 2. Dynamic Gradient Overlay (darkens on scroll) ─────────
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background
                          .withValues(alpha: overlayTopAlpha),
                      AppColors.background.withValues(alpha: 0.55),
                      AppColors.background.withValues(alpha: 0.78),
                      AppColors.background
                          .withValues(alpha: overlayBottomAlpha),
                    ],
                    stops: const [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Ambient Gold Particles & Glow (Disabled) ──────────────
          // Positioned.fill(
          //   child: IgnorePointer(
          //     child: AnimatedBackground(
          //       shapeColor: AppColors.accent,
          //       shapeCount: 8,
          //       child: const SizedBox.expand(),
          //     ),
          //   ),
          // ),

          // ── 4. Main Scrollable Content ──────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // ── Hero Section with Parallax Fade-Out ────────────────
                Transform.translate(
                  offset: Offset(0, heroDriftY),
                  child: Opacity(
                    opacity: heroOpacity,
                    child: _HeroSection(
                      theme: theme,
                      onBrowseAll: () => _scrollTo(_browseKey),
                      onContact: () => _scrollTo(_contactKey),
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                // ── Why Choose Us ─────────────────────────────────────
                const WhyUsSection(),

                const SizedBox(height: 64),

                // ── Featured Properties ───────────────────────────────
                SizedBox(
                  key: _browseKey,
                  child: const FeaturedPropertiesSection(),
                ),

                const SizedBox(height: 64),

                // ── Neighborhood Grid Header (3D Scale Reveal) ────────
                const RevealOnScroll(
                  direction: RevealDirection.scale,
                  child: SectionBar(
                    index: 4,
                    icon: Icons.location_city_rounded,
                    title: 'اختر الحي',
                    subtitle:
                        'تصفح الشقق المتاحة في أرقى أحياء التجمع الخامس',
                  ),
                ),

                const SizedBox(height: 36),

                // ── Neighborhood Grid ─────────────────────────────────
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
                              return RevealOnScroll(
                                direction: RevealDirection.elasticPop,
                                delayMilliseconds: index * 80,
                                child: AreaCard(
                                  areaName: area,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesNames.area,
                                      arguments: area,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                // ── Recently Added ────────────────────────────────────
                const RecentPropertiesSection(),

                const SizedBox(height: 64),

                // ── How It Works ──────────────────────────────────────
                const HowItWorksSection(),

                const SizedBox(height: 64),

                // ── Testimonials ──────────────────────────────────────
                const TestimonialsSection(),

                const SizedBox(height: 64),

                // ── Contact Us ────────────────────────────────────────
                SizedBox(
                  key: _contactKey,
                  child: const ContactSection(),
                ),

                const SizedBox(height: 64),

                // ── Footer (From Bottom) ──────────────────────────────
                const RevealOnScroll(
                  direction: RevealDirection.fromBottom,
                  child: _Footer(),
                ),
              ],
            ),
          ),

          // ── 5. Animated Scroll-to-Top FAB ──────────────────────────
          Positioned(
            bottom: 28,
            right: 28,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              offset: showScrollToTop ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                opacity: showScrollToTop ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !showScrollToTop,
                  child: GestureDetector(
                    onTap: _scrollToTop,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: AppColors.textOnPrimary,
                              size: 28,
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: MetallicGloss(
                                borderRadius: 16,
                                strength: 0.85,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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

class _HeroSection extends StatefulWidget {
  final ThemeData theme;
  final VoidCallback? onBrowseAll;
  final VoidCallback? onContact;

  const _HeroSection({required this.theme, this.onBrowseAll, this.onContact});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> with SingleTickerProviderStateMixin {
  /// One-shot staggered entrance controller (completes, never repeats).
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..forward();

  late final List<Animation<double>> _steps = [
    _step(0.00),
    _step(0.06),
    _step(0.13),
    _step(0.19),
    _step(0.25),
    _step(0.31),
    _step(0.37),
  ];

  Animation<double> _step(double start) => CurvedAnimation(
        parent: _entrance,
        curve: Interval(
          start,
          (start + 0.42).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      );

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                children: [
                  // Decorative Line
                  _HeroEntrance(
                    animation: _steps[0],
                    child: Container(
                      width: 90,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Brand Chip
                  _HeroEntrance(
                    animation: _steps[1],
                    child: GlassContainer(
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
                  ),

                  const SizedBox(height: 26),

                  // Main Title — Rich Champagne Gold with Luxury Depth Shadows
                  _HeroEntrance(
                    animation: _steps[2],
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'عقارات\nالتجمع الخامس',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 58,
                          height: 1.12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                            Shadow(
                              color: AppColors.accentDark.withValues(alpha: 0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 2),
                            ),
                            Shadow(
                              color:
                                  AppColors.accentLight2.withValues(alpha: 0.32),
                              blurRadius: 44,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Glass Tagline Pill
                  _HeroEntrance(
                    animation: _steps[3],
                    child: GlassContainer(
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
                  ),

                  const SizedBox(height: 22),

                  // Subtitle
                  _HeroEntrance(
                    animation: _steps[4],
                    child: Text(
                      'تصفح كل شقق وبنتهاوس وفيّلات التجمع الخامس من منصة واحدة —\nأسعار مباشرة، صور حقيقية، وتواصل فوري لتحديد معاينتك اليوم',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.9,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Stats Row with Glassmorphism Cards
                  _HeroEntrance(
                    animation: _steps[5],
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _GlassHeroStat(value: '+50', label: 'مشروع فاخر'),
                        _GlassHeroStat(value: '5', label: 'أحياء راقية'),
                        _GlassHeroStat(value: '+1000', label: 'عميل سعيد'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // CTA Buttons
                  _HeroEntrance(
                    animation: _steps[6],
                    child: Wrap(
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
                          child: Stack(
                            children: [
                              ElevatedButton.icon(
                                onPressed: widget.onBrowseAll,
                                icon:
                                    const Icon(Icons.explore_rounded, size: 22),
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
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: MetallicGloss(
                                    borderRadius: 18,
                                    strength: 0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: widget.onContact,
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

/// Fades + drifts a hero element up as its staggered [animation] progresses.
class _HeroEntrance extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _HeroEntrance({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 26),
            child: child,
          ),
        );
      },
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
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
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
