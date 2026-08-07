import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Understated luxury ambient animation.
///
/// Realistic gold buildings (outline + gold gradient fill with lit windows,
/// floor separators and balconies — echoing the app icon) drift gently upward
/// like glowing sparks, while soft gold light pools "breathe" slowly behind
/// them.
class AmbientParticles extends StatefulWidget {
  final Color color;
  final int particleCount;

  const AmbientParticles({
    super.key,
    this.color = AppColors.accent,
    this.particleCount = 16,
  });

  @override
  State<AmbientParticles> createState() => _AmbientParticlesState();
}

class _AmbientParticlesState extends State<AmbientParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Building> _buildings;
  late final List<_Glow> _glows;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _buildings = List.generate(
      math.max(1, widget.particleCount),
      (index) => _Building(index),
    );
    _glows = [
      _Glow(fx: 0.22, fy: 0.32, radius: 0.32, speed: 0.22, phase: 0.0, alpha: 0.085),
      _Glow(fx: 0.78, fy: 0.48, radius: 0.36, speed: 0.17, phase: 1.4, alpha: 0.075),
      _Glow(fx: 0.48, fy: 0.78, radius: 0.30, speed: 0.26, phase: 2.8, alpha: 0.065),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _AmbientPainter(
            buildings: _buildings,
            glows: _glows,
            color: widget.color,
            time: _controller.value,
          ),
        );
      },
    );
  }
}

/// A realistic gold building that drifts upward.
class _Building {
  late final double fx;
  late final double speed;
  late final double size;
  late final double phase;
  late final double swayFreq;
  late final double alpha;
  late final double heightFactor;
  late final int floors;
  late final int windowCols;
  late final bool hasAntenna;
  late final bool hasBalconies;

  _Building(int seed) {
    final r = math.Random(seed * 101 + 5);
    fx = r.nextDouble();
    speed = 0.04 + r.nextDouble() * 0.10;
    size = 3.2 + r.nextDouble() * 3.0;
    phase = r.nextDouble();
    swayFreq = 0.3 + r.nextDouble() * 0.7;
    alpha = 0.30 + r.nextDouble() * 0.22;
    heightFactor = 3.0 + r.nextDouble() * 2.5;
    floors = 4 + r.nextInt(3);
    windowCols = 2 + r.nextInt(2);
    hasAntenna = r.nextBool();
    hasBalconies = r.nextBool();
  }
}

/// A slow "breathing" pool of soft gold light.
class _Glow {
  final double fx;
  final double fy;
  final double radius;
  final double speed;
  final double phase;
  final double alpha;

  _Glow({
    required this.fx,
    required this.fy,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.alpha,
  });
}

class _AmbientPainter extends CustomPainter {
  _AmbientPainter({
    required this.buildings,
    required this.glows,
    required this.color,
    required this.time,
  });

  final List<_Building> buildings;
  final List<_Glow> glows;
  final Color color;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    _drawBreathingGlows(canvas, w, h);

