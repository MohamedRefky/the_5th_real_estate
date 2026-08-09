import 'apartment.dart';

/// Core data model for a residential building listing.
class Building {
  /// Unique identifier (Firestore doc ID).
  final String id;

  /// Building name (e.g. "عمارة جاردينيا هايتس ١").
  final String name;

  /// Description of the building and project.
  final String description;

  /// Neighborhood name (e.g. "جاردينيا").
  final String area;

  /// Starting price for units in this building in EGP.
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

  /// Construction timeline milestones.
  final List<ConstructionMilestone> milestones;

  /// WhatsApp contact number.
  final String whatsappNumber;

  /// Key building amenities (e.g. "مصعد", "جراج خاص", "كاميرات مراقبة").
  final List<String> amenities;

  /// Image URLs — unified gallery (Firebase Storage).
  /// The first image is used as the cover/facade.
  final List<String> imageUrls;

  /// Timestamp when this listing was created.
  final DateTime? createdAt;

  /// Timestamp when this listing was last updated.
  final DateTime? updatedAt;

  const Building({
    required this.id,
    required this.name,
    required this.description,
    required this.area,
    required this.startingPrice,
    required this.totalFloors,
    required this.totalUnits,
    required this.availableUnits,
    required this.finishingStatus,
    this.isUnderConstruction = false,
    this.deliveryDate,
    this.constructionProgress = 1.0,
    this.milestones = const [],
    required this.whatsappNumber,
    this.amenities = const [],
    this.imageUrls = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// The first image URL, used as cover/facade. Null if no images.
  String? get coverImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Formatted starting price string.
  String get formattedStartingPrice {
    if (startingPrice >= 1000000) {
      final millions = startingPrice / 1000000;
      final formatted = millions == millions.roundToDouble()
          ? millions.toStringAsFixed(0)
          : millions.toStringAsFixed(1);
      return 'تبدأ من $formatted مليون جنيه';
    }
    final thousands = (startingPrice / 1000).toStringAsFixed(0);
    return 'تبدأ من $thousands ألف جنيه';
  }

  /// Delivery date formatted in Arabic.
  String? get formattedDeliveryDate {
    if (deliveryDate == null) return null;
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${months[deliveryDate!.month - 1]} ${deliveryDate!.year}';
  }

  /// Serialize to Firestore-compatible map.
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'area': area,
        'startingPrice': startingPrice,
        'totalFloors': totalFloors,
        'totalUnits': totalUnits,
        'availableUnits': availableUnits,
        'finishingStatus': finishingStatus.name,
        'isUnderConstruction': isUnderConstruction,
        'deliveryDate': deliveryDate?.toIso8601String(),
        'constructionProgress': constructionProgress,
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'whatsappNumber': whatsappNumber,
        'amenities': amenities,
        'imageUrls': imageUrls,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// Deserialize from Firestore document.
  factory Building.fromJson(Map<String, dynamic> json, {String? id}) {
    return Building(
      id: id ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      area: json['area'] as String? ?? '',
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0,
      totalFloors: json['totalFloors'] as int? ?? 1,
      totalUnits: json['totalUnits'] as int? ?? 0,
      availableUnits: json['availableUnits'] as int? ?? 0,
      finishingStatus: FinishingStatus.values.firstWhere(
        (e) => e.name == json['finishingStatus'],
        orElse: () => FinishingStatus.semiFinished,
      ),
      isUnderConstruction: json['isUnderConstruction'] as bool? ?? false,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.tryParse(json['deliveryDate'] as String)
          : null,
      constructionProgress:
          (json['constructionProgress'] as num?)?.toDouble() ?? 1.0,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((m) =>
                  ConstructionMilestone.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}
