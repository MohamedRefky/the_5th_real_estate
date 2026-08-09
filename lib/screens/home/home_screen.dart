import 'package:flutter/material.dart';

import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/metallic_gloss.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../data/dummy_data.dart';
import 'widgets/area_card.dart';
import 'widgets/contact_section.dart';
import 'widgets/featured_properties_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/home_footer.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/recent_properties_section.dart';
import 'widgets/section_bar.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_us_section.dart';

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
  double _scrollOffset = 0;
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
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
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
    if (active != _activeSection || offset != _scrollOffset) {
      setState(() {
        _scrollOffset = offset;
        _activeSection = active;
      });
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
    final double scrollProgress = (_scrollOffset / maxScroll).clamp(0.0, 1.0);

    // Background: gentle zoom as you scroll (1.0 → 1.20)
    final double imageScale = 1.0 + (scrollProgress * 0.20);

    // Hero content: fades out and drifts up as user scrolls past it
    final double heroScrollRatio = (_scrollOffset / (size.height * 0.65)).clamp(
      0.0,
      1.0,
    );
    final double heroOpacity = (1.0 - heroScrollRatio).clamp(0.0, 1.0);
    final double heroDriftY = heroScrollRatio * -60;

    // Overlay: darkens gradually as you scroll deeper into content
    final double overlayTopAlpha = (0.35 + scrollProgress * 0.30).clamp(
      0.0,
      1.0,
    );
    final double overlayBottomAlpha = (0.88 + scrollProgress * 0.08).clamp(
      0.0,
      1.0,
    );

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
                      AppColors.background.withValues(alpha: overlayTopAlpha),
                      AppColors.background.withValues(alpha: 0.55),
                      AppColors.background.withValues(alpha: 0.78),
                      AppColors.background.withValues(
                        alpha: overlayBottomAlpha,
                      ),
                    ],
                    stops: const [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Main Scrollable Content ──────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // ── Hero Section with Parallax Fade-Out ────────────────
                Transform.translate(
                  offset: Offset(0, heroDriftY),
                  child: Opacity(
                    opacity: heroOpacity,
                    child: HeroSection(
                      theme: theme,
                      onBrowseAll: () => _scrollTo(_browseKey),
                      onContact: () => _scrollTo(_contactKey),
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                // ── Why Choose Us ─────────────────────────────────────
                SizedBox(key: _whyKey, child: const WhyUsSection()),

                const SizedBox(height: 64),

                // ── Featured Properties ───────────────────────────────
                SizedBox(
                  key: _browseKey,
                  child: const FeaturedPropertiesSection(),
                ),

                const SizedBox(height: 64),

                // ── Apartments Neighborhood Grid Header (3D Scale Reveal) ─
                const RevealOnScroll(
                  direction: RevealDirection.scale,
                  child: SectionBar(
                    index: 4,
                    icon: Icons.location_city_rounded,
                    title: 'شقق',
                    subtitle: 'تصفح الشقق المتاحة في أرقى أحياء التجمع الخامس',
                  ),
                ),

                const SizedBox(height: 36),

                // ── Apartments Neighborhood Grid ──────────────────────
                Padding(
                  key: _neighborhoodKey,
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

                // ── Buildings Neighborhood Grid Header ────────────────
                const RevealOnScroll(
                  direction: RevealDirection.scale,
                  child: SectionBar(
                    index: 5,
                    icon: Icons.apartment_rounded,
                    title: 'عمارات',
                    subtitle:
                        'استكشف المشروعات والعمارات السكنية في الـ 5 أحياء',
                  ),
                ),

                const SizedBox(height: 36),

                // ── Buildings Neighborhood Grid ───────────────────────
                Padding(
                  key: _buildingsKey,
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
                              final bldCount = DummyData.getBuildingsByArea(
                                area,
                              ).length;
                              return RevealOnScroll(
                                direction: RevealDirection.elasticPop,
                                delayMilliseconds: index * 80,
                                child: AreaCard(
                                  areaName: area,
                                  customBadgeText: '$bldCount عمارة متاحة',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesNames.buildingsArea,
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
                SizedBox(
                  key: _recentKey,
                  child: const RecentPropertiesSection(),
                ),

                const SizedBox(height: 64),

                // ── How It Works ──────────────────────────────────────
                SizedBox(key: _howKey, child: const HowItWorksSection()),

                const SizedBox(height: 64),

                // ── Testimonials ──────────────────────────────────────
                SizedBox(
                  key: _testimonialsKey,
                  child: const TestimonialsSection(),
                ),

                const SizedBox(height: 64),

                // ── Contact Us ────────────────────────────────────────
                SizedBox(key: _contactKey, child: const ContactSection()),

                const SizedBox(height: 64),

                // ── Footer (From Bottom) ──────────────────────────────
                const RevealOnScroll(
                  direction: RevealDirection.fromBottom,
                  child: HomeFooter(),
                ),
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
