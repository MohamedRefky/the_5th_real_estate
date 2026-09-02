import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/metallic_gloss.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../data/dummy_data.dart';
import '../../../../data/public_building_repository.dart';
import '../../../../data/public_property_repository.dart';
import '../widgets/area_card.dart';
import '../widgets/contact_section.dart';
import '../widgets/featured_properties_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/home_footer.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/recent_properties_section.dart';
import '../widgets/section_bar.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/why_us_section.dart';

/// Home Screen — Ultra-Premium Landing Page with Full Glassmorphism & 3D Scroll Zoom Effect.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _browseKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _neighborhoodKey = GlobalKey();
  final GlobalKey _buildingsKey = GlobalKey();
  final GlobalKey _recentKey = GlobalKey();
  final GlobalKey _howKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _whyKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  String? _activeSection;

  static const List<String> _navOrder = [
    'لماذا نحن',
    'المميزة',
    'شقق',
    'عمارات',
    'أحدث العقارات',
    'آراء العملاء',
    'تواصل معنا',
  ];

  /// Precomputed building counts per area (from Firestore, avoids re-filtering
  /// on every grid item build).
  late final Future<Map<String, int>> _buildingCounts = _loadBuildingCounts();

  Future<Map<String, int>> _loadBuildingCounts() async {
    final all = await PublicBuildingRepository.instance.all();
    final counts = <String, int>{};
    for (final area in DummyData.areas) {
      counts[area] = all.where((b) => b.area == area).length;
    }
    return counts;
  }

  Map<String, GlobalKey> get _sectionKeys => {
    'لماذا نحن': _whyKey,
    'المميزة': _browseKey,
    'شقق': _neighborhoodKey,
    'عمارات': _buildingsKey,
    'أحدث العقارات': _recentKey,
    'آراء العملاء': _testimonialsKey,
    'تواصل معنا': _contactKey,
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Warm up properties and buildings in parallel for lightning-fast loading
    PublicPropertyRepository.instance.all(forceRefresh: false);
    PublicBuildingRepository.instance.all();
  }

  /// Only tracks the active nav section; scroll-driven visuals listen to the
  /// controller directly so plain scrolling never rebuilds the whole page.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    String? active;
    for (final label in _navOrder) {
      final key = _sectionKeys[label];
      if (key == null) continue;
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderBox) continue;
      final dy = renderObject.localToGlobal(Offset.zero).dy;
      if (dy <= 160) active = label;
    }
    if (active != _activeSection) {
      setState(() => _activeSection = active);
    }
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
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  void _scrollToSection(String label) {
    final key = _sectionKeys[label];
    if (key != null) _scrollTo(key);
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
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final sectionSpacing = isMobile ? 38.0 : 64.0;
    final headerSpacing = isMobile ? 22.0 : 36.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. Full-Page 3D Zoom Background ─────────────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: _ZoomingBackground(controller: _scrollController),
              ),
            ),
          ),

          // ── 2. Dynamic Gradient Overlay (darkens on scroll) ─────────
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: _GradientOverlay(controller: _scrollController),
              ),
            ),
          ),

          // ── 3. Main Scrollable Content ──────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // ── Hero Section with Parallax Fade-Out ────────────────
                _ParallaxHero(
                  controller: _scrollController,
                  onBrowseAll: () => _scrollTo(_browseKey),
                  onContact: () => _scrollTo(_contactKey),
                ),

                SizedBox(height: sectionSpacing),

                // ── Why Choose Us ─────────────────────────────────────
                SizedBox(key: _whyKey, child: const WhyUsSection()),

                SizedBox(height: sectionSpacing),

                // ── Featured Properties ───────────────────────────────
                SizedBox(
                  key: _browseKey,
                  child: const FeaturedPropertiesSection(),
                ),

                SizedBox(height: sectionSpacing),

                // ── Apartments Neighborhood Grid Header ───────────────
                const SectionBar(
                  index: 4,
                  icon: Icons.location_city_rounded,
                  title: 'شقق',
                  subtitle: 'تصفح الشقق المتاحة في أرقى أحياء التجمع الخامس',
                ),

                SizedBox(height: headerSpacing),

                // ── Apartments Neighborhood Grid ──────────────────────
                Padding(
                  key: _neighborhoodKey,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = _getCrossAxisCount(
                            constraints.maxWidth,
                          );
                          final spacing = isMobile ? 12.0 : 24.0;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: isMobile ? 0.98 : 1.05,
                                ),
                            itemCount: DummyData.areas.length,
                            itemBuilder: (context, index) {
                              final area = DummyData.areas[index];
                              final card = AreaCard(
                                areaName: area,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesNames.area,
                                    arguments: area,
                                  );
                                },
                              );

                              if (isMobile) return card;

                              return RevealOnScroll(
                                direction: RevealDirection.elasticPop,
                                delayMilliseconds: index * 80,
                                child: card,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: sectionSpacing),

                // ── Buildings Neighborhood Grid Header ────────────────
                const SectionBar(
                  index: 5,
                  icon: Icons.apartment_rounded,
                  title: 'عمارات',
                  subtitle:
                      'استكشف المشروعات والعمارات السكنية في أحياء التجمع الخامس',
                ),

                SizedBox(height: headerSpacing),

                // ── Buildings Neighborhood Grid ───────────────────────
                Padding(
                  key: _buildingsKey,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: FutureBuilder<Map<String, int>>(
                        future: _buildingCounts,
                        builder: (context, countsSnapshot) {
                          final counts = countsSnapshot.data ?? const <String, int>{};
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount = _getCrossAxisCount(
                                constraints.maxWidth,
                              );
                              final spacing = isMobile ? 12.0 : 24.0;
                              final totalItems = buildingMainAreas.length + 1;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: spacing,
                                      mainAxisSpacing: spacing,
                                      childAspectRatio: isMobile ? 0.98 : 1.05,
                                    ),
                                itemCount: totalItems,
                                itemBuilder: (context, index) {
                                  if (index == buildingMainAreas.length) {
                                    final card = AreaCard(
                                      areaName: buildingOtherAreasLabel,
                                      customBadgeText:
                                          'عمارات بأماكن متنوعة',
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutesNames.buildingsArea,
                                          arguments: {
                                            'label': buildingOtherAreasLabel,
                                            'areas': buildingOtherAreas,
                                          },
                                        );
                                      },
                                    );

                                    if (isMobile) return card;

                                    return RevealOnScroll(
                                      direction: RevealDirection.elasticPop,
                                      delayMilliseconds: index * 80,
                                      child: card,
                                    );
                                  }
                                  final area = buildingMainAreas[index];
                                  final bldCount = counts[area] ?? 0;
                                  final card = AreaCard(
                                    areaName: area,
                                    customBadgeText: '$bldCount عمارة متاحة',
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesNames.buildingsArea,
                                        arguments: area,
                                      );
                                    },
                                  );

                                  if (isMobile) return card;

                                  return RevealOnScroll(
                                    direction: RevealDirection.elasticPop,
                                    delayMilliseconds: index * 80,
                                    child: card,
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

                SizedBox(height: sectionSpacing),

                // ── Recently Added ────────────────────────────────────
                SizedBox(
                  key: _recentKey,
                  child: const RecentPropertiesSection(),
                ),

                SizedBox(height: sectionSpacing),

                // ── How It Works ──────────────────────────────────────
                SizedBox(key: _howKey, child: const HowItWorksSection()),

                SizedBox(height: sectionSpacing),

                // ── Testimonials ──────────────────────────────────────
                SizedBox(
                  key: _testimonialsKey,
                  child: const TestimonialsSection(),
                ),

                SizedBox(height: sectionSpacing),

                // ── Contact Us ────────────────────────────────────────
                SizedBox(key: _contactKey, child: const ContactSection()),

                SizedBox(height: sectionSpacing),

                // ── Footer ───────────────────────────────────────────
                const HomeFooter(),
              ],
            ),
          ),

          // ── 4. Floating Glass Top Navigation Bar ────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeTopBar(
              activeSection: _activeSection,
              labels: _navOrder,
              onSelect: _scrollToSection,
              onHomeTap: _scrollToTop,
            ),
          ),

          // ── 5. Animated Scroll-to-Top FAB ──────────────────────────
          Positioned(
            bottom: 28,
            right: 28,
            child: _ScrollTopFab(
              controller: _scrollController,
              onTap: _scrollToTop,
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 900) return 3;
    return 2;
  }
}

