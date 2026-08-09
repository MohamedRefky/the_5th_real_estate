import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/whatsapp_launcher.dart';
import '../../../core/widgets/cover_image_fallback.dart';
import '../../../core/widgets/metallic_gloss.dart';
import '../../../core/widgets/price_tag_pill.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/building.dart';

/// Ultra-premium Glassmorphic Building Card with 3D hover/elevation effects,
/// cover photo gallery support, structure/orientation badges, and WhatsApp CTA.
class BuildingCard extends StatefulWidget {
  final Building building;

  const BuildingCard({super.key, required this.building});

  @override
  State<BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends State<BuildingCard> {
  bool _isHovered = false;

  Future<void> _openWhatsapp(BuildContext context) async {
    final building = widget.building;
    await launchWhatsApp(
      phoneNumber: building.whatsappNumber,
      message:
          'مرحباً، أود الاستفسار عن ${building.name} في حي ${building.area}.',
      context: context,
      failureMessage:
          'تعذر فتح واتساب على هذا الجهاز (${building.whatsappNumber.replaceAll(RegExp(r'\D'), '')})',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final building = widget.building;
    final areaImage = AppConstants.areaImageAssetFor(building.area);
    final coverUrl = building.coverImageUrl;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? AppColors.accent : AppColors.accent.withValues(alpha: 0.25),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.22)
                  : Colors.black.withValues(alpha: 0.35),
              blurRadius: _isHovered ? 24 : 18,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: ClipRRect(
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
                      // ── 1. Building Facade / Cover Image Header (180px) ─────
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Network Cover Image / Local Fallback Asset / Fallback Gradient
                            if (coverUrl != null && coverUrl.isNotEmpty) ...[
                              Positioned.fill(
                                child: AnimatedScale(
                                  scale: _isHovered ? 1.06 : 1.0,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutCubic,
                                  child: Image.network(
                                    coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => CoverImageFallback(
                                      assetPath: areaImage,
                                      iconAlpha: 0.15,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Positioned.fill(
                                child: AnimatedScale(
                                  scale: _isHovered ? 1.06 : 1.0,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutCubic,
                                  child: CoverImageFallback(
                                    assetPath: areaImage,
                                    iconAlpha: 0.15,
                                  ),
                                ),
                              ),
                            ],

                            // Dark Gradient Overlay for title readability
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.2),
                                      Colors.black.withValues(alpha: 0.75),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Construction / Delivery status badge (Top Right)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: StatusBadge(
                                label: building.isUnderConstruction
                                    ? 'تحت الإنشاء'
                                    : 'جاهز للتسليم',
                                color: building.isUnderConstruction
                                    ? AppColors.warning
                                    : AppColors.success,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                fontSize: 11.5,
                                shadowColor: Colors.black.withValues(alpha: 0.3),
                                shadowBlur: 6,
                              ),
                            ),

                            // Price Tag Floating on Image (Bottom Right)
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: PriceTagPill(
                                price: building.formattedStartingPrice,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── 2. Building Body Content ───────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name & Neighborhood Row
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    building.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: _isHovered ? AppColors.accent : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.5,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.45,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ── Key Specifications Badges (Area, Structure, Orientation, Layout)
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                if (building.areaSqm != null)
                                  _FeatureBadge(
                                    icon: Icons.square_foot_rounded,
                                    label: '${building.areaSqm!.toInt()}م²',
                                  ),
                                if (building.buildingStructure != null)
                                  _FeatureBadge(
                                    icon: Icons.foundation_rounded,
                                    label: building.buildingStructure!,
                                  ),
                                if (building.orientation != null)
                                  _FeatureBadge(
                                    icon: Icons.explore_rounded,
                                    label: building.orientation!,
                                  ),
                                if (building.layoutNote != null)
                                  _FeatureBadge(
                                    icon: Icons.space_dashboard_rounded,
                                    label: building.layoutNote!,
                                  ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // ── Stats Container (Floors, Units, Available) ────
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _StatItem(
                                    icon: Icons.layers_rounded,
                                    label: 'الأدوار',
                                    value: '${building.totalFloors} أدوار',
                                  ),
                                  _buildDivider(),
                                  _StatItem(
                                    icon: Icons.grid_view_rounded,
                                    label: 'إجمالي الوحدات',
                                    value: '${building.totalUnits} شقة',
                                  ),
                                  _buildDivider(),
                                  _StatItem(
                                    icon: Icons.door_front_door_rounded,
                                    label: 'المتاح حالياً',
                                    value: '${building.availableUnits} شقة',
                                    highlight: true,
                                  ),
                                ],
                              ),
                            ),

                            // ── Construction Progress Bar (if under construction)
                            if (building.isUnderConstruction) ...[
                              const SizedBox(height: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'نسبة الإنجاز',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${(building.constructionProgress * 100).round()}%',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: building.constructionProgress,
                                      minHeight: 6,
                                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            // ── Amenities Chips ─────────────────────────────
                            if (building.amenities.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: building.amenities.map((amenity) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.accent.withValues(alpha: 0.25),
                                        width: 0.6,
                                      ),
                                    ),
                                    child: Text(
                                      amenity,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.accentLight2,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],

                            const SizedBox(height: 18),

                            // ── Action Buttons Row (WhatsApp + View Apartments)
                            Row(
                              children: [
                                // WhatsApp Button
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _openWhatsapp(context),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 11),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF25D366).withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: const Color(0xFF25D366),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.chat_rounded,
                                            color: Color(0xFF25D366),
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'تواصل واتساب',
                                            style: TextStyle(
                                              color: Color(0xFF25D366),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // View Details Button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesNames.buildingDetails,
                                        arguments: building.id,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.textOnPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 11),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'تفاصيل العمارة',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(Icons.arrow_forward_rounded, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
  ),
);
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: highlight ? AppColors.accent : AppColors.textSecondary,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.accent : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textHint,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
