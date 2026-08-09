import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/image_edit_controller.dart';

/// Image picker grid shared by the units form and the building form: existing
/// (network) images with remove badges, newly picked (memory) images, and an
/// "add photo" tile.
class PropertyImagesEditor extends StatelessWidget {
  final ImageEditController controller;

  const PropertyImagesEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final url in controller.visibleExistingUrls) {
      children.add(_tile(
        Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(url, fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _removeBadge(
                onTap: () => controller.removeExisting(url),
              ),
            ),
          ],
        ),
      ));
    }

    for (final image in controller.newImages) {
      children.add(_tile(
        Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(image.bytes, fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _removeBadge(
                onTap: () => controller.removeNew(image),
              ),
            ),
          ],
        ),
      ));
    }

    if (children.length < 10) {
      children.add(_tile(
        InkWell(
          onTap: controller.pickImages,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.divider,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.add_a_photo_rounded,
              color: AppColors.accent,
              size: 28,
            ),
          ),
        ),
      ));
    }

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: children,
    );
  }

  Widget _tile(Widget child) {
    return AspectRatio(
      aspectRatio: 1,
      child: child,
    );
  }

  Widget _removeBadge({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.error,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 14,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}
