import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Placeholder image gallery using styled containers with icons.
///
/// Displays a main "image" and thumbnail strip below.
/// Will be replaced with real images (cached_network_image + Firebase Storage)
/// once the backend is set up.
class ImageGalleryPlaceholder extends StatefulWidget {
  /// Number of placeholder "images" to show.
  final int imageCount;

  const ImageGalleryPlaceholder({super.key, this.imageCount = 5});

  @override
  State<ImageGalleryPlaceholder> createState() =>
      _ImageGalleryPlaceholderState();
}

class _ImageGalleryPlaceholderState extends State<ImageGalleryPlaceholder> {
  int _selectedIndex = 0;

  /// Different icons for each "image" to add visual variety.
  static const _icons = [
    Icons.living_rounded,
    Icons.kitchen_rounded,
    Icons.bed_rounded,
    Icons.bathtub_rounded,
    Icons.balcony_rounded,
  ];

  static const _labels = [
    'الصالة',
    'المطبخ',
    'غرفة النوم',
    'الحمام',
    'البلكونة',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = widget.imageCount.clamp(1, _icons.length);

    return Column(
      children: [
        // ── Main Image ─────────────────────────────────────────
        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background pattern
              Icon(
                _icons[_selectedIndex],
                size: 120,
                color: AppColors.textOnPrimary.withValues(alpha: 0.1),
              ),
              // Foreground icon
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[_selectedIndex],
                    size: 56,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _labels[_selectedIndex],
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'صورة تجريبية — سيتم استبدالها لاحقاً',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),

              // Image counter badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_selectedIndex + 1} / $count',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Thumbnails ─────────────────────────────────────────
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)]
                          : [AppColors.primary.withValues(alpha: 0.15), AppColors.primary.withValues(alpha: 0.08)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Icon(
                    _icons[index],
                    size: 28,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
