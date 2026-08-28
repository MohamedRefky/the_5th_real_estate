import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Floating glass top navigation bar for the home screen.
///
/// Automatically adapts between:
/// - Desktop: Full horizontal row of section pills.
/// - Mobile / Tablet: Brand + sleek 3-line hamburger menu that expands a compact dropdown list.
class HomeTopBar extends StatefulWidget {
  final String? activeSection;
  final List<String> labels;
  final ValueChanged<String> onSelect;
  final VoidCallback onHomeTap;

  const HomeTopBar({
    super.key,
    required this.activeSection,
    required this.labels,
    required this.onSelect,
    required this.onHomeTap,
  });

  static ({IconData icon, String subtitle}) _sectionMeta(String label) {
    switch (label) {
      case 'لماذا نحن':
        return (
          icon: Icons.verified_rounded,
          subtitle: 'المصداقية وسابقة الأعمال',
        );
      case 'المميزة':
        return (
          icon: Icons.auto_awesome_rounded,
          subtitle: 'أرقى الفرص العقارية الحصرية',
        );
      case 'شقق':
        return (
          icon: Icons.apartment_rounded,
          subtitle: 'شقق سكنية في أرقى الأحياء',
        );
      case 'عمارات':
        return (
          icon: Icons.location_city_rounded,
          subtitle: 'مشروعات وعمارات متكاملة',
        );
      case 'أحدث العقارات':
        return (
          icon: Icons.access_time_filled_rounded,
          subtitle: 'عقارات مضافة حديثاً',
        );
      case 'آراء العملاء':
        return (
          icon: Icons.star_rate_rounded,
          subtitle: 'تجارب وثقة عملائنا',
        );
      case 'تواصل معنا':
        return (
          icon: Icons.headset_mic_rounded,
          subtitle: 'فريق المبيعات والمعاينة الفورية',
        );
      default:
        return (
          icon: Icons.navigate_next_rounded,
          subtitle: 'استكشف القسم',
        );
    }
  }

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _expandAnimation;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
        _animController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 860;

    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Main Glass Bar ──────────────────────────────────────────
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.80),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.accent.withValues(alpha: 0.20),
                      width: 0.8,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // ── Brand Logo ────────────────────────────────────────
                    InkWell(
                      onTap: () {
                        _closeMenu();
                        widget.onHomeTap();
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.domain_rounded,
                                color: AppColors.textOnPrimary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'The 5th Real Estate',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.accentLight2,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ── Desktop Navigation Links ──────────────────────────
                    if (isDesktop) ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (final label in widget.labels)
                              _NavPill(
                                label: label,
                                active: label == widget.activeSection,
                                onTap: () => widget.onSelect(label),
                              ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // ── Mobile Hamburger Button ─────────────────
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _toggleMenu,
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: _isMenuOpen
                                  ? AppColors.accent.withValues(alpha: 0.22)
                                  : AppColors.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isMenuOpen
                                    ? AppColors.accent
                                    : AppColors.accent.withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isMenuOpen ? 'إغلاق' : 'الأقسام',
                                  style: TextStyle(
                                    color: AppColors.accentLight2,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  _isMenuOpen
                                      ? Icons.close_rounded
                                      : Icons.menu_rounded,
                                  color: AppColors.accentLight2,
                                  size: 19,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // ── Mobile Luxury Glass Sheet Navigation ────────────────────
          if (!isDesktop)
            SizeTransition(
              sizeFactor: _expandAnimation,
              axisAlignment: -1.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.65),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header label
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.explore_rounded,
                                  size: 16,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'تصفح أقسام الموقع',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Section Cards List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.labels.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final label = widget.labels[index];
                              final isActive = label == widget.activeSection;
                              final meta = HomeTopBar._sectionMeta(label);

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _closeMenu();
                                    widget.onSelect(label);
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppColors.accent
                                              .withValues(alpha: 0.18)
                                          : Colors.white
                                              .withValues(alpha: 0.04),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isActive
                                            ? AppColors.accent
                                                .withValues(alpha: 0.55)
                                            : Colors.white
                                                .withValues(alpha: 0.08),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? AppColors.accent
                                                    .withValues(alpha: 0.25)
                                                : AppColors.accent
                                                    .withValues(alpha: 0.10),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.3),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              meta.icon,
                                              color: AppColors.accent,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                label,
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: isActive
                                                      ? AppColors.accentLight2
                                                      : AppColors.textPrimary,
                                                  fontWeight: isActive
                                                      ? FontWeight.w900
                                                      : FontWeight.w700,
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                              Text(
                                                meta.subtitle,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 10.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isActive)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'الحالي',
                                              style: TextStyle(
                                                color: AppColors.accent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          )
                                        else
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.textSecondary,
                                            size: 13,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
}

class _NavPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent.withValues(alpha: 0.22)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: active
                    ? AppColors.accent.withValues(alpha: 0.55)
                    : Colors.transparent,
                width: 0.8,
              ),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: active
                        ? AppColors.accentLight2
                        : Colors.white.withValues(alpha: 0.85),
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13.5,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
