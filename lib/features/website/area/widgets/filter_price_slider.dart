import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/filters/filter_formatters.dart';

/// Price range slider with its live EGP readout label.
class FilterPriceSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const FilterPriceSlider({
    super.key,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double minVal = 0;
    const double maxVal = 100000000;

    final clampedStart = values.start.clamp(minVal, maxVal);
    final clampedEnd = values.end.clamp(minVal, maxVal);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'السعر:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${formatPriceShort(clampedStart)} - ${formatPriceShort(clampedEnd)} جنيه',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.divider,
            thumbColor: AppColors.accent,
          ),
          child: RangeSlider(
            values: RangeValues(clampedStart, clampedEnd),
            min: minVal,
            max: maxVal,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
