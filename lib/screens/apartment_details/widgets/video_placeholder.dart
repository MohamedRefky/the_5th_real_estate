import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Big translucent play watermark
            Center(
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 180,
                color: AppColors.accent.withValues(alpha: 0.10),
              ),
            ),

            // Center play button
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 40,
                  color: AppColors.accent,
                ),
              ),
            ),

            // Top label
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.videocam_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasVideo ? 'فيديو جاهز للعرض' : 'فيديو معاينة الشقة',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom note
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  hasVideo
                      ? 'اضغط للتشغيل'
                      : 'سيتم إضافة فيديو المعاينة قريبًا',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
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
