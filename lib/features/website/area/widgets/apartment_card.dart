import 'dart:ui';

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
import 'apartment_action_buttons.dart';

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
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return HoverCard(
      radius: isMobile ? 18 : 24,
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
          borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
          hoverColor: Colors.transparent,
          highlightColor: AppColors.accent.withValues(alpha: 0.1),
          splashColor: AppColors.accent.withValues(alpha: 0.15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── 1. Dominant Image Box ──────────────────
                AspectRatio(
                  aspectRatio: 16 / 11,
                  child: Stack(
                    children: [
                      // Background Image (Cover URL > Area Asset > Fallback)
                      if (apt.coverImageUrl != null &&
                          apt.coverImageUrl!.isNotEmpty) ...[
                        Positioned.fill(
                          child: AnimatedScale(
                            scale: isHovered ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: Image.network(
                              sanitizeImageUrl(apt.coverImageUrl!),
                              fit: BoxFit.cover,
                              alignment: const Alignment(0.0, -0.15),
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, _, _) => areaImage != null
                                  ? Image.asset(areaImage, fit: BoxFit.cover)
                                  : const CoverImageFallback(),
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
                                  Colors.black.withValues(alpha: 0.18),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.45),
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
                        top: 10,
                        right: 10,
                        child: StatusBadge(
                          label: apt.finishingStatusLabel,
                          color: finishingStatusColor(apt.finishingStatus),
                          gradient: finishingStatusGradient(
                            apt.finishingStatus,
                          ),
                          icon: finishingStatusIcon(apt.finishingStatus),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 11,
                            vertical: isMobile ? 4 : 5.5,
                          ),
                          fontSize: isMobile ? 10 : 11,
                          shadowColor: Colors.black.withValues(alpha: 0.35),
                          shadowBlur: 8,
                        ),
                      ),

                      // Property Category Badge ("شقة") + Under Construction Badge on Top-Left
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 8 : 10,
                                    vertical: isMobile ? 3.5 : 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.60),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.6,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.home_work_rounded,
                                        size: isMobile ? 11 : 13,
                                        color: AppColors.accent,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'شقة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isMobile ? 10 : 11.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (apt.isUnderConstruction) ...[
                              const SizedBox(width: 5),
                              StatusBadge(
                                label: 'تحت الإنشاء',
                                color: AppColors.warning,
                                icon: Icons.construction_rounded,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 7 : 10,
                                  vertical: isMobile ? 3.5 : 5,
                                ),
                                fontSize: isMobile ? 9.5 : 11,
                                showShadow: false,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Price Tag Floating on Image
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: PriceTagPill(price: apt.formattedPrice),
                      ),
                    ],
                  ),
                ),

                // ── 2. Compact Card Body (Tight & No Empty Space) ──────
                Padding(
                  padding: EdgeInsets.all(isMobile ? 11 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        apt.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: isMobile ? 14.5 : 16.5,
                          color: isHovered
                              ? AppColors.accent
                              : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Description directly below title
                      Text(
                        apt.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isMobile ? 12 : 14.5,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        maxLines: isMobile ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: isMobile ? 6 : 10),

                      // Info Chips Row
                      Wrap(
                        spacing: isMobile ? 4 : 6,
                        runSpacing: isMobile ? 4 : 6,
                        children: [
                          InfoChip(
                            icon: Icons.home_work_rounded,
                            label: apt.unitTypeLabel,
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
                          (() {
                            try {
                              final orientation = apt.orientation;
                              if (orientation != null) {
                                final orientationLabel = orientation.label;
                                if (orientationLabel.isNotEmpty) {
                                  return InfoChip(
                                    icon: Icons.explore_rounded,
                                    label: orientationLabel,
                                  );
                                }
                              }
                            } catch (_) {}
                            return const SizedBox.shrink();
                          })(),
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
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'التسليم: ${apt.formattedDeliveryDate}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: isMobile ? 10 : 16),

                      // Action buttons (WhatsApp + details)
                      ApartmentActionButtons(apartment: apt),
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
