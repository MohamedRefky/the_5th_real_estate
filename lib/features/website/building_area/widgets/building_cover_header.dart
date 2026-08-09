import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cover_image_fallback.dart';
import '../../../../core/widgets/price_tag_pill.dart';
import '../../../../core/widgets/status_badge.dart';
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
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          if (coverUrl != null && coverUrl.isNotEmpty) ...[
            Positioned.fill(
              child: _HoverImage(
                isHovered: isHovered,
                child: Image.network(
                  coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      CoverImageFallback(
                    assetPath: areaImage,
                    iconAlpha: 0.15,
                  ),
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

          // Construction / delivery status badge (top right)
          Positioned(
            top: 12,
            right: 12,
            child: StatusBadge(
              label: building.isUnderConstruction
                  ? 'تحت الإنشاء'
                  : 'جاهز للتسليم',
              color: building.isUnderConstruction
                  ? AppColors.warning
                  : AppColors.success,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              fontSize: 11.5,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              shadowBlur: 6,
            ),
          ),

          // Price tag floating on image (bottom right)
          Positioned(
            bottom: 12,
            right: 12,
            child: PriceTagPill(
              price: building.formattedStartingPrice,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverImage extends StatelessWidget {
  final bool isHovered;
  final Widget child;

  const _HoverImage({
    required this.isHovered,
    required this.child,
  });

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
