import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Animates its [child] in with a fade + slide-up once it enters the
/// viewport. Supports a stagger [delayMilliseconds] so lists of cards can
/// cascade in one after another.
///
/// Works inside nested scrollables (e.g. grids inside a
/// `SingleChildScrollView`): it uses the nearest enclosing viewport for the
/// visibility check, so cards in non-scrollable grids simply cascade in.
enum RevealDirection {
  fromLeft,
  fromRight,
  fromBottom,
  fromTop,
  scale,
  flip3D,
  polaroidTilt,
  elasticPop,
}

/// Hardware-Accelerated 60 FPS Scroll Reveal Engine — Distinct Animation Styles per Section.
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Curve curve;
  final int delayMilliseconds;
  final RevealDirection direction;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.offset = 55,
    this.curve = Curves.easeOutQuart,
    this.delayMilliseconds = 0,
    this.direction = RevealDirection.fromRight,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final effectiveCurve = widget.direction == RevealDirection.elasticPop
        ? Curves.easeOutBack
        : widget.curve;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: effectiveCurve);
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachListener());
  }

  void _attachListener() {
    if (!mounted) return;
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) {
      _trigger();
      return;
    }
    _position = scrollable.position;
    _position!.addListener(_checkVisibility);
    _checkVisibility();
  }

  void _checkVisibility() {
    if (_started || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    final position = _position;
    if (viewport == null || position == null || !position.hasContentDimensions) {
      _trigger();
      return;
    }

    final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0).offset;
    final scrollOffset = position.pixels;
    final dimension = position.viewportDimension;
    final distance = revealOffset - scrollOffset;

    // Trigger animation when item reaches eye-level in lower viewport (180px above bottom edge)
    if (distance < (dimension - 180) && (distance + renderObject.size.height) > 0) {
      _position?.removeListener(_checkVisibility);
      _trigger();
    }
  }

  void _trigger() {
    if (_started) return;
    _started = true;
    if (widget.delayMilliseconds > 0) {
      Future<void>.delayed(
        Duration(milliseconds: widget.delayMilliseconds),
        () {
          if (mounted) _controller.forward();
        },
      );
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) {
        final progress = _animation.value;
        final invProgress = (1.0 - progress).clamp(0.0, 1.0);

        double dx = 0;
        double dy = 0;
        double scale = 1.0;
        final matrix = Matrix4.identity();

        switch (widget.direction) {
          case RevealDirection.fromRight:
            dx = invProgress * widget.offset;
            break;

          case RevealDirection.fromLeft:
            dx = -invProgress * widget.offset;
            break;

          case RevealDirection.fromBottom:
            dy = invProgress * widget.offset;
            break;

          case RevealDirection.fromTop:
            dy = -invProgress * widget.offset;
            break;

          case RevealDirection.scale:
            scale = 0.85 + (0.15 * progress);
            dy = invProgress * (widget.offset * 0.4);
            break;

          case RevealDirection.flip3D:
            matrix.setEntry(3, 2, 0.0012);
            matrix.rotateX(0.35 * invProgress);
            dy = invProgress * 40;
            scale = 0.90 + (0.10 * progress);
            break;

          case RevealDirection.polaroidTilt:
            matrix.rotateZ(-0.06 * invProgress);
            dy = invProgress * 45;
            scale = 0.92 + (0.08 * progress);
            break;

          case RevealDirection.elasticPop:
            scale = 0.70 + (0.30 * progress.clamp(0.0, 1.2));
            dy = invProgress * 30;
            break;
        }

        matrix.translateByDouble(dx, dy, 0.0, 1.0);

        return Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform(
            transform: matrix,
            alignment: Alignment.center,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
