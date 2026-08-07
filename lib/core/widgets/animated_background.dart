import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'ambient_particles.dart';

/// Premium ambient animated background for the navy + gold theme.
///
/// A soft radial glow backdrops the content while golden light particles drift
/// gently upward with a faint light band sweeping across — subtle and luxurious.
///
/// Safe against unconstrained height layouts (e.g. inside SingleChildScrollView).
class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final Color shapeColor;
  final int shapeCount;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.shapeColor = AppColors.accent,
    this.shapeCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isHeightInfinite = constraints.maxHeight.isInfinite;

        return Stack(
          fit: isHeightInfinite ? StackFit.loose : StackFit.expand,
          children: [
            // ── Ambient Radial Glow Backdrop ────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -0.7),
                      radius: 1.1,
                      colors: [
                        shapeColor.withValues(alpha: 0.10),
                        AppColors.primary.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── Ambient Gold Particles + Light Sweep ────────
            Positioned.fill(
              child: IgnorePointer(
                child: AmbientParticles(
                  color: shapeColor,
                  particleCount: shapeCount + 8,
                ),
              ),
            ),

            // ── Foreground Content ─────────────────────────
            child,
          ],
        );
      },
    );
  }
}
