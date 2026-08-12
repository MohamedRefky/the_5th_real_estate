import 'dart:ui';

import 'package:flutter/material.dart';



/// A premium pill badge with two variants.
///
/// - [filled] (default): solid [color] or [gradient] background with crisp light text.
/// - outlined: glassmorphic background with a colored border and text.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Gradient? gradient;

  /// `true` renders the solid variant, `false` the outlined variant.
  final bool filled;

  /// Optional leading icon (filled variant only).
  final IconData? icon;

  final EdgeInsetsGeometry padding;

  /// When `null` default size is used.
  final double? fontSize;

  /// Fully-resolved shadow color. Defaults to a soft tint of [color].
  final Color? shadowColor;

  final double shadowBlur;

  final bool showShadow;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.gradient,
    this.filled = true,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.fontSize,
    this.shadowColor,
    this.shadowBlur = 10,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!filled) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.65),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: (fontSize ?? 12) + 2, color: color),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: fontSize ?? 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: fontSize ?? 11.5,
      letterSpacing: 0.2,
    );

    final labelWidget = Text(label, style: textStyle);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 0.8,
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: shadowColor ?? color.withValues(alpha: 0.35),
                  blurRadius: shadowBlur,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: (fontSize ?? 11.5) + 2, color: Colors.white),
                const SizedBox(width: 5),
                labelWidget,
              ],
            )
          : labelWidget,
    );
  }
}
