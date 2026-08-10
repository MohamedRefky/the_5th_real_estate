import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/utils/status_colors.dart';
import '../../../../core/widgets/cover_image_fallback.dart';
import '../../../../core/widgets/hover_card.dart';
import '../../../../core/widgets/info_chip.dart';
import '../../../../core/widgets/price_tag_pill.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../models/apartment.dart';

/// A premium card displaying an apartment listing in the Area Screen.
///
/// Shows: title, price, finishing badge, key stats (rooms, bath, sqm, floor),
/// and construction status if applicable.
class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apt = apartment;
    final areaImage = AppConstants.areaImageAssetFor(apt.area);

    return HoverCard(
      radius: 18,
      color: AppColors.surface,
      borderColor: AppColors.divider,
      hoverBorderColor: AppColors.accent,
      shadowColor: AppColors.primary.withValues(alpha: 0.05),
      hoverShadowColor: AppColors.accent.withValues(alpha: 0.18),
      shadowBlur: 8,
      shadowOffset: const Offset(0, 2),
      builder: (context, isHovered) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesNames.apartmentDetails,
              arguments: apt.id,
            );
          },
          borderRadius: BorderRadius.circular(18),
          hoverColor: Colors.transparent,
          highlightColor: AppColors.accent.withValues(alpha: 0.1),
          splashColor: AppColors.accent.withValues(alpha: 0.15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── 1. Dominant Image Box (175px Height) ──────────────────
                SizedBox(
                  height: 175,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Background Image (Cover URL > Area Asset > Fallback)
                      if (apt.coverImageUrl != null &&
                          apt.coverImageUrl!.isNotEmpty) ...[
                        Positioned.fill(
                          child: AnimatedScale(
                            scale: isHovered ? 1.04 : 1.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: Image.network(
                              sanitizeImageUrl(apt.coverImageUrl!),
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (_, _, _) => areaImage != null
                                  ? Image.asset(areaImage, fit: BoxFit.cover)
                                  : const CoverImageFallback(),
                            ),
                          ),
                        ),
                        // Gradient overlay for text readability
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.1),
                                  Colors.black.withValues(alpha: 0.55),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] else if (areaImage != null) ...[
                        Positioned.fill(
                          child: AnimatedScale(
                            scale: isHovered ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: Image.asset(areaImage, fit: BoxFit.cover),
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
                        Positioned.fill(child: const CoverImageFallback()),
                      ],

                      // Finishing status badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: StatusBadge(
                          label: apt.finishingStatus.label,
                          color: finishingStatusColor(apt.finishingStatus),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          fontSize: 11,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                          shadowBlur: 6,
                        ),
                      ),

                      // Under construction badge
                      if (apt.isUnderConstruction)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: StatusBadge(
                            label: 'تحت الإنشاء',
                            color: AppColors.warning,
                            icon: Icons.construction_rounded,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            fontSize: 11,
                            showShadow: false,
                          ),
                        ),

                      // Price Tag Floating on Image
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: PriceTagPill(price: apt.formattedPrice),
                      ),
                    ],
                  ),
                ),

                // ── 2. Compact Card Body (Tight & No Empty Space) ──────
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        apt.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isHovered
                              ? AppColors.accent
                              : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 5),

                      // Description directly below title
                      Text(
                        apt.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
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
                            icon: Icons.home_work_rounded,
                            label: apt.unitType.label,
                          ),
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
                          InfoChip(
                            icon: Icons.explore_rounded,
                            label: apt.orientation.label,
                          ),
                          if (apt.formattedPriceNotes != null)
                            InfoChip(
                              icon: Icons.sell_rounded,
                              label: apt.formattedPriceNotes!,
                              iconColor: AppColors.accent,
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
}
