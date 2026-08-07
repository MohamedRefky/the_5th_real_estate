import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Clean ambient light glow background (no wireframes or distracting floating shapes).
///
/// Provides a subtle, warm ambient light aura behind hero content.
class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final Color shapeColor;
  final int shapeCount;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.shapeColor = Colors.white,
    this.shapeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient Radial Glow Backdrop
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.6),
                radius: 1.2,
                colors: [
                  AppColors.accent.withValues(alpha: 0.12),
                  AppColors.primary.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