/// Scroll progress (0.0 → 1.0) against the page's real content height.
double _scrollProgress(ScrollController controller, double screenHeight) {
  final offset = controller.hasClients ? controller.offset : 0.0;
  double maxScroll = screenHeight * 3;
  try {
    final pos = controller.position;
    if (pos.hasContentDimensions && pos.maxScrollExtent > 0) {
      maxScroll = pos.maxScrollExtent;
    }
  } catch (_) {
    // Fallback safely if the scroll position is not attached yet.
  }
  return (offset / maxScroll).clamp(0.0, 1.0);
}

/// Gentle background zoom (1.0 → 1.20) driven directly by scroll.
class _ZoomingBackground extends StatelessWidget {
  final ScrollController controller;

  const _ZoomingBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = _scrollProgress(
          controller,
          MediaQuery.of(context).size.height,
        );
        return ClipRect(
          child: Transform.scale(
            scale: 1.0 + (progress * 0.20),
            alignment: Alignment.topCenter,
            child: const Image(
              image: AssetImage('assets/image/background.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

/// Overlay that darkens gradually as the user scrolls deeper into content.
class _GradientOverlay extends StatelessWidget {
  final ScrollController controller;

  const _GradientOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = _scrollProgress(
          controller,
          MediaQuery.of(context).size.height,
        );
        final topAlpha = (0.35 + progress * 0.30).clamp(0.0, 1.0);
        final bottomAlpha = (0.88 + progress * 0.08).clamp(0.0, 1.0);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background.withValues(alpha: topAlpha),
                AppColors.background.withValues(alpha: 0.55),
                AppColors.background.withValues(alpha: 0.78),
                AppColors.background.withValues(alpha: bottomAlpha),
              ],
              stops: const [0.0, 0.35, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Hero section that fades out and drifts up as the user scrolls past it.
class _ParallaxHero extends StatelessWidget {
  final ScrollController controller;
  final VoidCallback? onBrowseAll;
  final VoidCallback? onContact;

  const _ParallaxHero({
    required this.controller,
    this.onBrowseAll,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // On mobile & tablet screens, render directly without any scroll drift or fade
    // so users can comfortably scroll and read everything with 100% crisp visibility.
    if (!isDesktop) {
      return HeroSection(
        theme: theme,
        onBrowseAll: onBrowseAll,
        onContact: onContact,
      );
    }

    // On desktop, keep a subtle parallax drift but maintain 100% text opacity.
    return AnimatedBuilder(
      animation: controller,
      child: HeroSection(
        theme: theme,
        onBrowseAll: onBrowseAll,
        onContact: onContact,
      ),
      builder: (context, child) {
        final offset = controller.hasClients ? controller.offset : 0.0;
        final height = MediaQuery.of(context).size.height;
        final ratio = (offset / (height * 1.5)).clamp(0.0, 1.0);
        final driftY = ratio * -30;
        return Transform.translate(
          offset: Offset(0, driftY),
          child: child,
        );
      },
    );
  }
}

/// Scroll-to-top FAB that appears once the user scrolls past ~80% of a viewport.
class _ScrollTopFab extends StatelessWidget {
  final ScrollController controller;
  final VoidCallback onTap;

  const _ScrollTopFab({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final threshold = MediaQuery.of(context).size.height * 0.8;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final visible = controller.hasClients && controller.offset > threshold;
        return AnimatedSlide(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            opacity: visible ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !visible,
              child: GestureDetector(
                onTap: onTap,
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
        );
      },
    );
  }
}
