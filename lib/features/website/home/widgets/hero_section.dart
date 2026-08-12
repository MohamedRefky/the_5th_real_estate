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

                  // Main Title — Ultra-Bright Luminous Font Color (Sharp & Pure)
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
                        '✦  وجهتك الحصرية لكل عقارات التجمع الخامس  ✦',
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

                  // Subtitle Description — Calm, Soft, Crystal-Clear & Elegant
                  _HeroEntrance(
                    animation: _steps[4],
                    child: Text(
                      'كل عقارات التجمع الخامس في مكان واحد — اختر من بين مئات الشقق والعمارات والفيلات\nبأسعار محدثة لحظة بلحظة، صور واقعية موثقة، ومعاينة فورية بضغطة واحدة',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w500,
                        height: 1.85,
                        fontSize: 16,
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

                  const SizedBox(height: 34),

                  // Stats Row with Glassmorphism Cards
                  _HeroEntrance(
                    animation: _steps[5],
                    child: Wrap(
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
                          label: 'تغطي أكثر من 12 حيّ',
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
                                icon: const Icon(
                                  Icons.explore_rounded,
                                  size: 22,
                                ),
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
  final IconData? icon;

  const _GlassHeroStat({
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(9),
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
                    size: 18,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
