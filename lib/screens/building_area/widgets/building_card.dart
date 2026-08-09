import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/metallic_gloss.dart';
import '../../../models/building.dart';

/// Ultra-premium Glassmorphic Building Card with 3D hover/elevation effects,
/// metallic accents, construction timeline progress, and direct WhatsApp CTA.
class BuildingCard extends StatelessWidget {
  final Building building;

  const BuildingCard({super.key, required this.building});

  Future<void> _openWhatsapp(BuildContext context) async {
    final message = Uri.encodeComponent(
      'مرحباً، أود الاستفسار عن ${building.name} في حي ${building.area}.',
    );
    final cleanPhone = building.whatsappNumber.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر فتح واتساب على هذا الجهاز ($cleanPhone)'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface.withValues(alpha: 0.85),
                  AppColors.primaryMedium.withValues(alpha: 0.65),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header Badges Row ──────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Building icon container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.apartment_rounded,
                              color: AppColors.textOnPrimary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Name and neighborhood
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  building.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                              ],
                            ),
                          ),

                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: building.isUnderConstruction
                                  ? AppColors.warning.withValues(alpha: 0.18)
                                  : AppColors.success.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: building.isUnderConstruction
                                    ? AppColors.warning
                                    : AppColors.success,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              building.isUnderConstruction
                                  ? 'تحت الإنشاء'
                                  : 'جاهز للتسليم',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: building.isUnderConstruction
                                    ? AppColors.warning
                                    : AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Description ─────────────────────────────────────
                      Text(
                        building.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ── Stats Row (Floors, Units, Available) ────────────
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

                      // ── Construction Progress Bar (if under construction) ─
                      if (building.isUnderConstruction) ...[
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'نسبة الإنجاز بالحظر',
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
                            if (building.formattedDeliveryDate != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'التسليم المتوقع: ${building.formattedDeliveryDate}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textHint,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],

                      // ── Amenities Chips ────────────────────────────────
                      if (building.amenities.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
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

                      const SizedBox(height: 20),

                      // ── Price and Action Buttons Row ────────────────────
                      Row(
                        children: [
                          // Starting price label
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'أسعار الوحدات',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textHint,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  building.formattedStartingPrice,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // WhatsApp Button
                          InkWell(
                            onTap: () => _openWhatsapp(context),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF25D366),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.chat_rounded,
                                color: Color(0xFF25D366),
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // View Apartments Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RoutesNames.area,
                                arguments: building.area,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'عرض الشقق',
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
                        ],
                      ),
                    ],
                  ),
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
