import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Apartment walkthrough video placeholder.
///
/// Reserves a premium 16:9 spot for the listing video. When [videoUrl] is
/// provided the box signals the video is ready to play; otherwise it shows a
/// "video coming soon" state. Actual playback can be wired later.
class VideoPlaceholder extends StatelessWidget {
  final String? videoUrl;

  const VideoPlaceholder({super.key, this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasVideo = videoUrl != null && videoUrl!.isNotEmpty;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF070D18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.45),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.15),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Dark gradient backdrop with grid accent
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.08),
                    const Color(0xFF050911),
                  ],
                ),
              ),
            ),

            // Big translucent play watermark
            Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 190,
                color: AppColors.accent.withValues(alpha: 0.08),
              ),
            ),

            // Center play button with gold metallic halo
            Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.videocam_rounded, color: AppColors.accent),
                          SizedBox(width: 10),
                          Text('جاري تجهيز مشغل فيديو 4K المعاينة المباشرة...'),
                        ],
                      ),
                      backgroundColor: AppColors.surface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.45),
                        blurRadius: 28,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 46,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),

            // Top quality badge
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.high_quality_rounded,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '4K Ultra HD Walkthrough',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom note
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Text(
                  hasVideo
                      ? 'اضغط لتشغيل فيديو المعاينة المباشرة'
                      : 'اضغط للتشغيل عند تفعيل فيديو الشقة',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