    for (final b in buildings) {
      final raw = (time * b.speed + b.phase) % 1.0;
      final fade = math.sin(raw * math.pi);
      final baseY = (1.0 - raw) * h;
      final x =
          (b.fx + math.sin((time * b.swayFreq + b.fx) * 2 * math.pi) * 0.02) *
              w;
      _drawBuilding(canvas, x, baseY, b, b.alpha * fade);
    }
  }

  void _drawBreathingGlows(Canvas canvas, double w, double h) {
    final maxDim = math.max(w, h);
    for (final g in glows) {
      final pulse = 0.5 + 0.5 * math.sin(time * 2 * math.pi * g.speed + g.phase);
      final alpha = g.alpha * (0.55 + 0.45 * pulse);
      final cx = (g.fx + math.sin(time * 2 * math.pi * 0.1 + g.phase) * 0.02) * w;
      final cy = (g.fy + math.cos(time * 2 * math.pi * 0.08 + g.phase) * 0.03) * h;
      final radius = g.radius * maxDim;
      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: alpha * 0.4),
              Colors.transparent,
            ],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(rect),
      );
    }
  }

  void _drawBuilding(
    Canvas canvas,
    double x,
    double baseY,
    _Building b,
    double a,
  ) {
    if (a <= 0.004) return;
    final bw = b.size * 2.2;
    final bh = b.size * b.heightFactor;
    final top = baseY - bh;
    final left = x - bw / 2;
    final rect = Rect.fromLTWH(left, top, bw, bh);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));

    // Soft glow halo behind the building.
    canvas.drawCircle(
      Offset(x, top + bh * 0.45),
      bh * 0.95,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: a * 0.18),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: Offset(x, top + bh * 0.45), radius: bh * 0.95),
        ),
    );

    // Gold gradient body fill.
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.accentLight.withValues(alpha: a * 0.60),
            color.withValues(alpha: a * 0.50),
            AppColors.accentDark.withValues(alpha: a * 0.55),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(rect),
    );

    // Floor separators.
    final floorH = bh / b.floors;
    final sep = Paint()
      ..strokeWidth = 0.7
      ..color = AppColors.accentDark.withValues(alpha: a * 0.35);
    for (var r = 1; r < b.floors; r++) {
      final fy = top + floorH * r;
      canvas.drawLine(Offset(left, fy), Offset(left + bw, fy), sep);
    }

    // Window grid — alternating lit / dark glass.
    final cellW = bw / b.windowCols;
    final ww = cellW * 0.5;
    final wh = floorH * 0.42;
    final litPaint = Paint()
      ..color = AppColors.accentLight2.withValues(alpha: a * 0.95);
    final darkPaint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: a * 0.55);
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: a * 0.35);
    for (var r = 0; r < b.floors; r++) {
      for (var c = 0; c < b.windowCols; c++) {
        final wx = left + cellW * c + (cellW - ww) / 2;
        final wy = top + floorH * r + (floorH - wh) / 2;
        final wr = Rect.fromLTWH(wx, wy, ww, wh);
        final lit = (r + c).isEven;
        canvas.drawRect(wr, lit ? litPaint : darkPaint);
        if (lit) {
          canvas.drawRect(
            Rect.fromLTWH(wx, wy, ww * 0.3, wh),
            shinePaint,
          );
        }
      }
    }

    // Gold outline.
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = color.withValues(alpha: a * 0.9),
    );

    // Roof parapet ledge.
    final parapetH = math.max(2.0, bh * 0.05);
    final parapetRect = Rect.fromLTWH(left - 1, top - parapetH, bw + 2, parapetH);
    canvas.drawRect(
      parapetRect,
      Paint()..color = color.withValues(alpha: a * 0.85),
    );
    canvas.drawRect(
      parapetRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = AppColors.accentLight.withValues(alpha: a * 0.9),
    );

    // Balcony railings on both sides of some buildings.
    if (b.hasBalconies) {
      final bc = Paint()
        ..strokeWidth = 1.0
        ..color = color.withValues(alpha: a * 0.75);
      for (var r = 0; r < b.floors; r++) {
        final fy = top + floorH * r + floorH * 0.28;
        canvas.drawLine(Offset(left - 2, fy), Offset(left - 2, fy + floorH * 0.42), bc);
        canvas.drawLine(Offset(left + bw + 2, fy), Offset(left + bw + 2, fy + floorH * 0.42), bc);
      }
    }

    // Subtle glass streak on the facade.
    final streak = Path()
      ..moveTo(left, top)
      ..lineTo(left + bw * 0.45, top)
      ..lineTo(left, top + bh * 0.4)
      ..close();
    canvas.drawPath(
      streak,
      Paint()..color = AppColors.accentLight.withValues(alpha: a * 0.10),
    );

    // Antenna with a blinking beacon on some buildings.
    if (b.hasAntenna) {
      final tip = Offset(x, top - parapetH - b.size * 1.2);
      canvas.drawLine(
        Offset(x, top - parapetH),
        tip,
        Paint()
          ..strokeWidth = 0.8
          ..color = color.withValues(alpha: a * 0.6),
      );
      final blink =
          0.5 + 0.5 * math.sin(time * 2 * math.pi * 1.4 + b.phase * 2 * math.pi);
      canvas.drawCircle(
        tip,
        math.max(0.9, b.size * 0.5),
        Paint()..color = color.withValues(alpha: blink * a * 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.color != color ||
        oldDelegate.buildings != buildings ||
        oldDelegate.glows != glows;
  }
}
