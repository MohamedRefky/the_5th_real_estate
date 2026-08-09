import 'apartment.dart';
import '../core/utils/formatters.dart';

/// Core data model for a residential building listing.
class Building {
  /// Unique identifier (Firestore doc ID).
  final String id;

  /// Building name (e.g. "عمارة كاملة في جاردينيا هايتس ٣ حرف أ").
  final String name;

  /// Description of the building and project.
  final String description;

  /// Neighborhood name (e.g. "جاردينيا").
  final String area;

  /// Plot / total land area in square meters (e.g., 286).
  final double? areaSqm;

  /// Built structure description (e.g., "مبنية بيزمنت وأرضي وأول").
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

  /// Formatted price string in Egyptian Pounds.
  String get formattedStartingPrice {
    if (startingPrice >= 1000000) {
      final millions = startingPrice / 1000000;
      if (millions == millions.roundToDouble()) {
        return '${millions.toStringAsFixed(0)} مليون جنيه';
      }
      final rounded1Dec = (millions * 10).round() / 10;
      if (rounded1Dec == millions) {
        return '$rounded1Dec مليون جنيه';
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

  /// Delivery date formatted in Arabic.
  String? get formattedDeliveryDate {
    if (deliveryDate == null) return null;
    return formatArabicMonthYear(deliveryDate!);
  }

  /// Serialize to Firestore-compatible map.
  Map<String, dynamic> toJson() => {
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
      areaSqm: (json['areaSqm'] as num?)?.toDouble(),
      buildingStructure: json['buildingStructure'] as String?,
      orientation: json['orientation'] as String?,
      layoutNote: json['layoutNote'] as String?,
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
