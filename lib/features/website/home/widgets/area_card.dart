import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/dummy_data.dart';
import '../../../../data/public_property_repository.dart';
import '../../../../models/apartment.dart';

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

  Future<List<Apartment>>? _countFuture;

  String? get _areaImage => AppConstants.areaImageAssetFor(widget.areaName);

  IconData get _areaIcon => AppConstants.areaIconFor(widget.areaName);

  @override
  void initState() {
    super.initState();
    _countFuture = PublicPropertyRepository.instance.byArea(widget.areaName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localCount = DummyData.getByArea(widget.areaName).length;
    final imagePath = _areaImage;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

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
            color: imagePath == null
                ? AppColors.surface.withValues(alpha: _isHovered ? 0.35 : 0.18)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent
                  : (imagePath == null
                        ? AppColors.accent.withValues(alpha: 0.25)
                        : AppColors.divider.withValues(alpha: 0.6)),
              width: _isHovered ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.32)
                    : Colors.black.withValues(alpha: 0.20),
                blurRadius: _isHovered ? 30 : 14,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          transform: _isHovered
              ? (Matrix4.identity()..setTranslationRaw(0.0, -6.0, 0.0))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
            child: Stack(
              children: [
                // ── Background Image or Radial Gold Spotlight Backdrop ────
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
                            Colors.black.withValues(
                              alpha: _isHovered ? 0.25 : 0.40,
                            ),
                            Colors.black.withValues(
                              alpha: _isHovered ? 0.65 : 0.78,
                            ),
                            AppColors.background.withValues(alpha: 0.92),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Luxury Radial Gold Spotlight Backdrop
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.6),
                          radius: 1.15,
                          colors: [
                            AppColors.accent.withValues(
                              alpha: _isHovered ? 0.22 : 0.08,
                            ),
                            AppColors.primaryMedium.withValues(
                              alpha: _isHovered ? 0.45 : 0.25,
                            ),
                            AppColors.background.withValues(alpha: 0.88),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Top-Right Luxury Glass Badge
                  Positioned(
                    top: isMobile ? 8 : 14,
                    right: isMobile ? 8 : 14,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 7 : 10,
                        vertical: isMobile ? 3 : 4.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.70),
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: isMobile ? 10 : 12,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'حي متميز',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.accent,
                              fontSize: isMobile ? 9 : 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // ── Card Content ──────────────────────────────────────
                Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (imagePath == null) ...[
                        // Floating 3D Circular Glass Emblem Icon Box
                        AnimatedScale(
                          scale: _isHovered ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          child: Container(
                            width: isMobile ? 48 : 86,
                            height: isMobile ? 48 : 86,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _isHovered
                                    ? [
                                        AppColors.accentHighlight,
                                        AppColors.accent,
                                      ]
                                    : [
                                        AppColors.surface.withValues(
                                          alpha: 0.9,
                                        ),
                                        AppColors.primaryMedium.withValues(
                                          alpha: 0.95,
                                        ),
                                      ],
                              ),
                              border: Border.all(
                                color: AppColors.accent.withValues(
                                  alpha: _isHovered ? 0.9 : 0.4,
                                ),
                                width: isMobile ? 1.2 : 1.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _isHovered
                                      ? AppColors.accent.withValues(alpha: 0.45)
                                      : AppColors.accent.withValues(
                                          alpha: 0.12,
                                        ),
                                  blurRadius: _isHovered ? 22 : 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _areaIcon,
                                size: isMobile ? 24 : 42,
                                color: _isHovered
                                    ? AppColors.textOnPrimary
                                    : AppColors.accent,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 18),
                      ] else ...[
                        const Spacer(),
                      ],

                      // Area Name
                      Text(
                        widget.areaName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: isMobile ? 14.5 : 20,
                          color: _isHovered
                              ? AppColors.accent
                              : AppColors.textPrimary,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: isMobile ? 5 : 10),

                      // Count & Explore Badge Pill
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 16,
                          vertical: isMobile ? 4 : 7.5,
                        ),
                        decoration: BoxDecoration(
                          gradient: _isHovered
                              ? AppColors.accentGradient
                              : LinearGradient(
                                  colors: [
                                    AppColors.surface.withValues(alpha: 0.8),
                                    AppColors.primaryMedium.withValues(
                                      alpha: 0.8,
                                    ),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(isMobile ? 14 : 20),
                          border: Border.all(
                            color: AppColors.accent.withValues(
                              alpha: _isHovered ? 0.8 : 0.35,
                            ),
                            width: 1,
                          ),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: FutureBuilder<List<Apartment>>(
                          future: _countFuture,
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? localCount;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.explore_rounded,
                                  size: isMobile ? 11 : 14,
                                  color: _isHovered
                                      ? AppColors.textOnPrimary
                                      : AppColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.customBadgeText ?? '$count شقة متاحة',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: _isHovered
                                        ? AppColors.textOnPrimary
                                        : AppColors.accent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: isMobile ? 10 : 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      if (imagePath != null) SizedBox(height: isMobile ? 4 : 8),
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
