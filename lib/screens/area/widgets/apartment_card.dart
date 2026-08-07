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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apt = widget.apartment;

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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? AppColors.accent : AppColors.divider,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 20 : 8,
                offset: Offset(0, _isHovered ? 6 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Placeholder ──────────────────────────────
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    // Background icon
                    Center(
                      child: Icon(
                        Icons.apartment_rounded,
                        size: 64,
                        color: AppColors.textOnPrimary.withValues(alpha: 0.15),
                      ),
                    ),

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
                        ),
                        child: Text(
                          apt.finishingStatus.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Price tag
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          apt.formattedPrice,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Card Body ──────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            apt.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          // Description
                          Text(
                            apt.description,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Info chips
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

                          // Delivery date (if under construction)
                          if (apt.isUnderConstruction &&
                              apt.formattedDeliveryDate != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'التسليم: ${apt.formattedDeliveryDate}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
