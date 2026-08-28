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

/// Clean, minimal-luxury stats strip for the Hero Section.
class _HeroStatsConsole extends StatelessWidget {
  final bool isMobile;

  const _HeroStatsConsole({required this.isMobile});

  static const _stats = [
    (icon: Icons.domain_rounded, value: '+50', label: 'مشروع فاخر'),
    (icon: Icons.location_on_rounded, value: '12+', label: 'حي راقي'),
    (icon: Icons.verified_rounded, value: '100%', label: 'عقود موثقة'),
    (icon: Icons.headset_mic_rounded, value: 'متاح', label: 'دعم مستمر'),
  ];

  @override
  Widget build(BuildContext context) {
    if (isMobile) return _buildMobile();
    return _buildDesktop();
  }

  Widget _buildDesktop() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.30),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _stats
                .map((s) => _StatChip(
                      icon: s.icon,
                      value: s.value,
                      label: s.label,
                      isMobile: false,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _stats
                .map((s) => Expanded(
                      child: _StatChip(
                        icon: s.icon,
                        value: s.value,
                        label: s.label,
                        isMobile: true,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// A single minimal stat chip: small gold icon — bold number — grey label stacked vertically.
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isMobile;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 18, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isMobile ? 17 : 20,
            color: AppColors.accent,
          ),
          SizedBox(height: isMobile ? 4 : 6),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 16 : 20,
              letterSpacing: 0.3,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.60),
              fontWeight: FontWeight.w500,
              fontSize: isMobile ? 10 : 11.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

