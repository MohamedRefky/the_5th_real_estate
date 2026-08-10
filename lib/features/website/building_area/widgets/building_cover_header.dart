import 'dart:ui';
import 'package:flutter/material.dart';
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

    return SizedBox(
      height: 235,
      width: double.infinity,
      child: Stack(
        children: [
          if (coverUrl != null && coverUrl.isNotEmpty) ...[
            // Blurred background image
            Positioned.fill(
              child: Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    CoverImageFallback(assetPath: areaImage, iconAlpha: 0.15),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.black.withValues(alpha: 0.35)),
              ),
            ),
            // Uncropped contained main image
            Positioned.fill(
              child: _HoverImage(
                isHovered: isHovered,
                child: Image.network(
                  coverUrl,
                  fit: BoxFit.contain,
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
