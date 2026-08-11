library;

import '../../../models/apartment.dart';
import '../../../core/utils/image_url_helper.dart';

/// Structured building listing model matching the Firestore
/// `buildings/{area}/units` subcollections managed by the admin dashboard.
///
/// Finishing status reuses the public [FinishingStatus] so it maps 1:1 onto
/// the website building card/details without conversion.

class AdminBuilding {
  final String? id;

  /// Building name (e.g. "عمارة كاملة في جاردينيا هايتس ٣ حرف أ").
  final String name;

  /// Description of the building and project.
  final String description;

  /// Neighborhood this building belongs to.
  final String area;

  /// Plot / total land area in square meters.
  final double? areaSqm;

  /// Built structure description (e.g., "بيزمنت + أرضي + أول").
  final String? buildingStructure;

  /// Frontage / orientation (e.g., "دبل فيس").
  final String? orientation;

  /// Floor layout suitability note (e.g., "الدور ينفع شقتين").
  final String? layoutNote;

  /// Starting price or total building price in EGP.
  final double startingPrice;

  /// Total floors.
  final int totalFloors;

  /// Total apartments/units.
  final int totalUnits;

  /// Available units count for sale.
  final int availableUnits;

  /// Construction finishing status for units.
  final FinishingStatus finishingStatus;

  /// Whether the building is still under construction.
  final bool isUnderConstruction;

  /// Expected delivery date.
  final DateTime? deliveryDate;

  /// Construction progress (0.0 to 1.0).
  final double constructionProgress;

  /// WhatsApp contact number.
  final String whatsappNumber;

  /// Key building amenities.
  final List<String> amenities;

  /// Image URLs — the first one is used as the cover/facade.
  final List<String> imageUrls;

  /// Optional video tour URL (e.g. YouTube / Vimeo / MP4).
  final String? videoUrl;

