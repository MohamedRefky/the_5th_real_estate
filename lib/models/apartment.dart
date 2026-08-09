import '../core/utils/formatters.dart';

/// ─── Finishing status of a property unit ─────────────────────────
///
/// Admin dashboard values: سوبر لوكس / نص تشطيب / تحت الإنشاء
enum FinishingStatus {
  /// Fully finished, super lux.
  superLux('سوبر لوكس'),

  /// Semi-finished (basic utilities, no cosmetics).
  semiFinished('نص تشطيب'),

  /// Under construction / not yet finished.
  underConstruction('تحت الإنشاء');

  final String label;
  const FinishingStatus(this.label);
}

/// ─── Apartment orientation/view ──────────────────────────────────
enum ApartmentOrientation {
  /// Front view / facing main street.
  front('أمامي'),

  /// Rear view / facing garden or inner courtyard.
  rear('خلفي'),

  /// Side view.
  side('جانبي');

  final String label;
  const ApartmentOrientation(this.label);
}

/// ─── Unit type ───────────────────────────────────────────────────
enum UnitType {
  apartment('شقة'),
  duplex('دوبلكس'),
  villa('فيلا'),
  building('عمارة'),
  studio('استوديو');

  final String label;
  const UnitType(this.label);
}

/// ─── Price note / payment method ─────────────────────────────────
enum PriceNote {
  cash('كاش'),
  installment('بالعداد (تقسيط)'),
  negotiable('قابل للتفاوض');

  final String label;
  const PriceNote(this.label);
}

