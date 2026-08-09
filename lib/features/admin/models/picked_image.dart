import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// A locally picked image (file handle + decoded bytes) awaiting upload.
class PickedImage {
  final XFile file;
  final Uint8List bytes;

  PickedImage(this.file, this.bytes);
}
