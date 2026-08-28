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

    // Safety fallback: if viewport metrics fail to attach or calculate on mobile/web,
    // automatically trigger the animation so content is NEVER stuck at opacity 0.
    Future.delayed(Duration(milliseconds: 450 + widget.delayMilliseconds), () {
      if (mounted && !_started) {
        _trigger();
      }
    });
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

    // Trigger animation as soon as item nears viewport (350px lookahead margin)
    // so elements on mobile and desktop are already revealed before the user scrolls directly onto them.
    if (distance < (dimension + 350) && (distance + renderObject.size.height) > -350) {
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
        final isMobile = MediaQuery.of(context).size.width < 768;
        final effectiveOffset = isMobile ? (widget.offset * 0.35).clamp(10.0, 20.0) : widget.offset;

        double dx = 0;
        double dy = 0;
        double scale = 1.0;
        final matrix = Matrix4.identity();

        switch (widget.direction) {
          case RevealDirection.fromRight:
            dx = invProgress * effectiveOffset;
            break;

          case RevealDirection.fromLeft:
            dx = -invProgress * effectiveOffset;
            break;

          case RevealDirection.fromBottom:
            dy = invProgress * effectiveOffset;
            break;

          case RevealDirection.fromTop:
            dy = -invProgress * effectiveOffset;
            break;

          case RevealDirection.scale:
            scale = (isMobile ? 0.94 : 0.85) + ((isMobile ? 0.06 : 0.15) * progress);
            dy = invProgress * (effectiveOffset * 0.4);
            break;

          case RevealDirection.flip3D:
            if (!isMobile) {
              matrix.setEntry(3, 2, 0.0012);
              matrix.rotateX(0.35 * invProgress);
            }
            dy = invProgress * (isMobile ? 15 : 40);
            scale = (isMobile ? 0.96 : 0.90) + ((isMobile ? 0.04 : 0.10) * progress);
            break;

          case RevealDirection.polaroidTilt:
            if (!isMobile) {
              matrix.rotateZ(-0.06 * invProgress);
            }
            dy = invProgress * (isMobile ? 15 : 45);
            scale = (isMobile ? 0.96 : 0.92) + ((isMobile ? 0.04 : 0.08) * progress);
            break;

          case RevealDirection.elasticPop:
            scale = (isMobile ? 0.90 : 0.70) + ((isMobile ? 0.10 : 0.30) * progress.clamp(0.0, 1.2));
            dy = invProgress * (isMobile ? 12 : 30);
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