/// ─── Construction milestone ──────────────────────────────────────
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

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory ConstructionMilestone.fromJson(Map<String, dynamic> json) {
    return ConstructionMilestone(
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

/// ─── Core data model for a real-estate property listing ──────────
///
/// Represents a single unit that the admin enters via the dashboard.
/// Fields are aligned with the admin form:
///   - عنوان (title) = اسم المشروع/الكمبوند + حرف الحي
///   - نوع الوحدة (unitType)
///   - الدور (floor)
///   - واجهة الشقة (orientation)
///   - المساحة (areaSqm)
///   - عدد الغرف (rooms)
///   - عدد الحمامات (bathrooms)
///   - الريسبشن (reception) — free text
///   - مطبخ منفصل (hasSeparateKitchen)
///   - حالة التشطيب (finishingStatus)
///   - السعر (price) + ملاحظة السعر (priceNotes)
///   - وصف حر (freeDescription)
///   - صور (imageUrls)
class Apartment {
  /// Unique identifier (Firestore doc ID).
  final String id;

  /// Listing title — entered by admin as: اسم المشروع/الكمبوند + حرف الحي.
  /// Example: "جاردنيا هايتس ٢ حرف ت"
  final String title;

  /// Short description / marketing copy.
  final String description;

  /// Free-text additional notes (textarea).
  /// Examples: "قريبة من المدخل الرئيسي", "فيو على الحديقة".
  final String? freeDescription;

  /// Neighborhood name (e.g., "المستثمرين", "جاردينيا").
  /// Used for filtering and grouping by area.
  final String area;

  /// Unit type (شقة / دوبلكس / فيلا / عمارة / استوديو).
  final UnitType unitType;

  /// Price in EGP.
  final double price;

  /// Price notes / payment method (كاش / تقسيط / قابل للتفاوض).
  /// Supports multiple selections.
  final Set<PriceNote> priceNotes;

  /// Floor number (-1 = بيزمنت, 0 = أرضي, 1 = أول, etc.).
  final int floor;

  /// Total number of floors in the building.
  final int totalFloors;

  /// Living area in square meters.
  final double areaSqm;

  /// Number of bedrooms.
  final int rooms;

  /// Number of bathrooms.
  final int bathrooms;

  /// Reception description (free text).
  /// Examples: "ريسبشن قطعتين", "ريسبشن L شيب", "بدون ريسبشن".
  final String? reception;

  /// Whether the unit has a separate kitchen.
  final bool hasSeparateKitchen;

  /// Finishing status.
  final FinishingStatus finishingStatus;

  /// Orientation / view (أمامي، خلفي، جانبي).
  final ApartmentOrientation orientation;

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

  /// Image URLs — one unified gallery (Firebase Storage).
  /// The first image in the list is used as the cover/facade.
  final List<String> imageUrls;

  /// Apartment walkthrough video URL (optional).
  final String? videoUrl;

  /// Key amenities / features (e.g., "مصعد", "حديقة خاصة").
  final List<String> amenities;

  /// Timestamp when this listing was created.
  final DateTime? createdAt;

  /// Timestamp when this listing was last updated.
  final DateTime? updatedAt;

  const Apartment({
    required this.id,
    required this.title,
    required this.description,
    this.freeDescription,
    required this.area,
    this.unitType = UnitType.apartment,
    required this.price,
    this.priceNotes = const {},
    required this.floor,
    required this.totalFloors,
    required this.areaSqm,
    required this.rooms,
    required this.bathrooms,
    this.reception,
    this.hasSeparateKitchen = false,
    required this.finishingStatus,
    this.orientation = ApartmentOrientation.front,
    this.isUnderConstruction = false,
    this.deliveryDate,
    this.constructionProgress = 1.0,
    this.milestones = const [],
    required this.whatsappNumber,
    this.imageUrls = const [],
    this.videoUrl,
    this.amenities = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// The first image URL, used as cover/facade. Null if no images.
  String? get coverImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : null;

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
    if (floor == -1) return 'بيزمنت';
    if (floor == 0) return 'أرضي';
    if (floor == 1) return 'الأول';
    if (floor == 2) return 'الثاني';
    if (floor == 3) return 'الثالث';
    if (floor == 4) return 'الرابع';
    if (floor == 5) return 'الخامس';
    if (floor == 6) return 'الروف';
    return 'الدور $floor';
  }

  /// Formatted price notes as a comma-separated string.
  String? get formattedPriceNotes {
    if (priceNotes.isEmpty) return null;
    return priceNotes.map((n) => n.label).join(' • ');
  }

  /// Delivery date formatted as Arabic month + year (e.g., "يناير 2026").
  String? get formattedDeliveryDate {
    if (deliveryDate == null) return null;
    return formatArabicMonthYear(deliveryDate!);
  }

  /// Serialize to Firestore-compatible map.
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'freeDescription': freeDescription,
        'area': area,
        'unitType': unitType.name,
        'price': price,
        'priceNotes': priceNotes.map((n) => n.name).toList(),
        'floor': floor,
        'totalFloors': totalFloors,
        'areaSqm': areaSqm,
        'rooms': rooms,
        'bathrooms': bathrooms,
        'reception': reception,
        'hasSeparateKitchen': hasSeparateKitchen,
        'finishingStatus': finishingStatus.name,
        'orientation': orientation.name,
        'isUnderConstruction': isUnderConstruction,
        'deliveryDate': deliveryDate?.toIso8601String(),
        'constructionProgress': constructionProgress,
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'whatsappNumber': whatsappNumber,
        'imageUrls': imageUrls,
        'videoUrl': videoUrl,
        'amenities': amenities,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// Deserialize from Firestore document.
  factory Apartment.fromJson(Map<String, dynamic> json, {String? id}) {
    return Apartment(
      id: id ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      freeDescription: json['freeDescription'] as String?,
      area: json['area'] as String? ?? '',
      unitType: UnitType.values.firstWhere(
        (e) => e.name == json['unitType'],
        orElse: () => UnitType.apartment,
      ),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      priceNotes: (json['priceNotes'] as List<dynamic>?)
              ?.map((n) => PriceNote.values.firstWhere(
                    (e) => e.name == n,
                    orElse: () => PriceNote.cash,
                  ))
              .toSet() ??
          {},
      floor: json['floor'] as int? ?? 0,
      totalFloors: json['totalFloors'] as int? ?? 1,
      areaSqm: (json['areaSqm'] as num?)?.toDouble() ?? 0,
      rooms: json['rooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      reception: json['reception'] as String?,
      hasSeparateKitchen: json['hasSeparateKitchen'] as bool? ?? false,
      finishingStatus: FinishingStatus.values.firstWhere(
        (e) => e.name == json['finishingStatus'],
        orElse: () => FinishingStatus.semiFinished,
      ),
      orientation: ApartmentOrientation.values.firstWhere(
        (e) => e.name == json['orientation'],
        orElse: () => ApartmentOrientation.front,
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
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      videoUrl: json['videoUrl'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
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
