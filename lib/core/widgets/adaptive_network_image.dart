import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/image_url_helper.dart';

/// An adaptive network image widget that listens to the loaded image's natural
/// dimensions and scales its container to match the exact aspect ratio of the image.
///
/// This eliminates empty letterbox bars and side borders completely, while maintaining
/// min/max height bounds so portrait or super-wide photos remain elegantly proportioned.
class AdaptiveNetworkImage extends StatefulWidget {
  final String url;
  final double? targetHeight;
  final double minHeight;
  final double maxHeight;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AdaptiveNetworkImage({
    super.key,
    required this.url,
    this.targetHeight,
    this.minHeight = 220,
    this.maxHeight = 450,
    this.borderRadius,
    this.onTap,
    this.errorBuilder,
  });

  @override
  State<AdaptiveNetworkImage> createState() => _AdaptiveNetworkImageState();
}

class _AdaptiveNetworkImageState extends State<AdaptiveNetworkImage> {
  double? _aspectRatio;
  ImageStreamListener? _listener;
  ImageStream? _imageStream;

  @override
  void initState() {
    super.initState();
    _resolveImageDimensions();
  }

  @override
  void didUpdateWidget(AdaptiveNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _resolveImageDimensions();
    }
  }

  void _resolveImageDimensions() {
    final cleanUrl = sanitizeImageUrl(widget.url);
    if (cleanUrl.isEmpty) return;

    final imageProvider = NetworkImage(cleanUrl);
    final oldStream = _imageStream;
    _imageStream = imageProvider.resolve(const ImageConfiguration());

    if (_imageStream?.key != oldStream?.key) {
      if (_listener != null && oldStream != null) {
        oldStream.removeListener(_listener!);
      }

      _listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (!mounted) return;
          final width = info.image.width.toDouble();
          final height = info.image.height.toDouble();
          if (width > 0 && height > 0) {
            setState(() {
              _aspectRatio = width / height;
            });
          }
        },
        onError: (exception, stackTrace) {
          // Keep fallback ratio on error
        },
      );

      _imageStream!.addListener(_listener!);
    }
  }

  @override
  void dispose() {
    if (_listener != null && _imageStream != null) {
      _imageStream!.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cleanUrl = sanitizeImageUrl(widget.url);
    final theme = Theme.of(context);
    final radius = widget.borderRadius ?? BorderRadius.circular(24);

    // Default fallback aspect ratio if image isn't loaded yet (16/9)
    final ratio = _aspectRatio ?? (16 / 9);

    final imageWidget = Image.network(
      cleanUrl,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: widget.errorBuilder ??
          (_, _, _) => Container(
                color: AppColors.surface,
                child: const Center(
                  child: Icon(Icons.broken_image_rounded,
                      color: AppColors.textSecondary),
                ),
              ),
    );

    // Fixed height mode (e.g. for horizontal gallery list): width adjusts dynamically to natural AR!
    if (widget.targetHeight != null) {
      final computedWidth = widget.targetHeight! * ratio;
      return GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox(
            height: widget.targetHeight,
            width: computedWidth,
            child: imageWidget,
          ),
        ),
      );
    }

    // Dynamic height mode with min/max bounds (e.g. for main hero cover photo):
    return GestureDetector(
      onTap: widget.onTap,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            minHeight: widget.minHeight,
            maxHeight: widget.maxHeight,
          ),
          child: AspectRatio(
            aspectRatio: ratio,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.45),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageWidget,
                  // Fullscreen hint badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fullscreen_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'عرض الصورة بالكامل',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
