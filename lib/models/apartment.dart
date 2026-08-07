/// Finishing status of an apartment.
enum FinishingStatus {
  /// Fully finished and ready to move in.
  finished('تشطيب كامل'),

  /// Semi-finished (basic utilities, no cosmetics).
  semiFinished('نصف تشطيب'),

  /// Shell & core only.
  unfinished('بدون تشطيب');

  final String label;
  const FinishingStatus(this.label);
}

/// Represents a single construction milestone in the timeline.
class ConstructionMilestone {
  /// Display title (e.g., "صب الأساسات").
  final String title;

  /// Target date for this milestone.
  final DateTime date;

  /// Whether this milestone has been completed.
  final bool isCompleted;

  const ConstructionMilestone({
    required this.title,
    required this.date,
    this.isCompleted = false,
  });
}

/// Core data model for a real-estate apartment listing.
class Apartment {
  /// Unique identifier (will map to Firestore doc ID later).
  final String id;

  /// Listing title (e.g., "شقة فاخرة بالنرجس").
  final String title;

  /// Short description / marketing copy.
  final String description;

  /// Neighborhood name (e.g., "المستثمرين").
  final String area;

  /// Price in EGP.
  final double price;

  /// Floor number (0 = ground floor).
  final int floor;

  /// Total number of floors in the building.
  final int totalFloors;

  /// Living area in square meters.
  final double areaSqm;

  /// Number of bedrooms.
  final int rooms;

  /// Number of bathrooms.
  final int bathrooms;

  /// Finishing status.
  final FinishingStatus finishingStatus;

  /// Whether the unit is still under construction.
  final bool isUnderConstruction;

  /// Expected delivery date (null if already delivered).
  final DateTime? deliveryDate;

  /// Overall construction progress (0.0 – 1.0).
  final double constructionProgress;

  /// Construction timeline milestones.
  final List<ConstructionMilestone> milestones;

  /// Owner / agent WhatsApp number (international format).
  final String whatsappNumber;

  /// Placeholder icon for the listing card.
  /// Will be replaced with actual image URLs when Firebase Storage is set up.
  final List<String> imagePlaceholders;

  /// Key amenities / features (e.g., "مصعد", "حديقة خاصة").
  final List<String> amenities;

  const Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.area,
    required this.price,
    required this.floor,
    required this.totalFloors,
    required this.areaSqm,
    required this.rooms,
    required this.bathrooms,
    required this.finishingStatus,
    this.isUnderConstruction = false,
    this.deliveryDate,
    this.constructionProgress = 1.0,
    this.milestones = const [],
    required this.whatsappNumber,
    this.imagePlaceholders = const [],
    this.amenities = const [],
  });

  /// Formatted price string in Egyptian Pounds.
  String get formattedPrice {
    if (price >= 1000000) {
      final millions = price / 1000000;
      final formatted =
          millions == millions.roundToDouble()
              ? millions.toStringAsFixed(0)
              : millions.toStringAsFixed(1);
      return '$formatted مليون جنيه';
    }
    final thousands = (price / 1000).toStringAsFixed(0);
    return '$thousands ألف جنيه';
  }

  /// Human-readable floor label.
  String get floorLabel {
    if (floor == 0) return 'أرضي';
    if (floor == 1) return 'الأول';
    if (floor == 2) return 'الثاني';
    if (floor == 3) return 'الثالث';
    if (floor == 4) return 'الرابع';
    if (floor == 5) return 'الخامس';
    return 'الدور $floor';
  }

  /// Delivery date formatted as Arabic month + year (e.g., "يناير 2026").
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
