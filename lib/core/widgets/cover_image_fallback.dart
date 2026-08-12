import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Fallback cover content for cards: the bundled area asset when available,
/// otherwise a premium gradient with an apartment silhouette icon.
class CoverImageFallback extends StatelessWidget {
  /// Bundled area asset path (from [AppConstants.areaImageAssetFor]).
  final String? assetPath;

  /// Opacity of the silhouette icon on the gradient fallback.
  final double iconAlpha;

  const CoverImageFallback({
    super.key,
    this.assetPath,
    this.iconAlpha = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(assetPath!, fit: BoxFit.cover);
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.15),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.accent.withValues(alpha: 0.08),
                Colors.black.withValues(alpha: 0.25),
                AppColors.primaryDark.withValues(alpha: 0.35),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.apartment_rounded,
              size: 54,
              color: AppColors.accent.withValues(alpha: 0.20),
            ),
          ),
        ),
      ),
    );
  }
}
