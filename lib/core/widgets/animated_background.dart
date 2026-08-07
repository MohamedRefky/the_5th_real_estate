import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ambient animated background with floating emerald light orbs.
///
/// Renders a soft radial glow plus a set of slow-drifting, pulsing orbs
/// behind the given [child]. The orbs drift on a looping timeline so the
/// background always feels alive without distracting from the content.
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color shapeColor;
  final int shapeCount;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.shapeColor = Colors.white,
    this.shapeCount = 6,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Orb> _orbs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _orbs = List.generate(
      math.max(1, widget.shapeCount),
      (index) => _Orb(index),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Ambient Radial Glow Backdrop ───────────────────
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.6),
                  radius: 1.2,
                  colors: [
                    widget.shapeColor.withValues(alpha: 0.13),
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // ── Floating Pulsing Orbs ───────────────────────────
            for (final orb in _orbs)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;

                  final fractionX =
                      ((math.sin(t * orb.freqX + orb.phaseX) + 1) / 2);
                  final fractionY =
                      ((math.cos(t * orb.freqY + orb.phaseY) + 1) / 2);

                  // Orbit around a nominal centre point
                  final centerX = width * orb.cx;
                  final centerY = height * orb.cy;
                  final radiusX = width * orb.ampX;
                  final radiusY = height * orb.ampY;
                  final size = orb.size;

                  final left = centerX + (fractionX - 0.5) * 2 * radiusX - size / 2;
                  final top = centerY + (fractionY - 0.5) * 2 * radiusY - size / 2;

                  // Gentle pulse
                  final pulse = 1 + math.sin(t * orb.freqPulse + orb.phaseX) * 0.1;

                  return Positioned(
                    left: left,
                    top: top,
                    width: size * pulse,
                    height: size * pulse,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.shapeColor
                                  .withValues(alpha: orb.alpha),
                              widget.shapeColor
                                  .withValues(alpha: orb.alpha * 0.35),
                              widget.shapeColor.withValues(alpha: 0),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.shapeColor
                                  .withValues(alpha: orb.alpha * 0.4),
                              blurRadius: 46,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            // ── Foreground Content ──────────────────────────────
            widget.child,
          ],
        );
      },
    );
  }
}

/// Static spec for a single drifting orb. Seeded deterministically so the
/// layout is stable across rebuilds.
class _Orb {
  late final double cx;
  late final double cy;
  late final double ampX;
  late final double ampY;
  late final double size;
  late final double freqX;
  late final double freqY;
  late final double freqPulse;
  late final double phaseX;
  late final double phaseY;
  late final double alpha;

  _Orb(int seed) {
    final r = math.Random(seed * 7919 + 13);
    cx = 0.12 + r.nextDouble() * 0.76;
    cy = 0.12 + r.nextDouble() * 0.76;
    ampX = 0.04 + r.nextDouble() * 0.1;
    ampY = 0.04 + r.nextDouble() * 0.1;
    size = 150 + r.nextDouble() * 220;
    freqX = 0.35 + r.nextDouble() * 0.7;
    freqY = 0.35 + r.nextDouble() * 0.7;
    freqPulse = 0.5 + r.nextDouble() * 0.9;
    phaseX = r.nextDouble() * math.pi * 2;
    phaseY = r.nextDouble() * math.pi * 2;
    alpha = 0.10 + r.nextDouble() * 0.13;
  }
}
