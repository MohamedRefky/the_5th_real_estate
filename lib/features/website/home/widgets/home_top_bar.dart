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

  static IconData _iconForSection(String label) {
    switch (label) {
      case 'لماذا نحن':
        return Icons.verified_rounded;
      case 'المميزة':
        return Icons.auto_awesome_rounded;
      case 'شقق':
        return Icons.apartment_rounded;
      case 'عمارات':
        return Icons.location_city_rounded;
      case 'أحدث العقارات':
        return Icons.access_time_filled_rounded;
      case 'خطوات الشراء':
        return Icons.rocket_launch_rounded;
      case 'آراء العملاء':
        return Icons.star_rate_rounded;
      case 'تواصل معنا':
        return Icons.headset_mic_rounded;
      default:
        return Icons.navigate_next_rounded;
    }
  }

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
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
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.75),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 0.8,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
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
                      borderRadius: BorderRadius.circular(12),
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
                                    color: AppColors.accent.withValues(alpha: 0.35),
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
                              'The 5th',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.accentLight2,
                                fontWeight: FontWeight.w800,
                                fontSize: 15.5,
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
                      // ── Mobile / Tablet Hamburger Button ─────────────────
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _toggleMenu,
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isMenuOpen
                                  ? AppColors.accent.withValues(alpha: 0.2)
                                  : AppColors.surface.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isMenuOpen
                                    ? AppColors.accent
                                    : AppColors.accent.withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              _isMenuOpen ? Icons.close_rounded : Icons.menu_rounded,
                              color: AppColors.accentLight2,
                              size: 22,
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

          // ── Mobile Compact Dropdown Menu ────────────────────────────
          if (!isDesktop && _isMenuOpen) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.35),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      itemCount: widget.labels.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final label = widget.labels[index];
                        final isActive = label == widget.activeSection;
                        final icon = HomeTopBar._iconForSection(label);

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
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.accent.withValues(alpha: 0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isActive
                                      ? AppColors.accent.withValues(alpha: 0.5)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppColors.accent.withValues(alpha: 0.25)
                                          : Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        icon,
                                        color: isActive
                                            ? AppColors.accentLight2
                                            : AppColors.textSecondary,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      label,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: isActive
                                            ? AppColors.accentLight2
                                            : AppColors.textPrimary,
                                        fontWeight: isActive
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: AppColors.accentLight2,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.textSecondary,
                                      size: 12,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
