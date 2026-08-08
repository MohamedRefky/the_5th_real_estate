import 'package:flutter/material.dart';

/// A reusable glossy "wet-metal" sheen overlay for platinum surfaces.
///
/// Adds a premium glass shine on top of metallic buttons, badges and cards:
/// a subtle white glass gradient on the upper half, a bright hairline top
/// edge, and an optional diagonal specular streak reflecting light.
class MetallicGloss extends StatelessWidget {
  /// Corner radius of the surface being glossed (0 for sharp edges).
  final double borderRadius;

  /// Gloss intensity from 0 (off) to 1 (full).
  final double strength;

  /// Whether to render the diagonal specular streak.
  final bool showStreak;

  const MetallicGloss({
    super.key,
    this.borderRadius = 0,
    this.strength = 1,
    this.showStreak = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = strength.clamp(0.0, 1.0).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Diagonal specular streak — light reflecting off polished metal.
          if (showStreak && s > 0)
            Align(
              alignment: const Alignment(-0.45, -0.7),
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  width: 150,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0.30 * s),
                        Colors.white.withValues(alpha: 0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),

          // Upper-half glass gloss.
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.34 * s),
                      Colors.white.withValues(alpha: 0.10 * s),
                      Colors.white.withValues(alpha: 0),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          ),

          // Bright hairline top edge.
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 1.2,
              color: Colors.white.withValues(alpha: 0.5 * s),
            ),
          ),
        ],
      ),
    );
  }
}
