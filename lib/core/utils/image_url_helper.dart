/// Sanitizes and converts common image share URLs (ImgBB, Google Drive, Dropbox, Imgur, PostImages)
/// into direct image CDN URLs suitable for `Image.network`.
String sanitizeImageUrl(String rawUrl) {
  var url = rawUrl.trim();
  if (url.isEmpty) return '';

  // Remove surrounding quotes if pasted with quotes
  if ((url.startsWith('"') && url.endsWith('"')) ||
      (url.startsWith("'") && url.endsWith("'"))) {
    url = url.substring(1, url.length - 1).trim();
  }

  // Add https:// if no scheme is provided
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }

  // 1. ImgBB conversion
  // E.g.: https://ibb.co/mF2PpKwF or https://ibb.co/mF2PpKwF/photo -> https://i.ibb.co/mF2PpKwF/image.jpg
  if (url.contains('ibb.co') && !url.contains('i.ibb.co')) {
    final ibbRegex = RegExp(r'ibb\.co\/([a-zA-Z0-9]+)');
    final match = ibbRegex.firstMatch(url);
    if (match != null) {
      final code = match.group(1);
      return 'https://i.ibb.co/$code/image.jpg';
    }
  }

  // 2. Google Drive conversion
  // E.g.: https://drive.google.com/file/d/FILE_ID/view?usp=sharing
  final driveFileRegex = RegExp(r'drive\.google\.com\/file\/d\/([^\/\?]+)');
  final driveMatch = driveFileRegex.firstMatch(url);
  if (driveMatch != null) {
    final fileId = driveMatch.group(1);
    return 'https://lh3.googleusercontent.com/d/$fileId';
  }

  // E.g.: https://drive.google.com/open?id=FILE_ID or uc?export=view&id=FILE_ID
  final driveIdRegex = RegExp(r'drive\.google\.com\/(?:open|uc)\?.*id=([^\&]+)');
  final driveIdMatch = driveIdRegex.firstMatch(url);
  if (driveIdMatch != null) {
    final fileId = driveIdMatch.group(1);
    return 'https://lh3.googleusercontent.com/d/$fileId';
  }

  // 3. Dropbox conversion
  // E.g.: https://www.dropbox.com/s/XYZ/photo.jpg?dl=0
  if (url.contains('dropbox.com')) {
    url = url
        .replaceAll('www.dropbox.com', 'dl.dropboxusercontent.com')
        .replaceAll('dropbox.com', 'dl.dropboxusercontent.com')
        .replaceAll('?dl=0', '')
        .replaceAll('?dl=1', '');
  }

  // 4. Imgur conversion
  // E.g.: https://imgur.com/XYZ -> https://i.imgur.com/XYZ.jpg
  if (url.contains('imgur.com') && !url.contains('i.imgur.com')) {
    final parts = url.split('/');
    final lastPart = parts.isNotEmpty ? parts.last : '';
    final id = lastPart.split('.').first;
    if (id.isNotEmpty) {
      return 'https://i.imgur.com/$id.jpg';
    }
  }

  // 5. PostImages conversion
  // E.g.: https://postimg.cc/XYZ -> https://i.postimg.cc/XYZ/image.jpg
  if (url.contains('postimg.cc') && !url.contains('i.postimg.cc')) {
    final parts = url.split('/');
    final id = parts.isNotEmpty ? parts.last : '';
    if (id.isNotEmpty) {
      return 'https://i.postimg.cc/$id/image.jpg';
    }
  }

  // 6. Cloudinary optimization
  // Automatically apply safe dimension cap (1600px) so phone camera raw uploads (e.g. 13MP / 4160px)
  // never exceed mobile WebGL texture size limits (which causes black textures on mobile).
  if (url.contains('res.cloudinary.com') && url.contains('/upload/')) {
    if (!url.contains('/upload/f_auto') && !url.contains('/upload/w_')) {
      url = url.replaceFirst(
        '/upload/',
        '/upload/f_auto,q_auto,w_1600,c_limit/',
      );
    }
  }

  return url;
}

/// Downsamples and optimizes image URLs for high-performance rendering.
///
/// For Cloudinary URLs, adjusts width transformation (e.g. w_650 for thumbnails, w_1600 for full preview)
/// so mobile browsers download lightweight WebP/AVIF images and stay well within GPU WebGL texture limits.
String optimizeImageUrl(String rawUrl, {int maxWidth = 650}) {
  final url = sanitizeImageUrl(rawUrl);
  if (url.isEmpty) return '';

  if (url.contains('res.cloudinary.com') && url.contains('/upload/')) {
    // If it already has our transformation, update width to the requested maxWidth
    final regex = RegExp(r'\/upload\/f_auto,q_auto,w_\d+,c_limit\/');
    if (regex.hasMatch(url)) {
      return url.replaceFirst(
        regex,
        '/upload/f_auto,q_auto,w_$maxWidth,c_limit/',
      );
    }
    if (!url.contains('/upload/f_auto') && !url.contains('/upload/w_')) {
      return url.replaceFirst(
        '/upload/',
        '/upload/f_auto,q_auto,w_$maxWidth,c_limit/',
      );
    }
  }

  return url;
}

