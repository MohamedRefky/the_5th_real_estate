import 'apartment.dart';

/// Core data model for a residential building listing.
class Building {
  /// Unique identifier.
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

  /// Facade cover image URL / asset path.
  final String? coverImageUrl;

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
    this.coverImageUrl,
  });

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
}
