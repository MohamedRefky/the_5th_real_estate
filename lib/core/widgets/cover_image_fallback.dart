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

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.apartment_rounded,
          size: 64,
          color: AppColors.textPrimary.withValues(alpha: iconAlpha),
        ),
      ),
    );
  }
}
