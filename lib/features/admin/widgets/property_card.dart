import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_url_helper.dart';
import '../models/property.dart';

/// Compact row card for a single property on the admin dashboard.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 540;

        final imageBox = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: isMobile ? 96 : 140,
            height: isMobile ? 86 : 102,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (property.imageUrls.isNotEmpty)
                  Image.network(
                    sanitizeImageUrl(property.imageUrls.first),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.primary,
                      child: const Icon(
                        Icons.broken_image_rounded,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  )
                else
                  Container(
                    color: AppColors.cream,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.textHint,
                          size: 22,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'بدون صور',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (property.imageUrls.length > 1)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${property.imageUrls.length} صور',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

        final detailsColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    property.unitType.label,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    property.area,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!property.isPublished)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'مخفي',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              property.projectName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              [
                property.unitType.label,
                '${property.areaSqm.toStringAsFixed(0)} م²',
                '${property.bedrooms} غرف',
                '${property.bathrooms} حمام',
                property.finishingStatus.label,
              ].join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12.5),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${property.floor} — ${property.formattedPrice}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (property.priceUsd != null)
                  Text(
                    '≈ ${_formatUsd(property.priceUsd!)} دولار',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ],
        );

        if (isMobile) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageBox,
                    const SizedBox(width: 12),
                    Expanded(child: detailsColumn),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      property.isPublished ? 'منشور' : 'مخفي',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: property.isPublished
                            ? AppColors.accent
                            : AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: property.isPublished,
                        activeTrackColor: AppColors.accent,
                        onChanged: onToggle,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'تعديل',
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded,
                          color: AppColors.accent, size: 20),
                    ),
                    IconButton(
                      tooltip: 'حذف',
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_rounded,
                          color: AppColors.error, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              imageBox,
              const SizedBox(width: 14),
              Expanded(child: detailsColumn),
              Switch(
                value: property.isPublished,
                activeTrackColor: AppColors.accent,
                onChanged: onToggle,
              ),
              IconButton(
                tooltip: 'تعديل',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, color: AppColors.accent),
              ),
              IconButton(
                tooltip: 'حذف',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_rounded, color: AppColors.error),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Compact USD formatting (e.g. 120000 → "120 ألف").
String _formatUsd(double value) {
  if (value >= 1000000) {
    final millions = value / 1000000;
    final formatted = millions == millions.roundToDouble()
        ? millions.toStringAsFixed(0)
        : millions.toStringAsFixed(1);
    return '$formatted مليون';
  }
  if (value >= 1000) {
    final thousands = value / 1000;
    final formatted = thousands == thousands.roundToDouble()
        ? thousands.toStringAsFixed(0)
        : thousands.toStringAsFixed(1);
    return '$formatted ألف';
  }
  return value.toStringAsFixed(0);
}
