import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/metallic_gloss.dart';

/// Massive full-width hero section with a one-shot staggered entrance.
class HeroSection extends StatefulWidget {
  final ThemeData theme;
  final VoidCallback? onBrowseAll;
  final VoidCallback? onContact;

  const HeroSection({
    super.key,
    required this.theme,
    this.onBrowseAll,
    this.onContact,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
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
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: isMobile ? 16 : 24,
            right: isMobile ? 16 : 24,
            top: isMobile ? 78 : 88,
            bottom: isMobile ? 32 : 55,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                children: [
                  // Decorative Line
                  _HeroEntrance(
                    animation: _steps[0],
                    child: Container(
                      width: isMobile ? 60 : 90,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 18 : 26),

                  // Brand Chip
                  _HeroEntrance(
                    animation: _steps[1],
                    child: GlassContainer(
                      borderRadius: 30,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 14 : 20,
                        vertical: isMobile ? 6.5 : 9,
                      ),
                      borderColor: AppColors.accent.withValues(alpha: 0.4),
                      borderWidth: 0.5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: AppColors.accent,
                            size: isMobile ? 15 : 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'The 5th Real Estate',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                              fontSize: isMobile ? 12.5 : 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 18 : 26),

                  // Main Title — Ultra-Bright Luminous Font Color (Sharp & Pure)
                  _HeroEntrance(
                    animation: _steps[2],
                    child: Text(
                      'عقارات\nالتجمع الخامس',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: isMobile ? 36 : 58,
                        height: 1.15,
                        color: const Color(0xFFFFF6DF),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.90),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 14 : 18),

                  // Glass Tagline Pill
                  _HeroEntrance(
                    animation: _steps[3],
                    child: GlassContainer(
                      borderRadius: 30,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 14 : 26,
                        vertical: isMobile ? 7 : 10,
                      ),
                      borderColor: AppColors.accent.withValues(alpha: 0.5),
                      borderWidth: 0.5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: isMobile ? 13 : 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'وجهتك الحصرية لكل عقارات التجمع الخامس',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                              fontSize: isMobile ? 12 : 15,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.verified_rounded,
                            size: isMobile ? 13 : 16,
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 16 : 22),

                  // Subtitle Description — Calm, Soft, Crystal-Clear & Elegant
                  _HeroEntrance(
                    animation: _steps[4],
                    child: Text(
                      'كل عقارات التجمع الخامس في مكان واحد — اختر من بين مئات الشقق والعمارات والفيلات بأسعار محدثة لحظة بلحظة، صور واقعية موثقة، ومعاينة فورية بضغطة واحدة',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w500,
                        height: 1.65,
                        fontSize: isMobile ? 13.5 : 16,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.75),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 18 : 28),

                  // Stats — Compact Inline Glass Console
                  _HeroEntrance(
                    animation: _steps[5],
                    child: _HeroStatsConsole(isMobile: isMobile),
                  ),

                  SizedBox(height: isMobile ? 24 : 36),

                  // CTA Buttons
                  _HeroEntrance(
                    animation: _steps[6],
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                blurRadius: isMobile ? 14 : 24,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ElevatedButton.icon(
                                onPressed: widget.onBrowseAll,
                                icon: Icon(
                                  Icons.explore_rounded,
                                  size: isMobile ? 18 : 22,
                                ),
                                label: Text(
                                  'تصفح جميع العقارات',
                                  style: TextStyle(
                                    fontSize: isMobile ? 13 : 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: AppColors.textOnPrimary,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 22 : 34,
                                    vertical: isMobile ? 13 : 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: MetallicGloss(
                                    borderRadius: 16,
                                    strength: 0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: widget.onContact,
                          icon: Icon(
                            Icons.chat_rounded,
                            size: isMobile ? 16 : 20,
                          ),
                          label: Text(
                            'تواصل معنا',
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: BorderSide(
                              color: AppColors.accent.withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 30,
                              vertical: isMobile ? 13 : 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 24 : 36),

                  Container(
                    width: isMobile ? 60 : 90,
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

/// Premium floating glass stats panel for the Hero Section.
/// Desktop: 4 vertical stat columns in a wide floating glass bar.
/// Mobile: 2×2 grid with centered vertical stat cells.
class _HeroStatsConsole extends StatelessWidget {
  final bool isMobile;

  const _HeroStatsConsole({required this.isMobile});

  static const _stats = [
    (icon: Icons.location_city_rounded, value: '+50', label: 'مشروع فاخر'),
    (icon: Icons.map_rounded, value: '12+', label: 'حي راقي'),
    (icon: Icons.verified_user_rounded, value: '100%', label: 'عقود موثقة'),
    (icon: Icons.support_agent_rounded, value: 'متاح', label: 'معاينة فورية'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 36,
            vertical: isMobile ? 16 : 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface.withValues(alpha: 0.7),
                AppColors.surface.withValues(alpha: 0.5),
                AppColors.surface.withValues(alpha: 0.65),
              ],
            ),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.08),
                blurRadius: 40,
                spreadRadius: -4,
              ),
            ],
          ),
          child: isMobile ? _buildMobileGrid() : _buildDesktopRow(),
        ),
      ),
    );
  }

  Widget _buildDesktopRow() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _stats.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.0),
                      AppColors.accent.withValues(alpha: 0.4),
                      AppColors.accent.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            _LuxuryStatColumn(
              icon: _stats[i].icon,
              value: _stats[i].value,
              label: _stats[i].label,
              isMobile: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _LuxuryStatColumn(
                  icon: _stats[0].icon,
                  value: _stats[0].value,
                  label: _stats[0].label,
                  isMobile: true,
                ),
              ),
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.0),
                      AppColors.accent.withValues(alpha: 0.35),
                      AppColors.accent.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _LuxuryStatColumn(
                  icon: _stats[1].icon,
                  value: _stats[1].value,
                  label: _stats[1].label,
                  isMobile: true,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.0),
                  AppColors.accent.withValues(alpha: 0.25),
                  AppColors.accent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _LuxuryStatColumn(
                  icon: _stats[2].icon,
                  value: _stats[2].value,
                  label: _stats[2].label,
                  isMobile: true,
                ),
              ),
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.0),
                      AppColors.accent.withValues(alpha: 0.35),
                      AppColors.accent.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _LuxuryStatColumn(
                  icon: _stats[3].icon,
                  value: _stats[3].value,
                  label: _stats[3].label,
                  isMobile: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A single vertical stat column: icon → number → label.
/// Designed for luxury real estate hero sections.
class _LuxuryStatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isMobile;

  const _LuxuryStatColumn({
    required this.icon,
    required this.value,
    required this.label,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 8,
        vertical: isMobile ? 2 : 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with radial glow
          Container(
            width: isMobile ? 34 : 42,
            height: isMobile ? 34 : 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: isMobile ? 16 : 20,
                color: AppColors.accent,
              ),
            ),
          ),

          SizedBox(height: isMobile ? 6 : 10),

          // Large prominent number with text shadow glow
          Text(
            value,
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
              fontSize: isMobile ? 18 : 24,
              letterSpacing: 0.5,
              height: 1.1,
              shadows: [
                Shadow(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  blurRadius: 12,
                ),
              ],
            ),
          ),

          SizedBox(height: isMobile ? 2 : 4),

          // Subtle label
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 10.5 : 12.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

