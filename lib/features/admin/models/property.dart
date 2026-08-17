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

  static UnitType fromLabel(String label) {
    final trimmed = label.trim();
    if (trimmed == 'عمارة') return UnitType.building;
    if (trimmed == 'دوبلكس') return UnitType.duplex;
    if (trimmed == 'فيلا') return UnitType.villa;
    if (trimmed == 'استوديو') return UnitType.studio;
    return values.firstWhere(
      (v) => v.label == trimmed || v.name == trimmed,
      orElse: () => UnitType.apartment,
    );
  }
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
    final trimmed = label.trim();
    return values
        .where((v) => v.label == trimmed || v.name == trimmed)
        .firstOrNull;
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

  static PropertyFinishing fromLabel(String label) {
    final trimmed = label.trim();
    return values
        .where((v) => v.label == trimmed || v.name == trimmed)
        .firstOrNull ??
        PropertyFinishing.shell;
  }
}

/// Payment terms for the listing price.
enum PriceNote {
  cash('كاش'),
  meter('كاش بالعداد'),
  negotiable('كاش وقابل للتفاوض');

  final String label;
  const PriceNote(this.label);

  static PriceNote? fromLabel(String? label) {
    if (label == null) return null;
    final trimmed = label.trim();
    if (trimmed == 'بالعداد' || trimmed == 'كاش بالعداد') return PriceNote.meter;
    if (trimmed == 'قابل للتفاوض' || trimmed == 'كاش وقابل للتفاوض') return PriceNote.negotiable;
    return values
        .where((v) => v.label == trimmed || v.name == trimmed)
        .firstOrNull;
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
  'الأندلس 1 و 2',
  'الأندلس عائلي',
  'جاردينيا',
  'بيت الوطن',
  'النرجس الجديدة',
  'النرجس عمارات',
  'النرجس فيلات',
  'البنفسج عمارات',
  'البنفسج فيلات',
  'الياسمين الزوجي فيلات',
  'الياسمين الفردي فيلات',
];

class Property {
  final String? id;

  final String projectName;
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

  /// Optional asking price in US Dollars, separate from the EGP [price].
  final double? priceUsd;

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
    this.priceUsd,
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
    double? priceUsd,
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
      priceUsd: priceUsd ?? this.priceUsd,
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

  /// Facade / main image — always the first image in [imageUrls].
  /// Stored separately in Firestore so facade and interior photos never mix.
  String? get facadeImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : null;

  /// The rest of the apartment images (interior, rooms, kitchen, ...).
  List<String> get detailImageUrls =>
      imageUrls.length > 1 ? imageUrls.sublist(1) : const <String>[];

  Map<String, dynamic> toFirestore({bool isUpdate = false}) {
    final now = DateTime.now();
    return {
      'projectName': projectName,
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
      'priceUsd': priceUsd,
      'description': description,
      'imageUrls': imageUrls,
      'imageUrl': imageUrls.firstOrNull,
      'facadeImageUrl': facadeImageUrl,
      'detailImageUrls': detailImageUrls,
      'videoUrl': videoUrl,
      'createdAt': isUpdate ? (createdAt ?? now) : now,
      'updatedAt': now,
      'isPublished': isPublished,
      'area': area,
    };
  }

