import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_chip.dart';
import '../../../models/apartment.dart';

/// A premium card displaying an apartment listing in the Area Screen.
///
/// Shows: title, price, finishing badge, key stats (rooms, bath, sqm, floor),
/// and construction status if applicable.
class ApartmentCard extends StatefulWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  State<ApartmentCard> createState() => _ApartmentCardState();
}

class _ApartmentCardState extends State<ApartmentCard> {
  bool _isHovered = false;

  String? _getAreaImage(String area) {
    switch (area) {
      case 'بيت الوطن':
        return 'assets/image/bait_elwatan.webp';
      case 'جاردينيا':
        return 'assets/image/gardenia.webp';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apt = widget.apartment;
    final areaImage = _getAreaImage(apt.area);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesNames.apartmentDetails,
            arguments: apt.id,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered ? AppColors.accent : AppColors.divider,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.18)
                    : AppColors.primary.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 20 : 8,
                offset: Offset(0, _isHovered ? 6 : 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── 1. Dominant Image Box (210px Height) ──────────────────
                SizedBox(
                  height: 210,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Background Image or Fallback Gradient
                      if (areaImage != null) ...[
                        Positioned.fill(
                          child: AnimatedScale(
                            scale: _isHovered ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: Image.asset(
                              areaImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.25),
                                  Colors.black.withValues(alpha: 0.70),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.apartment_rounded,
                            size: 64,
                            color: AppColors.textPrimary.withValues(alpha: 0.12),
                          ),
                        ),
                      ],

                      // Finishing status badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _finishingColor(apt.finishingStatus),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            apt.finishingStatus.label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),

                      // Under construction badge
                      if (apt.isUnderConstruction)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.construction_rounded,
                                  size: 14,
                                  color: AppColors.textOnPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'تحت الإنشاء',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textOnPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Price Tag Floating on Image
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            apt.formattedPrice,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 2. Compact Card Body (Tight & No Empty Space) ──────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        apt.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _isHovered ? AppColors.accent : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 5),

                      // Description directly below title
                      Text(
                        apt.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      // Info Chips Row
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          InfoChip(
                            icon: Icons.bed_rounded,
                            label: '${apt.rooms} غرف',
                          ),
                          InfoChip(
                            icon: Icons.bathtub_rounded,
                            label: '${apt.bathrooms} حمام',
                          ),
                          InfoChip(
                            icon: Icons.square_foot_rounded,
                            label: '${apt.areaSqm.toInt()} م²',
                          ),
                          InfoChip(
                            icon: Icons.layers_rounded,
                            label: apt.floorLabel,
                          ),
                        ],
                      ),

                      // Delivery Date if applicable
                      if (apt.isUnderConstruction &&
                          apt.formattedDeliveryDate != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 13,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'التسليم: ${apt.formattedDeliveryDate}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _finishingColor(FinishingStatus status) {
    switch (status) {
      case FinishingStatus.finished:
        return AppColors.success;
      case FinishingStatus.semiFinished:
        return AppColors.info;
      case FinishingStatus.unfinished:
        return AppColors.textSecondary;
    }
  }
}
