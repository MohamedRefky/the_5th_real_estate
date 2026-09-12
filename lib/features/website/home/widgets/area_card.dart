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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.7)
                  : AppColors.divider,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.35 : 0.15),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 6 : 2),
              ),
            ],
          ),
          transform: _isHovered
              ? (Matrix4.identity()..setTranslationRaw(0.0, -4.0, 0.0))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
            child: Stack(
              children: [
                // ── Background Image or Architectural Dark Backdrop ───────
                if (imagePath != null) ...[
                  Positioned.fill(
                    child: AnimatedScale(
                      scale: _isHovered ? 1.05 : 1.0,
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
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.black.withValues(alpha: 0.65),
                            AppColors.background.withValues(alpha: 0.94),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Positioned.fill(
                    child: Container(
                      color: AppColors.surface,
                    ),
                  ),
                ],

                // ── Card Content ──────────────────────────────────────
                Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (imagePath == null) ...[
                        Container(
                          width: isMobile ? 44 : 64,
                          height: isMobile ? 44 : 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.background,
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _areaIcon,
                              size: isMobile ? 22 : 32,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 14),
                      ] else ...[
                        const Spacer(),
                      ],

                      // Area Name
                      Text(
                        widget.areaName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: isMobile ? 14 : 18,
                          color: _isHovered
                              ? AppColors.accent
                              : AppColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: isMobile ? 6 : 8),

                      // Count & Explore Badge Pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 14,
                          vertical: isMobile ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? AppColors.accent
                              : AppColors.background.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: _isHovered
                                ? AppColors.accent
                                : AppColors.divider,
                            width: 1,
                          ),
                        ),
                        child: FutureBuilder<List<Apartment>>(
                          future: _countFuture,
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? localCount;
                            return Text(
                              widget.customBadgeText ?? '$count شقة متاحة',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _isHovered
                                    ? AppColors.textOnPrimary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: isMobile ? 10 : 12,
                              ),
                            );
                          },
                        ),
                      ),

                      if (imagePath != null) SizedBox(height: isMobile ? 4 : 6),
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
