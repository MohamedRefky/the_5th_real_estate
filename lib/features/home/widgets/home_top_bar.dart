import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Floating glass top navigation bar for the home screen.
///
/// Shows the brand on the leading edge and a horizontally scrollable row of
/// section links. The pill matching [activeSection] is highlighted.
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.35),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 0.6,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Brand — tap to scroll to top
                InkWell(
                  onTap: onHomeTap,
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
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Section links — horizontally scrollable
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
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
                ),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 3),
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
