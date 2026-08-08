import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Animates its [child] in with a fade + slide-up once it enters the
/// viewport. Supports a stagger [delayMilliseconds] so lists of cards can
/// cascade in one after another.
///
/// Works inside nested scrollables (e.g. grids inside a
/// `SingleChildScrollView`): it uses the nearest enclosing viewport for the
/// visibility check, so cards in non-scrollable grids simply cascade in.
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Curve curve;
  final int delayMilliseconds;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.offset = 28,
    this.curve = Curves.easeOutCubic,
    this.delayMilliseconds = 0,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _translate;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: widget.curve);
    _translate = Tween<double>(begin: widget.offset, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
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
      return;
    }

    final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0).offset;
    final scrollOffset = position.pixels;
    final dimension = position.viewportDimension;
    final distance = revealOffset - scrollOffset;
    final height = renderObject.size.height;

    // Visible once its top has scrolled past the bottom edge.
    if (distance < dimension && distance + height > 0) {
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
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _translate.value),
            child: child,
          ),
        );
      },
    );
  }
}
