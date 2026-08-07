import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_data.dart';

/// A premium card representing a neighborhood on the Home Screen.
///
/// Features:
/// - Styled icon placeholder (no images required)
/// - Area name + apartment count badge
/// - Hover elevation animation (web-friendly)
/// - Gold accent border on hover
class AreaCard extends StatefulWidget {
  final String areaName;
  final VoidCallback onTap;

  const AreaCard({
    super.key,
    required this.areaName,
    required this.onTap,
  });

  @override
  State<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<AreaCard> {
  bool _isHovered = false;

  /// Maps each area to a distinct icon for visual variety.
  IconData get _areaIcon {
    switch (widget.areaName) {
      case 'المستثمرين':
        return Icons.business_rounded;
      case 'الأندلس':
        return Icons.villa_rounded;
      case 'جاردينيا':
        return Icons.park_rounded;
      case 'بيت الوطن':
        return Icons.home_work_rounded;
      case 'النرجس':
        return Icons.local_florist_rounded;
      default:
        return Icons.apartment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = DummyData.getByArea(widget.areaName).length;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? AppColors.accent : AppColors.divider,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.06),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          transform: _isHovered
              ? (Matrix4.identity()..setTranslationRaw(0.0, -4.0, 0.0))
              : Matrix4.identity(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon Placeholder ──────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: _isHovered
                          ? [
                              AppColors.accent,
                              AppColors.accent.withValues(alpha: 0.8),
                            ]
                          : [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _areaIcon,
                    size: 40,
                    color: AppColors.textOnPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Area Name ─────────────────────────────────────
                Text(
                  widget.areaName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // ── Apartment Count Badge ─────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count شقة متاحة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
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
