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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 36 : 80,
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

                  SizedBox(height: isMobile ? 22 : 34),

                  // Stats Row with Glassmorphism Cards (2x2 on Mobile)
                  _HeroEntrance(
                    animation: _steps[5],
                    child: isMobile
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: const [
                                    _GlassHeroStat(
                                      value: '+50',
                                      label: 'مشاريع فاخرة',
                                      icon: Icons.location_city_rounded,
                                    ),
                                    SizedBox(height: 10),
                                    _GlassHeroStat(
                                      value: 'أحياء راقية',
                                      label: 'أكثر من 12 حى',
                                      icon: Icons.map_rounded,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: const [
                                    _GlassHeroStat(
                                      value: 'ثقة وأمان',
                                      label: 'خدمات واستشارات',
                                      icon: Icons.verified_user_rounded,
                                    ),
                                    SizedBox(height: 10),
                                    _GlassHeroStat(
                                      value: '100%',
                                      label: 'عقود موثقة',
                                      icon: Icons.assignment_turned_in_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: const [
                              _GlassHeroStat(
                                value: '+50',
                                label: 'مشاريع فاخرة',
                                icon: Icons.location_city_rounded,
                              ),
                              _GlassHeroStat(
                                value: 'أحياء راقية',
                                label: 'تغطي أكثر من 12 حى',
                                icon: Icons.map_rounded,
                              ),
                              _GlassHeroStat(
                                value: 'ثقة وأمان',
                                label: 'خدمات واستشارات',
                                icon: Icons.verified_user_rounded,
                              ),
                              _GlassHeroStat(
                                value: '100%',
                                label: 'تعاقدات رسمية موثقة',
                                icon: Icons.assignment_turned_in_rounded,
                              ),
                            ],
                          ),
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

class _GlassHeroStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const _GlassHeroStat({required this.value, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(isMobile ? 14 : 20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 22,
            vertical: isMobile ? 10 : 15,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(isMobile ? 14 : 20),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.35),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: isMobile ? 10 : 16,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.12),
                blurRadius: isMobile ? 8 : 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(isMobile ? 7 : 9),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: isMobile ? 14 : 18,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 12),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: isMobile ? 14 : 18,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: isMobile ? 10.5 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
