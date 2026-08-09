import 'package:flutter/foundation.dart';

import '../models/picked_image.dart';

/// Contract implemented by admin form controllers that manage an image
/// gallery (units form and building form) so the shared images editor can
/// render either one.
abstract class ImageEditController implements Listenable {
  List<String> get visibleExistingUrls;

  List<PickedImage> get newImages;

  Future<void> pickImages();

  void removeExisting(String url);

  void removeNew(PickedImage image);
}
