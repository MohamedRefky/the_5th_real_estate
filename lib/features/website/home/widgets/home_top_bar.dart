import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Floating glass top navigation bar for the home screen.
///
/// Automatically adapts between:
/// - Desktop: Full horizontal row of section pills.
/// - Mobile / Tablet: Brand + sleek 3-line hamburger menu that expands a compact dropdown list.
class HomeTopBar extends StatelessWidget {
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
                      onTap: onHomeTap,
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
                            for (final label in labels)
                              _NavPill(
                                label: label,
                                active: label == activeSection,
                                onTap: () => onSelect(label),
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
                          onTap: () => _openMobileMenuModal(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.35),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'الأقسام',
                                  style: TextStyle(
                                    color: AppColors.accentLight2,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.menu_rounded,
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
        ],
      ),
    );
  }

  void _openMobileMenuModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'إغلاق القائمة',
      barrierColor: Colors.black.withValues(alpha: 0.60),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, anim1, anim2) {
        return Stack(
          children: [
            // ── Full-screen background blur ──
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: const SizedBox.expand(),
              ),
            ),

            // ── Modal Glass Content ──
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  child: Material(
                    color: Colors.transparent,
                    child: _MobileMenuCard(
                      labels: labels,
                      activeSection: activeSection,
                      onSelect: (label) {
                        Navigator.pop(dialogContext);
                        onSelect(label);
                      },
                      onClose: () => Navigator.pop(dialogContext),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// Floating glass modal card containing all sections with rich meta info.
class _MobileMenuCard extends StatelessWidget {
  final List<String> labels;
  final String? activeSection;
  final ValueChanged<String> onSelect;
  final VoidCallback onClose;

  const _MobileMenuCard({
    required this.labels,
    required this.activeSection,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.40),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.70),
                blurRadius: 36,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.12),
                blurRadius: 24,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title & Close button
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 4, left: 4, right: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.explore_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تصفح أقسام الموقع',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.accentLight2,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onClose,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Section Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: labels.length,
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final label = labels[index];
                  final isActive = label == activeSection;
                  final meta = HomeTopBar._sectionMeta(label);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelect(label),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.accent.withValues(alpha: 0.20)
                              : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isActive
                                ? AppColors.accent.withValues(alpha: 0.60)
                                : Colors.white.withValues(alpha: 0.08),
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
                                    ? AppColors.accent.withValues(alpha: 0.25)
                                    : AppColors.accent.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.35),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    label,
                                    style: theme.textTheme.titleSmall?.copyWith(
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
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
                                  color: AppColors.accent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
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
