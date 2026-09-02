import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_url_helper.dart';
import '../models/admin_building.dart';

/// Compact row card for a single building on the admin dashboard.
class AdminBuildingCard extends StatelessWidget {
  final AdminBuilding building;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const AdminBuildingCard({
    super.key,
    required this.building,
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
            width: isMobile ? 74 : 80,
            height: isMobile ? 74 : 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (building.imageUrls.isNotEmpty)
                  Image.network(
                    sanitizeImageUrl(building.imageUrls.first),
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
                          Icons.business_rounded,
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
                if (building.imageUrls.length > 1)
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
                        '${building.imageUrls.length} صور',
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
                    color: Colors.purple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'عمارة',
                    style: TextStyle(
                      color: Colors.purple,
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
                    building.area,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!building.isPublished)
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
              building.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              building.description.isNotEmpty
                  ? building.description
                  : building.area,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
            if (building.startingPrice > 0) ...[
              const SizedBox(height: 4),
              Text(
                building.formattedStartingPrice,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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
                      building.isPublished ? 'منشور' : 'مخفي',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: building.isPublished
                            ? AppColors.accent
                            : AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: building.isPublished,
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
                value: building.isPublished,
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
