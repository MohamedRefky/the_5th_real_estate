import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A premium pill badge with two variants.
///
/// - [filled] (default): solid [color] background with light text, used on
///   detail screens and card image overlays.
/// - outlined: translucent background with a colored border and text.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  /// `true` renders the solid variant, `false` the outlined variant.
  final bool filled;

  /// Optional leading icon (filled variant only).
  final IconData? icon;

  final EdgeInsetsGeometry padding;

  /// When `null` the theme's `bodySmall` size is used for filled badges and
  /// `13` for outlined badges.
  final double? fontSize;

  /// Fully-resolved shadow color. Defaults to a soft tint of [color].
  final Color? shadowColor;

  final double shadowBlur;

  final bool showShadow;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.filled = true,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    this.fontSize,
    this.shadowColor,
    this.shadowBlur = 8,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!filled) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: fontSize ?? 13,
          ),
        ),
      );
    }

    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.textOnPrimary,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );

    final labelWidget = Text(label, style: textStyle);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: shadowColor ?? color.withValues(alpha: 0.2),
                  blurRadius: shadowBlur,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: AppColors.textOnPrimary),
                const SizedBox(width: 4),
                labelWidget,
              ],
            )
          : labelWidget,
    );
  }
}
