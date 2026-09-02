
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/cover_image_fallback.dart';
import '../../../../core/widgets/price_tag_pill.dart';
import '../../../../models/building.dart';

/// Building card cover: hover-zooming photo (network or local fallback),
/// dark gradient overlay, construction/delivery status badge and price tag.
class BuildingCoverHeader extends StatelessWidget {
  final Building building;
  final String? areaImage;
  final bool isHovered;

  const BuildingCoverHeader({
    super.key,
    required this.building,
    required this.areaImage,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final coverUrl = building.coverImageUrl;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return AspectRatio(
      aspectRatio: 16 / 10.5,
      child: Stack(
        children: [
          if (coverUrl != null && coverUrl.isNotEmpty) ...[
            Positioned.fill(
              child: _HoverImage(
                isHovered: isHovered,
                child: Image.network(
                  sanitizeImageUrl(coverUrl),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) =>
                      CoverImageFallback(assetPath: areaImage, iconAlpha: 0.15),
                ),
              ),
            ),
          ] else ...[
            Positioned.fill(
              child: _HoverImage(
                isHovered: isHovered,
                child: CoverImageFallback(
                  assetPath: areaImage,
                  iconAlpha: 0.15,
                ),
              ),
            ),
          ],

          // Dark gradient overlay for title readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),

          // Property Category Badge ("عمارة") on Top-Left
          Positioned(
            top: 12,
            left: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.60),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.domain_rounded,
                        size: 13,
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'عمارة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Price tag floating on image (bottom right)
          if (building.startingPrice > 0)
            Positioned(
              bottom: 12,
              right: 12,
              child: PriceTagPill(price: building.formattedStartingPrice),
            ),
        ],
      ),
    );
  }
}

class _HoverImage extends StatelessWidget {
  final bool isHovered;
  final Widget child;

  const _HoverImage({required this.isHovered, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isHovered ? 1.06 : 1.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}
