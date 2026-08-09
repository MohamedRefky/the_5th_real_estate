import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_data.dart';
import '../../../data/public_property_repository.dart';
import '../../../models/apartment.dart';

/// A ultra-premium card representing a neighborhood on the Home Screen.
class AreaCard extends StatefulWidget {
  final String areaName;
  final String? customBadgeText;
  final VoidCallback onTap;

  const AreaCard({
    super.key,
    required this.areaName,
    this.customBadgeText,
    required this.onTap,
  });

  @override
  State<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<AreaCard> {
  bool _isHovered = false;

  String? get _areaImage {
    switch (widget.areaName) {
      case 'بيت الوطن':
        return 'assets/image/bait_elwatan.webp';
      case 'جاردينيا':
        return 'assets/image/gardenia.webp';
      default:
        return null;
    }
  }

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
      case 'النرجس الجديدة':
        return Icons.local_florist_rounded;
      default:
        return Icons.apartment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localCount = DummyData.getByArea(widget.areaName).length;
    final imagePath = _areaImage;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent
                  : AppColors.divider.withValues(alpha: 0.6),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.3)
                    : AppColors.primary.withValues(alpha: 0.08),
                blurRadius: _isHovered ? 28 : 12,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          transform: _isHovered
              ? (Matrix4.identity()..setTranslationRaw(0.0, -6.0, 0.0))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // ── Background Image or Fallback ───────────────────────
                if (imagePath != null) ...[
                  Positioned.fill(
                    child: AnimatedScale(
                      scale: _isHovered ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.expand(),
                      ),
                    ),
                  ),
                  // Dark Gradient Overlay for readability
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: _isHovered ? 0.25 : 0.40),
                            Colors.black.withValues(alpha: _isHovered ? 0.65 : 0.78),
                            AppColors.background.withValues(alpha: 0.92),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],

                // ── Card Content ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (imagePath == null) ...[
                        // Icon Box for areas without custom images
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            gradient: _isHovered
                                ? AppColors.accentGradient
                                : LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryDark,
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: _isHovered
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _areaIcon,
                            size: 42,
                            color: _isHovered
                                ? AppColors.textOnPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        const Spacer(),
                      ],

                      // Area Name
                      Text(
                        widget.areaName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: _isHovered ? AppColors.accent : AppColors.textPrimary,
                          shadows: imagePath != null
                              ? [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.8),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      // Count Badge
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? AppColors.accent
                              : (imagePath != null
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : AppColors.accentLight),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isHovered
                                ? AppColors.accent
                                : AppColors.accent.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: FutureBuilder<List<Apartment>>(
                          future: PublicPropertyRepository.instance
                              .byArea(widget.areaName),
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? localCount;
                            return Text(
                              widget.customBadgeText ?? '$count شقة متاحة',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _isHovered
                                    ? AppColors.textOnPrimary
                                    : AppColors.accent,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          },
                        ),
                      ),

                      if (imagePath != null) const SizedBox(height: 8),
                    ],
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
