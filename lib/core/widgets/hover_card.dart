import 'package:flutter/material.dart';

/// Shared hover shell: animated border + shadow elevation driven by mouse
/// hover.
///
/// Used by property cards (Building / Apartment) so the premium hover/glow
/// animation lives in one place instead of being duplicated per card.
class HoverCard extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final double borderWidth;
  final double hoverBorderWidth;
  final Color? shadowColor;
  final Color? hoverShadowColor;
  final double shadowBlur;
  final double hoverShadowBlur;
  final Offset shadowOffset;
  final Offset hoverShadowOffset;
  final MouseCursor cursor;
  final Duration duration;

  const HoverCard({
    super.key,
    required this.builder,
    required this.radius,
    this.color,
    this.borderColor,
    this.hoverBorderColor,
    this.borderWidth = 1.0,
    this.hoverBorderWidth = 1.5,
    this.shadowColor,
    this.hoverShadowColor,
    this.shadowBlur = 18,
    this.hoverShadowBlur = 24,
    this.shadowOffset = const Offset(0, 4),
    this.hoverShadowOffset = const Offset(0, 8),
    this.cursor = SystemMouseCursors.click,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHovered = _isHovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.cursor,
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: isHovered
                ? widget.hoverBorderColor ??
                    widget.borderColor ??
                    Colors.transparent
                : widget.borderColor ?? Colors.transparent,
            width: isHovered ? widget.hoverBorderWidth : widget.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? widget.hoverShadowColor ??
                      widget.shadowColor ??
                      Colors.black.withValues(alpha: 0.2)
                  : widget.shadowColor ??
                      Colors.black.withValues(alpha: 0.2),
              blurRadius: isHovered ? widget.hoverShadowBlur : widget.shadowBlur,
              offset: isHovered ? widget.hoverShadowOffset : widget.shadowOffset,
            ),
          ],
        ),
        child: widget.builder(context, isHovered),
      ),
    );
  }
}
