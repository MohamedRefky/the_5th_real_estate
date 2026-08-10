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

  return url;
}
