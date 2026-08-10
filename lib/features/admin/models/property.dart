/// Structured property listing model matching the Firestore `properties`
/// collection. This is the schema the hidden admin dashboard manages.
///
/// All enums are stored in Firestore as their Arabic label (matching the
/// public website UI). Prices/areas are plain numbers so they can be sorted
/// and filtered server-side.
library;

import '../../../core/utils/image_url_helper.dart';

/// Unit types a listing can be.
enum UnitType {
  apartment('شقة'),
  duplex('دوبلكس'),
  villa('فيلا'),
  studio('استوديو'),
  building('عماره');

  final String label;
  const UnitType(this.label);

  static UnitType fromLabel(String label) =>
      values.firstWhere((v) => v.label == label, orElse: () => UnitType.apartment);
}

/// Orientation of the unit relative to the street.
enum PropertyOrientation {
  front('أمامي'),
  rear('خلفي'),
  side('جانبي');

  final String label;
  const PropertyOrientation(this.label);

  static PropertyOrientation? fromLabel(String? label) {
    if (label == null) return null;
    return values.where((v) => v.label == label).firstOrNull;
  }
}

/// Finishing / delivery status of the unit.
enum PropertyFinishing {
  shell('بدون تشطيب'),
  semi('نص تشطيب'),
  threeQuarter('٣_٤ تشطيب'),
  finished('تشطيب كامل'),
  superLux('سوبر لوكس');

  final String label;
  const PropertyFinishing(this.label);

  static PropertyFinishing fromLabel(String label) => values
      .where((v) => v.label == label)
      .firstOrNull ??
      PropertyFinishing.shell;
}

/// Payment terms for the listing price.
enum PriceNote {
  cash('كاش'),
  meter('بالعداد'),
  negotiable('قابل للتفاوض');

  final String label;
  const PriceNote(this.label);

  static PriceNote? fromLabel(String? label) {
    if (label == null) return null;
    return values.where((v) => v.label == label).firstOrNull;
  }
}

/// Floor options offered in the dropdown (each floor is its own document).
const List<String> floorOptions = [
  'بيزمنت',
  'أرضي',
  'أول',
  'تاني',
  'تالت',
  'رابع',
  'خامس',
  'روف',
];

/// Neighborhood options for the admin form (mirrors the public site areas).
const List<String> areaOptions = [
  'المستثمرين',
  'الأندلس',
  'جاردينيا',
  'بيت الوطن',
  'النرجس الجديدة',
];

class Property {
  final String? id;

  final String projectName;
  final String? buildingLabel;
  final UnitType unitType;
  final String floor;
  final PropertyOrientation? orientation;
  final double areaSqm;
  final int bedrooms;
  final int bathrooms;
  final bool hasReception;
  final bool hasKitchen;
  final PropertyFinishing finishingStatus;
  final double price;
  final PriceNote? priceNote;
  final String? description;
  final List<String> imageUrls;
  final String? videoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isPublished;

  /// Neighborhood this listing belongs to (see [areaOptions]).
  final String area;

  const Property({
    this.id,
    required this.projectName,
    this.buildingLabel,
    required this.unitType,
    required this.floor,
    this.orientation,
    required this.areaSqm,
    required this.bedrooms,
    required this.bathrooms,
    required this.hasReception,
    required this.hasKitchen,
    required this.finishingStatus,
    required this.price,
    this.priceNote,
    this.description,
    this.imageUrls = const [],
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
    this.isPublished = true,
    this.area = 'المستثمرين',
  });

