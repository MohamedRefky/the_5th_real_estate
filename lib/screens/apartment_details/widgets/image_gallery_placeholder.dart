import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Ultra-premium placeholder image gallery with room navigation.
class ImageGalleryPlaceholder extends StatefulWidget {
  final int imageCount;

  const ImageGalleryPlaceholder({super.key, this.imageCount = 5});

  @override
  State<ImageGalleryPlaceholder> createState() =>
      _ImageGalleryPlaceholderState();
}

class _ImageGalleryPlaceholderState extends State<ImageGalleryPlaceholder> {
  int _selectedIndex = 0;

  static const _icons = [
    Icons.living_rounded,
    Icons.kitchen_rounded,
    Icons.bed_rounded,
    Icons.bathtub_rounded,
    Icons.balcony_rounded,
  ];

  static const _labels = [
    'الريسبشن / الصالة',
    'المطبخ الرئيسي',
    'غرفة النوم الماستر',
    'الحمام الرئيسي',
    'التراس والفيو',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = widget.imageCount.clamp(1, _icons.length);

    return Column(
      children: [
        // ── Main Image Box ─────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 480,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle background icon
              Icon(
                _icons[_selectedIndex],
                size: 160,
                color: AppColors.textPrimary.withValues(alpha: 0.07),
              ),

              // Room info
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey(_selectedIndex),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Icon(
                        _icons[_selectedIndex],
                        size: 52,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _labels[_selectedIndex],
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'معاينة افتراضية للتصميم الداخلي',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Image counter badge
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    '${_selectedIndex + 1} / $count',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Thumbnails Strip ───────────────────────────────────
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 76,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppColors.accentGradient
                        : LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    _icons[index],
                    size: 28,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textSecondary,
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
