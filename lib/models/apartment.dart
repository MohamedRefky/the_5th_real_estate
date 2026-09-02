import '../core/utils/formatters.dart';
import '../core/utils/image_url_helper.dart';

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
  meter('كاش بالعداد'),
  negotiable('كاش وقابل للتفاوض'),
  installment('تقسيط');

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
  ///
  /// Nullable on purpose: Firestore data can arrive malformed, and the UI must
  /// never crash on a missing value — it falls back via [unitTypeLabel].
  final UnitType? unitType;

  /// Price in EGP.
  final double price;

  /// Price notes / payment method (كاش / تقسيط / قابل للتفاوض).
  /// Supports multiple selections.
  final Set<PriceNote> priceNotes;

  /// Floor number (-1 = بيزمنت, 0 = أرضي, 1 = أول, etc.).
  final int floor;

  /// Optional floor label string (e.g., "تاني", "أرضي").
  final String? floorString;

  /// Total number of floors in the building (optional/null if not specified).
  final int? totalFloors;

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
  ///
  /// Nullable on purpose: Firestore data can arrive malformed, and the UI must
  /// never crash on a missing value — it falls back via [finishingStatusLabel].
  final FinishingStatus? finishingStatus;

  /// Orientation / view (أمامي، خلفي، جانبي). Optional / null if not specified.
  final ApartmentOrientation? orientation;

  /// Price note string directly from Firestore (e.g. "بالعداد").
  final String? priceNote;

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
    this.priceNote,
    required this.floor,
    this.floorString,
    this.totalFloors,
    required this.areaSqm,
    required this.rooms,
    required this.bathrooms,
    this.reception,
    this.hasSeparateKitchen = false,
    required this.finishingStatus,
    this.orientation,
    this.isUnderConstruction = false,
    this.deliveryDate,
    this.constructionProgress = 1.0,
    this.milestones = const [],
    this.whatsappNumber = '',
    this.imageUrls = const [],
    this.videoUrl,
    this.amenities = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Safe label for the unit type — never throws, even on missing data.
  String get unitTypeLabel {
    try {
      final ut = unitType;
      if (ut != null) {
        final label = ut.label;
        if (label.isNotEmpty) return label;
      }
    } catch (_) {}
    return 'شقة';
  }

  /// Safe label for the finishing status — never throws, even on missing data.
  String get finishingStatusLabel {
    try {
      final fs = finishingStatus;
      if (fs != null) {
        final label = fs.label;
        if (label.isNotEmpty) return label;
      }
    } catch (_) {}
    return 'نص تشطيب';
  }

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

  /// Human-readable floor label (e.g. 'الدور الأول', 'دور أرضي', 'روف').
  String get floorLabel {
    final str = floorString?.trim();
    if (str != null && str.isNotEmpty) {
      if (str.startsWith('دور') || str.startsWith('الدور')) return str;
      if (str == 'أول' || str == 'اول') return 'الدور الأول';
      if (str == 'تاني' || str == 'ثاني') return 'الدور الثاني';
      if (str == 'تالت' || str == 'ثالث') return 'الدور الثالث';
      if (str == 'رابع') return 'الدور الرابع';
      if (str == 'خامس') return 'الدور الخامس';
      if (str == 'أرضي' || str == 'ارضي') return 'دور أرضي';
      if (str == 'بيزمنت') return 'بيزمنت';
      if (str == 'روف') return 'روف';
      return 'دور $str';
    }
    if (floor == -1) return 'بيزمنت';
    if (floor == 0) return 'دور أرضي';
    if (floor == 1) return 'الدور الأول';
    if (floor == 2) return 'الدور الثاني';
    if (floor == 3) return 'الدور الثالث';
    if (floor == 4) return 'الدور الرابع';
    if (floor == 5) return 'الدور الخامس';
    if (floor == 6) return 'روف';
    return 'الدور $floor';
  }

  /// Formatted price notes as a string.
  String? get formattedPriceNotes {
    try {
      if (priceNote != null && priceNote!.trim().isNotEmpty) {
        return priceNote!;
      }
      if (priceNotes.isEmpty) return null;
      final labels = priceNotes
          .map((n) => n.label)
          .where((l) => l.isNotEmpty);
      if (labels.isEmpty) return null;
      return labels.join(' • ');
    } catch (_) {
      return priceNote;
    }
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
        'unitType': unitType?.name,
        'price': price,
        'priceNote': priceNote,
        'priceNotes': priceNotes.map((n) => n.name).toList(),
        'floor': floor,
        'floorString': floorString,
        'totalFloors': totalFloors,
        'areaSqm': areaSqm,
        'rooms': rooms,
        'bathrooms': bathrooms,
        'reception': reception,
        'hasSeparateKitchen': hasSeparateKitchen,
        'finishingStatus': finishingStatus?.name,
        'orientation': orientation?.name,
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
    final rawOrientation = json['orientation'] as String?;
    final cleanOrientation =
        (rawOrientation == null || rawOrientation == 'null' || rawOrientation.trim().isEmpty)
            ? null
            : rawOrientation;

    final rawFloor = json['floor'];
    int floorInt = 0;
    String? floorStr;

    if (rawFloor is int) {
      floorInt = rawFloor;
    } else if (rawFloor is String) {
      floorStr = rawFloor;
      if (rawFloor.contains('أرضي')) {
        floorInt = 0;
      } else if (rawFloor.contains('أول')) {
        floorInt = 1;
      } else if (rawFloor.contains('تاني') || rawFloor.contains('ثاني')) {
        floorInt = 2;
      } else if (rawFloor.contains('تالت') || rawFloor.contains('ثالث')) {
        floorInt = 3;
      } else if (rawFloor.contains('رابع')) {
        floorInt = 4;
      } else if (rawFloor.contains('خامس')) {
        floorInt = 5;
      }
    }

    final rawPriceNote = json['priceNote'] as String?;
    final cleanPriceNote = (rawPriceNote == null || rawPriceNote == 'null') ? null : rawPriceNote;

    return Apartment(
      id: id ?? json['id'] as String? ?? '',
      title: json['projectName'] as String? ?? json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      freeDescription: json['freeDescription'] as String?,
      area: json['area'] as String? ?? '',
      unitType: (() {
        final raw = json['unitType'] as String?;
        if (raw == null || raw == 'null') return UnitType.apartment;
        return UnitType.values.where(
          (e) => e.name == raw || e.label == raw
        ).firstOrNull ?? UnitType.apartment;
      })(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      priceNotes: (json['priceNotes'] as List<dynamic>?)
              ?.map((n) => PriceNote.values.where(
                    (e) => e.name == n || e.label == n,
                  ).firstOrNull)
              .whereType<PriceNote>()
              .toSet() ??
          {},
      priceNote: cleanPriceNote,
      floor: floorInt,
      floorString: floorStr,
      totalFloors: json['totalFloors'] as int?,
      areaSqm: (json['areaSqm'] as num?)?.toDouble() ?? 0,
      rooms: json['bedrooms'] as int? ?? json['rooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      reception: json['hasReception'] == true
          ? 'ريسبشن'
          : (json['reception'] as String?),
      hasSeparateKitchen: json['hasKitchen'] as bool? ?? json['hasSeparateKitchen'] as bool? ?? false,
      finishingStatus: (() {
        final raw = json['finishingStatus'] as String?;
        if (raw == null || raw == 'null') return FinishingStatus.semiFinished;
        return FinishingStatus.values.where(
          (e) => e.name == raw || e.label == raw || raw.contains('تشطيب')
        ).firstOrNull ?? FinishingStatus.semiFinished;
      })(),
      orientation: cleanOrientation != null
          ? ApartmentOrientation.values
              .where((e) => e.name == cleanOrientation || e.label == cleanOrientation)
              .firstOrNull
          : null,
      isUnderConstruction: json['isUnderConstruction'] as bool? ?? false,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.tryParse(json['deliveryDate'].toString())
          : null,
      constructionProgress:
          (json['constructionProgress'] as num?)?.toDouble() ?? 1.0,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((m) {
                try {
                  return ConstructionMilestone.fromJson(m as Map<String, dynamic>);
                } catch (_) {
                  return null;
                }
              })
              .whereType<ConstructionMilestone>()
              .toList() ??
          [],
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
      imageUrls: (() {
        final list = <String>[];

        final facade = json['facadeImageUrl'] as String?;
        if (facade != null && facade.trim().isNotEmpty && facade != 'null') {
          final s = sanitizeImageUrl(facade);
          if (s.isNotEmpty) list.add(s);
        }

        final details = json['detailImageUrls'];
        if (details is List) {
          for (final d in details) {
            if (d != null) {
              final s = sanitizeImageUrl(d.toString());
              if (s.isNotEmpty && !list.contains(s)) list.add(s);
            }
          }
        }

        final raw = json['imageUrls'] ??
            json['imageUrl'] ??
            json['images'] ??
            json['photo'] ??
            json['photos'];
        if (raw is List) {
          for (final e in raw) {
            if (e != null) {
              final s = sanitizeImageUrl(e.toString());
              if (s.isNotEmpty && !list.contains(s)) list.add(s);
            }
          }
        } else if (raw is String && raw.trim().isNotEmpty && raw != 'null') {
          final s = sanitizeImageUrl(raw);
          if (s.isNotEmpty && !list.contains(s)) list.add(s);
        }
        return list;
      })(),
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
