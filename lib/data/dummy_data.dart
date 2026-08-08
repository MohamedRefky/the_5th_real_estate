import '../models/apartment.dart';

/// Hardcoded mock data — one apartment per neighborhood.
///
/// This file will be replaced by Firestore queries once Firebase is set up.
/// Each listing has realistic Arabic data to showcase all app features:
/// filters, construction timeline, WhatsApp CTA, etc.
class DummyData {
  DummyData._();

  /// All available neighborhood names.
  static const List<String> areas = [
    'المستثمرين',
    'الأندلس',
    'جاردينيا',
    'بيت الوطن',
    'النرجس الجديدة',
  ];

  /// Mock apartment listings.
  static final List<Apartment> apartments = [
    // ─── 1. المستثمرين ─────────────────────────────────────────
    Apartment(
      id: 'apt_001',
      title: 'شقة مميزة بحي المستثمرين',
      description:
          'شقة فاخرة بتصميم عصري في قلب حي المستثمرين. '
          'تتميز بإطلالة رائعة على الحديقة المركزية، '
          'تشطيب سوبر لوكس بأجود الخامات.',
      area: 'المستثمرين',
      price: 3500000,
      floor: 3,
      totalFloors: 5,
      areaSqm: 180,
      rooms: 3,
      bathrooms: 2,
      finishingStatus: FinishingStatus.finished,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000001',
      amenities: [
        'مصعد',
        'حارس أمن',
        'جراج خاص',
        'حديقة مركزية',
        'تكييف مركزي',
      ],
    ),

    // ─── 2. الأندلس ────────────────────────────────────────────
    Apartment(
      id: 'apt_002',
      title: 'دوبلكس فاخر بالأندلس',
      description:
          'دوبلكس بمساحة واسعة في منطقة الأندلس الراقية. '
          'تشطيب نصف تشطيب يتيح لك حرية التصميم الداخلي. '
          'قريب من المحاور الرئيسية والخدمات.',
      area: 'الأندلس',
      price: 4200000,
      floor: 4,
      totalFloors: 6,
      areaSqm: 220,
      rooms: 4,
      bathrooms: 3,
      finishingStatus: FinishingStatus.semiFinished,
      isUnderConstruction: true,
      deliveryDate: DateTime(2026, 6),
      constructionProgress: 0.75,
      milestones: [
        ConstructionMilestone(
          title: 'صب الأساسات',
          date: DateTime(2024, 3),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'الهيكل الخرساني',
          date: DateTime(2024, 10),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'أعمال البناء',
          date: DateTime(2025, 5),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'التشطيبات الداخلية',
          date: DateTime(2025, 12),
          isCompleted: false,
        ),
        ConstructionMilestone(
          title: 'التسليم النهائي',
          date: DateTime(2026, 6),
          isCompleted: false,
        ),
      ],
      whatsappNumber: '+201000000002',
      amenities: ['مصعد', 'روف خاص', 'قريب من المحور', 'نادي رياضي'],
    ),

    // ─── 3. جاردينيا ───────────────────────────────────────────
    Apartment(
      id: 'apt_003',
      title: 'شقة أرضي بحديقة في جاردينيا',
      description:
          'شقة أرضي بحديقة خاصة واسعة في كمبوند جاردينيا. '
          'مثالية للعائلات، بالقرب من المدارس والمستشفيات. '
          'تشطيب كامل جاهزة للسكن الفوري.',
      area: 'جاردينيا',
      price: 2800000,
      floor: 0,
      totalFloors: 4,
      areaSqm: 160,
      rooms: 3,
      bathrooms: 2,
      finishingStatus: FinishingStatus.finished,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000003',
      amenities: ['حديقة خاصة', 'مدخل مستقل', 'قريب من المدارس', 'أمن 24 ساعة'],
    ),

    // ─── 4. بيت الوطن ──────────────────────────────────────────
    Apartment(
      id: 'apt_004',
      title: 'شقة تحت الإنشاء في بيت الوطن',
      description:
          'فرصة استثمارية ممتازة في بيت الوطن. '
          'شقة بدون تشطيب بسعر مميز مع خطة سداد مرنة. '
          'هيتسلم يناير 2027 بإذن الله.',
      area: 'بيت الوطن',
      price: 1900000,
      floor: 2,
      totalFloors: 5,
      areaSqm: 140,
      rooms: 2,
      bathrooms: 1,
      finishingStatus: FinishingStatus.unfinished,
      isUnderConstruction: true,
      deliveryDate: DateTime(2027, 1),
      constructionProgress: 0.45,
      milestones: [
        ConstructionMilestone(
          title: 'صب الأساسات',
          date: DateTime(2025, 2),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'الهيكل الخرساني',
          date: DateTime(2025, 9),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'أعمال البناء',
          date: DateTime(2026, 4),
          isCompleted: false,
        ),
        ConstructionMilestone(
          title: 'التشطيبات والتجهيزات',
          date: DateTime(2026, 10),
          isCompleted: false,
        ),
        ConstructionMilestone(
          title: 'التسليم النهائي',
          date: DateTime(2027, 1),
          isCompleted: false,
        ),
      ],
      whatsappNumber: '+201000000004',
      amenities: ['جراج تحت الأرض', 'مصعد', 'منطقة تجارية', 'مساحات خضراء'],
    ),

    // ─── 5. النرجس ─────────────────────────────────────────────
    Apartment(
      id: 'apt_005',
      title: 'بنتهاوس فاخر بالنرجس',
      description:
          'بنتهاوس حصري بإطلالة بانورامية في حي النرجس الجديدة. '
          'تشطيب سوبر لوكس مع تراس واسع وجاكوزي. '
          'لمحبي الفخامة والخصوصية.',
      area: 'النرجس',
      price: 5500000,
      floor: 6,
      totalFloors: 5,
      areaSqm: 250,
      rooms: 4,
      bathrooms: 3,
      finishingStatus: FinishingStatus.finished,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000005',
      amenities: [
        'تراس بانورامي',
        'جاكوزي',
        'غرفة خادمة',
        'مصعد خاص',
        '٢ جراج',
      ],
    ),
  ];

  /// Get apartments filtered by area name.
  static List<Apartment> getByArea(String area) {
    return apartments.where((apt) => apt.area == area).toList();
  }

  /// Get a single apartment by its ID.
  static Apartment? getById(String id) {
    try {
      return apartments.firstWhere((apt) => apt.id == id);
    } catch (_) {
      return null;
    }
  }
}