  Property copyWith({
    String? id,
    String? projectName,
    String? buildingLabel,
    UnitType? unitType,
    String? floor,
    PropertyOrientation? orientation,
    double? areaSqm,
    int? bedrooms,
    int? bathrooms,
    bool? hasReception,
    bool? hasKitchen,
    PropertyFinishing? finishingStatus,
    double? price,
    PriceNote? priceNote,
    String? description,
    List<String>? imageUrls,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    String? area,
  }) {
    return Property(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      buildingLabel: buildingLabel ?? this.buildingLabel,
      unitType: unitType ?? this.unitType,
      floor: floor ?? this.floor,
      orientation: orientation ?? this.orientation,
      areaSqm: areaSqm ?? this.areaSqm,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      hasReception: hasReception ?? this.hasReception,
      hasKitchen: hasKitchen ?? this.hasKitchen,
      finishingStatus: finishingStatus ?? this.finishingStatus,
      price: price ?? this.price,
      priceNote: priceNote ?? this.priceNote,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      area: area ?? this.area,
    );
  }

  /// Formatted EGP price for display.
  String get formattedPrice {
    if (price >= 1000000) {
      final millions = price / 1000000;
      final formatted = millions == millions.roundToDouble()
          ? millions.toStringAsFixed(0)
          : millions.toStringAsFixed(1);
      return '$formatted مليون ج';
    }
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)} ألف ج';
    }
    return '${price.toStringAsFixed(0)} ج';
  }

  Map<String, dynamic> toFirestore({bool isUpdate = false}) {
    final now = DateTime.now();
    return {
      'projectName': projectName,
      'buildingLabel': buildingLabel,
      'unitType': unitType.label,
      'floor': floor,
      'orientation': orientation?.label,
      'areaSqm': areaSqm,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'hasReception': hasReception,
      'hasKitchen': hasKitchen,
      'finishingStatus': finishingStatus.label,
      'price': price,
      'priceNote': priceNote?.label,
      'description': description,
      'imageUrls': imageUrls,
      'imageUrl': imageUrls.firstOrNull,
      'videoUrl': videoUrl,
      'createdAt': isUpdate ? (createdAt ?? now) : now,
      'updatedAt': now,
      'isPublished': isPublished,
      'area': area,
    };
  }

  factory Property.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    final rawImages = data['imageUrls'] ??
        data['imageUrl'] ??
        data['images'] ??
        data['photo'] ??
        data['photos'];

    final List<String> parsedImages = [];
    if (rawImages is List) {
      for (final e in rawImages) {
        if (e != null) {
          final cleaned = sanitizeImageUrl(e.toString());
          if (cleaned.isNotEmpty) parsedImages.add(cleaned);
        }
      }
    } else if (rawImages is String && rawImages.trim().isNotEmpty) {
      final cleaned = sanitizeImageUrl(rawImages);
      if (cleaned.isNotEmpty) parsedImages.add(cleaned);
    }

    final rawVideoUrl = (data['videoUrl'] as String?) ?? (data['video'] as String?);

    return Property(
      id: docId,
      projectName: (data['projectName'] as String?) ?? '',
      buildingLabel: data['buildingLabel'] as String?,
      unitType: UnitType.fromLabel(data['unitType'] as String? ?? ''),
      floor: (data['floor'] as String?) ?? 'أرضي',
      orientation: PropertyOrientation.fromLabel(data['orientation'] as String?),
      areaSqm: ((data['areaSqm'] as num?) ?? 0).toDouble(),
      bedrooms: (data['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (data['bathrooms'] as num?)?.toInt() ?? 0,
      hasReception: (data['hasReception'] as bool?) ?? false,
      hasKitchen: (data['hasKitchen'] as bool?) ?? false,
      finishingStatus:
          PropertyFinishing.fromLabel(data['finishingStatus'] as String? ?? ''),
      price: ((data['price'] as num?) ?? 0).toDouble(),
      priceNote: PriceNote.fromLabel(data['priceNote'] as String?),
      description: data['description'] as String?,
      imageUrls: parsedImages,
      videoUrl: rawVideoUrl != null && rawVideoUrl.trim().isNotEmpty
          ? rawVideoUrl.trim()
          : null,
      createdAt: (data['createdAt'] as dynamic)?.toDate(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate(),
      isPublished: (data['isPublished'] as bool?) ?? true,
      area: (data['area'] as String?) ?? areaOptions.first,
    );
  }
}
