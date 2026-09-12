import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
            left: isMobile ? 20 : 32,
            right: isMobile ? 20 : 32,
            top: isMobile ? 64 : 84,
            bottom: isMobile ? 32 : 52,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                children: [
                  // Architectural Location Tag
                  _HeroEntrance(
                    animation: _steps[0],
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: isMobile ? 5 : 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.divider,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'التجمع الخامس • القاهرة الجديدة',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: isMobile ? 11.5 : 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 18 : 26),

                  // Grand Architectural Title
                  _HeroEntrance(
                    animation: _steps[1],
                    child: Text(
                      'عقارات التجمع الخامس\nبأعلى معايير الدقة والتميز',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: isMobile ? 32 : 56,
                        height: 1.18,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 16 : 22),

                  // Subtitle (Clear, Active, Authoritative)
                  _HeroEntrance(
                    animation: _steps[2],
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Text(
                        'منصة عقارية متخصصة تمنحك الوصول المباشر لأرقى الشقق والعمارات في التجمع الخامس، بأسعار واقعية محدثة وبيانات موثقة ميدانياً.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                          height: 1.65,
                          fontSize: isMobile ? 13.5 : 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 26 : 38),

                  // CTA Buttons (Tactile & Clean)
                  _HeroEntrance(
                    animation: _steps[3],
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: widget.onBrowseAll,
                          icon: Icon(
                            Icons.explore_rounded,
                            size: isMobile ? 18 : 20,
                          ),
                          label: Text(
                            'تصفح جميع العقارات',
                            style: TextStyle(
                              fontSize: isMobile ? 13.5 : 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 24 : 32,
                              vertical: isMobile ? 14 : 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: widget.onContact,
                          icon: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: isMobile ? 16 : 18,
                          ),
                          label: Text(
                            'تواصل معنا',
                            style: TextStyle(
                              fontSize: isMobile ? 13.5 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(
                              color: AppColors.divider,
                              width: 1,
                            ),
                            backgroundColor: AppColors.surface.withValues(alpha: 0.5),
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 22 : 28,
                              vertical: isMobile ? 14 : 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 28 : 42),

                  // Stats Strip (Architectural & Editorial)
                  _HeroEntrance(
                    animation: _steps[4],
                    child: _HeroStatsConsole(isMobile: isMobile),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _stats.length; i++) ...[
            if (i > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 38,
                width: 1,
                color: AppColors.divider,
              ),
            _StatChip(
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

  Widget _buildMobile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _stats.length; i++) ...[
            if (i > 0)
              Container(
                height: 28,
                width: 1,
                color: AppColors.divider,
              ),
            Expanded(
              child: _StatChip(
                icon: _stats[i].icon,
                value: _stats[i].value,
                label: _stats[i].label,
                isMobile: true,
              ),
            ),
          ],
        ],
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
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 12, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isMobile ? 14 : 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 15 : 18,
                  letterSpacing: 0.3,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: isMobile ? 10 : 12,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

