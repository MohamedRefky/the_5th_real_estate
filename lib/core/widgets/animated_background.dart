import 'dart:math';
import 'package:flutter/material.dart';

/// A luxurious animated background with floating geometric shapes.
///
/// Creates an ethereal atmosphere with slowly drifting, semi-transparent
/// shapes (circles, rounded squares, diamonds) that float and rotate.
/// Perfect for hero headers and premium landing sections.
class AnimatedBackground extends StatefulWidget {
  /// The child widget rendered on top of the animation.
  final Widget child;

  /// Base color for the floating shapes.
  final Color shapeColor;

  /// Number of floating shapes.
  final int shapeCount;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.shapeColor = const Color(0xFFFFFFFF),
    this.shapeCount = 15,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FloatingShape> _shapes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    final random = Random();
    _shapes = List.generate(widget.shapeCount, (i) {
      return _FloatingShape(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 60 + 20,
        speedX: (random.nextDouble() - 0.5) * 0.3,
        speedY: (random.nextDouble() - 0.5) * 0.2,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.5,
        opacity: random.nextDouble() * 0.06 + 0.02,
        shapeType: random.nextInt(3),
        borderRadius: random.nextDouble() * 20 + 5,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ShapePainter(
                      shapes: _shapes,
                      progress: _controller.value,
                      color: widget.shapeColor,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingShape {
  final double x;
  final double y;
  final double size;
  final double speedX;
  final double speedY;
  final double rotation;
  final double rotationSpeed;
  final double opacity;
  final int shapeType; // 0 = circle, 1 = rounded rect, 2 = diamond
  final double borderRadius;

  _FloatingShape({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.rotation,
    required this.rotationSpeed,
    required this.opacity,
    required this.shapeType,
    required this.borderRadius,
  });
}

class _ShapePainter extends CustomPainter {
  final List<_FloatingShape> shapes;
  final double progress;
  final Color color;

  _ShapePainter({
    required this.shapes,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      // Calculate position with wrapping
      final x = ((shape.x + shape.speedX * progress) % 1.0) * size.width;
      final y = ((shape.y + shape.speedY * progress) % 1.0) * size.height;
      final angle = shape.rotation + shape.rotationSpeed * progress * 2 * pi;

      final paint = Paint()
        ..color = color.withValues(alpha: shape.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      final halfSize = shape.size / 2;

      switch (shape.shapeType) {
        case 0: // Circle
          canvas.drawCircle(Offset.zero, halfSize, paint);
          // Inner circle for depth
          paint.color = color.withValues(alpha: shape.opacity * 0.5);
          canvas.drawCircle(Offset.zero, halfSize * 0.6, paint);
          break;
        case 1: // Rounded rectangle
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: shape.size,
                height: shape.size,
              ),
              Radius.circular(shape.borderRadius),
            ),
            paint,
          );
          break;
        case 2: // Diamond / rotated square
          final path = Path()
            ..moveTo(0, -halfSize)
            ..lineTo(halfSize * 0.6, 0)
            ..lineTo(0, halfSize)
            ..lineTo(-halfSize * 0.6, 0)
            ..close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