  factory Property.fromFirestore(
    String docId,
    Map<String, dynamic> data, {
    String? fallbackArea,
  }) {
    final List<String> parsedImages = [];

    void addImage(dynamic value) {
      if (value == null) return;
      if (value is List) {
        for (final item in value) {
          addImage(item);
        }
      } else if (value is String) {
        final cleaned = sanitizeImageUrl(value);
        if (cleaned.isNotEmpty && !parsedImages.contains(cleaned)) {
          parsedImages.add(cleaned);
        }
      }
    }

    // Facade / main image comes first so it becomes the website cover.
    addImage(data['facadeImageUrl']);
    addImage(data['mainImageUrl']);
    addImage(data['coverImageUrl']);
    addImage(data['coverUrl']);
    // Combined gallery (legacy documents).
    addImage(data['imageUrls']);
    addImage(data['imageUrl']);
    addImage(data['images']);
    // Detail / interior images (facade vs rest of the apartment).
    addImage(data['detailImageUrls']);
    addImage(data['additionalImageUrls']);
    addImage(data['gallery']);
    addImage(data['galleryUrls']);
    // Legacy fallbacks.
    addImage(data['photo']);
    addImage(data['photos']);

    final rawVideoUrl = (data['videoUrl'] as String?) ?? (data['video'] as String?);

    final nameVal = (data['projectName'] as String?)?.trim() ??
        (data['name'] as String?)?.trim() ??
        (data['title'] as String?)?.trim();
    final rawName = (nameVal != null && nameVal.isNotEmpty) ? nameVal : 'شقة جديدة';

    final rawPrice = ((data['price'] as num?) ??
            (data['startingPrice'] as num?) ??
            (data['totalPrice'] as num?) ??
            0)
        .toDouble();

    final rawDesc = (data['description'] as String?) ??
        (data['details'] as String?);

    final areaVal = (data['area'] as String?)?.trim();
    final neighVal = (data['neighborhood'] as String?)?.trim();
    final areaNameVal = (data['areaName'] as String?)?.trim();

    final rawArea = (areaVal != null && areaVal.isNotEmpty)
        ? areaVal
        : (neighVal != null && neighVal.isNotEmpty)
            ? neighVal
            : (areaNameVal != null && areaNameVal.isNotEmpty)
                ? areaNameVal
                : (fallbackArea != null && fallbackArea.trim().isNotEmpty)
                    ? fallbackArea.trim()
                    : areaOptions.first;

    return Property(
      id: docId,
      projectName: rawName,
      unitType: UnitType.fromLabel(data['unitType'] as String? ?? ''),
      floor: _normalizeFloor(data['floor'] as String?),
      orientation: PropertyOrientation.fromLabel(data['orientation'] as String?),
      areaSqm: ((data['areaSqm'] as num?) ?? 0).toDouble(),
      bedrooms: (data['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (data['bathrooms'] as num?)?.toInt() ?? 0,
      hasReception: (data['hasReception'] as bool?) ?? false,
      hasKitchen: (data['hasKitchen'] as bool?) ?? false,
      finishingStatus:
          PropertyFinishing.fromLabel(data['finishingStatus'] as String? ?? ''),
      price: rawPrice,
      priceNote: PriceNote.fromLabel(data['priceNote'] as String?),
      priceUsd: (data['priceUsd'] as num?)?.toDouble(),
      description: rawDesc,
      imageUrls: parsedImages,
      videoUrl: rawVideoUrl != null && rawVideoUrl.trim().isNotEmpty
          ? rawVideoUrl.trim()
          : null,
      createdAt: _readDate(data['createdAt']),
      updatedAt: _readDate(data['updatedAt']),
      isPublished: (data['isPublished'] as bool?) ?? true,
      area: normalizeArea(rawArea),
    );
  }

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    try {
      return (value as dynamic).toDate() as DateTime?;
    } catch (_) {
      return null;
    }
  }
}

String _normalizeFloor(String? rawFloor) {
  if (rawFloor == null || rawFloor.trim().isEmpty) return 'أرضي';
  final trimmed = rawFloor.trim();
  if (floorOptions.contains(trimmed)) return trimmed;

  if (trimmed == 'ثاني') return 'تاني';
  if (trimmed == 'ثالث') return 'تالت';
  if (trimmed == 'الارضي' || trimmed == 'الأرضى') return 'أرضي';
  if (trimmed == 'الاول' || trimmed == 'الأول') return 'أول';
  if (trimmed == 'الثاني' || trimmed == 'الثانى') return 'تاني';
  if (trimmed == 'الثالث') return 'تالت';
  if (trimmed == 'الرابع') return 'رابع';
  if (trimmed == 'الخامس') return 'خامس';

  for (final option in floorOptions) {
    if (trimmed.contains(option)) return option;
  }
  return trimmed;
}

/// Maps free-text area names onto the canonical [areaOptions] folder names so
/// documents always land in the folder the website reads. Shared by both the
/// property and building models.
String normalizeArea(String? rawArea) {
  if (rawArea == null || rawArea.trim().isEmpty) return areaOptions.first;
  final trimmed = rawArea.trim();
  if (areaOptions.contains(trimmed)) return trimmed;

  if (trimmed.contains('جارد') || trimmed.contains('gardenia')) return 'جاردينيا';
  if (trimmed.contains('بيت الوطن') || trimmed.contains('بيت_الوطن')) return 'بيت الوطن';
  if (trimmed.contains('أندلس') || trimmed.contains('اندلس')) return 'الأندلس 1 و 2';
  if (trimmed.contains('نرجس جديدة') || trimmed.contains('نرجس الجديدة')) return 'النرجس الجديدة';
  if (trimmed.contains('نرجس')) return 'النرجس عمارات';
  if (trimmed.contains('مستثمرين')) return 'المستثمرين';
  if (trimmed.contains('بنفسج')) return 'البنفسج عمارات';
  if (trimmed.contains('ياسمين')) return 'الياسمين الزوجي فيلات';

  return trimmed;
}
