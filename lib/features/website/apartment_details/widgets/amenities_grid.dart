import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_chip.dart';

/// Wrap of amenity chips for an apartment listing.
class AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesGrid({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amenities
          .map(
            (amenity) => InfoChip(
              icon: Icons.check_circle_rounded,
              label: amenity,
              iconColor: AppColors.success,
            ),
          )
          .toList(),
    );
  }
}
