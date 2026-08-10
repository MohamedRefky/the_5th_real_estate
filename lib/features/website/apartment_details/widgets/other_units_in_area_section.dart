import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../data/public_property_repository.dart';
import '../../../../models/apartment.dart';

/// List of other available units in the same area.
class OtherUnitsInAreaSection extends StatefulWidget {
  final Apartment currentApartment;

  const OtherUnitsInAreaSection({super.key, required this.currentApartment});

  @override
  State<OtherUnitsInAreaSection> createState() =>
      _OtherUnitsInAreaSectionState();
}

class _OtherUnitsInAreaSectionState extends State<OtherUnitsInAreaSection> {
  late final Future<List<Apartment>> _areaUnitsFuture;

  @override
  void initState() {
    super.initState();
    _areaUnitsFuture = PublicPropertyRepository.instance
        .byArea(widget.currentApartment.area)
        .then((units) =>
            units.where((apt) => apt.id != widget.currentApartment.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<Apartment>>(
      future: _areaUnitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        final areaUnits = snapshot.data ?? [];
        if (areaUnits.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'وحدات أخرى متاحة في حي ${widget.currentApartment.area}',
              icon: Icons.apartment_rounded,
            ),
            const SizedBox(height: 14),
            Column(
              children: areaUnits.map((apt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RoutesNames.apartmentDetails,
                          arguments: apt.id,
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.accentLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.home_work_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    apt.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'الدور: ${apt.floorLabel} • ${apt.areaSqm.toInt()} م² • ${apt.rooms} غرف',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  apt.formattedPrice,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'عرض',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: AppColors.accent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
