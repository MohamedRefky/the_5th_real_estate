import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feature_badge.dart';
import '../../../../core/widgets/hover_card.dart';
import '../../../../core/widgets/metallic_gloss.dart';
import '../../../../models/building.dart';
import 'amenity_chips.dart';
import 'building_action_buttons.dart';
import 'building_cover_header.dart';
import 'building_stats_row.dart';
import 'construction_progress_bar.dart';

/// Ultra-premium Glassmorphic Building Card with 3D hover/elevation effects,
/// cover photo gallery support, structure/orientation badges, and WhatsApp CTA.
class BuildingCard extends StatelessWidget {
  final Building building;

  const BuildingCard({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final areaImage = AppConstants.areaImageAssetFor(building.area);

    return HoverCard(
      radius: 24,
      borderColor: AppColors.accent.withValues(alpha: 0.25),
      hoverBorderColor: AppColors.accent,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      hoverShadowColor: AppColors.accent.withValues(alpha: 0.22),
      builder: (context, isHovered) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutesNames.buildingDetails,
                  arguments: building.id,
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surface.withValues(alpha: 0.95),
                      AppColors.primaryMedium.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Cover / Facade Header ────────────────────────
                        BuildingCoverHeader(
                          building: building,
                          areaImage: areaImage,
                          isHovered: isHovered,
                        ),

                        // ── Card Body ────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                building.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isHovered
                                      ? AppColors.accent
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.5,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 6),

                              // Area location
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 14,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    building.area,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.accentLight2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Description
                              Text(
                                building.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 18),

                              // Action buttons (WhatsApp + details)
                              BuildingActionButtons(building: building),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Metallic gloss overlay effect
                    Positioned.fill(
                      child: IgnorePointer(
                        child: MetallicGloss(
                          borderRadius: 24,
                          strength: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