  /// Whether the listing is published on the website.
  final bool isPublished;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminBuilding({
    this.id,
    required this.name,
    required this.description,
    required this.area,
    this.areaSqm,
    this.buildingStructure,
    this.orientation,
    this.layoutNote,
    required this.startingPrice,
    required this.totalFloors,
    required this.totalUnits,
    required this.availableUnits,
    required this.finishingStatus,
    this.isUnderConstruction = false,
    this.deliveryDate,
    this.constructionProgress = 1.0,
    required this.whatsappNumber,
    this.amenities = const [],
    this.imageUrls = const [],
    this.videoUrl,
    this.isPublished = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Formatted starting price string in Egyptian Pounds.
  String get formattedStartingPrice {
    if (startingPrice >= 1000000) {
      final millions = startingPrice / 1000000;
      if (millions == millions.roundToDouble()) {
        return '${millions.toStringAsFixed(0)} مليون جنيه';
      }
      final wholeMillions = startingPrice ~/ 1000000;
      final thousands = ((startingPrice % 1000000) / 1000).round();
      if (thousands > 0) {
        return '$wholeMillions مليون و $thousands ألف جنيه';
      }
      return '$wholeMillions مليون جنيه';
    }
    final thousands = (startingPrice / 1000).toStringAsFixed(0);
    return '$thousands ألف جنيه';
  }

  /// Facade / main image — always the first image in [imageUrls].
  /// Stored separately in Firestore so facade and interior photos never mix.
  String? get facadeImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : null;

  /// The rest of the building images (interior, floors, amenities, ...).
  List<String> get detailImageUrls =>
      imageUrls.length > 1 ? imageUrls.sublist(1) : const <String>[];

  AdminBuilding copyWith({
    String? id,
    String? name,
    String? description,
    String? area,
    double? areaSqm,
    String? buildingStructure,
    String? orientation,
    String? layoutNote,
    double? startingPrice,
    int? totalFloors,
    int? totalUnits,
    int? availableUnits,
    FinishingStatus? finishingStatus,
    bool? isUnderConstruction,
    DateTime? deliveryDate,
    double? constructionProgress,
    String? whatsappNumber,
    List<String>? amenities,
    List<String>? imageUrls,
    String? videoUrl,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminBuilding(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      area: area ?? this.area,
      areaSqm: areaSqm ?? this.areaSqm,
      buildingStructure: buildingStructure ?? this.buildingStructure,
      orientation: orientation ?? this.orientation,
      layoutNote: layoutNote ?? this.layoutNote,
      startingPrice: startingPrice ?? this.startingPrice,
      totalFloors: totalFloors ?? this.totalFloors,
      totalUnits: totalUnits ?? this.totalUnits,
      availableUnits: availableUnits ?? this.availableUnits,
      finishingStatus: finishingStatus ?? this.finishingStatus,
      isUnderConstruction: isUnderConstruction ?? this.isUnderConstruction,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      constructionProgress: constructionProgress ?? this.constructionProgress,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      amenities: amenities ?? this.amenities,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore({bool isUpdate = false}) {
    final now = DateTime.now();
    return {
      'name': name,
      'description': description,
      'area': area,
      'areaSqm': areaSqm,
      'buildingStructure': buildingStructure,
      'orientation': orientation,
      'layoutNote': layoutNote,
      'startingPrice': startingPrice,
      'totalFloors': totalFloors,
      'totalUnits': totalUnits,
      'availableUnits': availableUnits,
      'finishingStatus': finishingStatus.name,
      'isUnderConstruction': isUnderConstruction,
      'deliveryDate': deliveryDate,
      'constructionProgress': constructionProgress,
      'whatsappNumber': whatsappNumber,
      'amenities': amenities,
      'imageUrls': imageUrls,
      'facadeImageUrl': facadeImageUrl,
      'detailImageUrls': detailImageUrls,
      'videoUrl': videoUrl,
      'isPublished': isPublished,
      'createdAt': isUpdate ? (createdAt ?? now) : now,
      'updatedAt': now,
    };
  }

  factory AdminBuilding.fromFirestore(
    String docId,
    Map<String, dynamic> data, {
    String? fallbackArea,
  }) {
    final rawArea = (data['area'] as String?) ?? fallbackArea ?? '';

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
    // Detail / interior images.
    addImage(data['detailImageUrls']);
    addImage(data['additionalImageUrls']);
    addImage(data['gallery']);
    addImage(data['galleryUrls']);
    // Legacy fallbacks.
    addImage(data['photo']);
    addImage(data['photos']);

    return AdminBuilding(
      id: docId,
      name: (data['name'] as String?)?.trim() ??
          (data['projectName'] as String?)?.trim() ??
          (data['title'] as String?)?.trim() ??
          '',
      description: (data['description'] as String?)?.trim() ??
          (data['details'] as String?)?.trim() ??
          '',
      area: rawArea,
      areaSqm: (data['areaSqm'] as num?)?.toDouble(),
      buildingStructure: data['buildingStructure'] as String?,
      orientation: data['orientation'] as String?,
      layoutNote: data['layoutNote'] as String?,
      startingPrice: ((data['startingPrice'] as num?) ?? 0).toDouble(),
      totalFloors: (data['totalFloors'] as num?)?.toInt() ?? 1,
      totalUnits: (data['totalUnits'] as num?)?.toInt() ?? 0,
      availableUnits: (data['availableUnits'] as num?)?.toInt() ?? 0,
      finishingStatus: FinishingStatus.values.firstWhere(
        (e) => e.name == data['finishingStatus'],
        orElse: () => FinishingStatus.semiFinished,
      ),
      isUnderConstruction: (data['isUnderConstruction'] as bool?) ?? false,
      deliveryDate: _readDate(data['deliveryDate']),
      constructionProgress:
          ((data['constructionProgress'] as num?)?.toDouble()) ?? 1.0,
      whatsappNumber: (data['whatsappNumber'] as String?) ?? '',
      amenities: ((data['amenities'] as List?) ?? const [])
          .map((e) => e as String)
          .toList(),
      imageUrls: parsedImages,
      videoUrl: data['videoUrl'] as String?,
      isPublished: (data['isPublished'] as bool?) ?? true,
      createdAt: _readDate(data['createdAt']),
      updatedAt: _readDate(data['updatedAt']),
    );
  }

  /// Reads a Firestore Timestamp (or a plain [DateTime], e.g. in tests).
  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}
