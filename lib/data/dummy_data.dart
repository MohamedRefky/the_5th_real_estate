import '../models/apartment.dart';
import '../models/building.dart';

/// Hardcoded mock data — apartments and buildings per neighborhood.
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

  /// Mock building listings (one or more per neighborhood).
  static final List<Building> buildings = [
    // ─── 1. المستثمرين ─────────────────────────────────────────
    Building(
      id: 'bld_001',
      name: 'عمارة المستثمرين الفاخرة (توري 1)',
      description:
          'موقع استراتيجي بالقرب من المحاور الرئيسية والخدمات في قلب حي المستثمرين. '
          'تصميم واجهات مودرن وفندقية، مجهزة بأحدث المصاعد وأنظمة الأمان.',
      area: 'المستثمرين',
      startingPrice: 3200000,
      totalFloors: 5,
      totalUnits: 10,
      availableUnits: 4,
      finishingStatus: FinishingStatus.superLux,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000001',
      amenities: [
        'مصعد إيطالي',
        'حراسة وأمن 24/7',
        'جراج تحت الأرض',
        'إنتركم مرئي',
        'دش مركزي',
      ],
    ),

    // ─── 2. الأندلس ────────────────────────────────────────────
    Building(
      id: 'bld_002',
      name: 'مشروع الأندلس رويال',
      description:
          'عمارة سكنية راقية بمنطقة الأندلس تتميز بإطلالة مباشرة على الحدائق. '
          'تسليم نصف تشطيب مع واجهات ومداخل رخام فاخرة.',
      area: 'الأندلس',
      startingPrice: 4000000,
      totalFloors: 6,
      totalUnits: 12,
      availableUnits: 3,
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
          title: 'أعمال البناء والواجهات',
          date: DateTime(2025, 5),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'التشطيبات الخارجية والسلالم',
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
      amenities: [
        'مصعد هيدروليك',
        'كاميرات مراقبة',
        'روف خدمي',
        'مواقف سيارات خاصة',
      ],
    ),

    // ─── 3. جاردينيا ───────────────────────────────────────────
    Building(
      id: 'bld_003',
      name: 'جاردينيا هايتس ١ (حرف ت)',
      description:
          'عمارة سكنية متكاملة الخدمات في حي جاردينيا هايتس ١ (حرف ت). '
          'تضمن لك الهدوء والخصوصية وتتميز بتنوع المساحات المتاحة من بيزمنت إلى الأدوار المتكررة.',
      area: 'جاردينيا',
      startingPrice: 2000000,
      totalFloors: 5,
      totalUnits: 10,
      availableUnits: 3,
      finishingStatus: FinishingStatus.semiFinished,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000003',
      amenities: [
        'مصعد فاخر',
        'حارس أمن متواجد',
        'جراج خاص لكل شقة',
        'مدخل رخام إسباني',
        'قريب من منطقة الخدمات',
      ],
    ),

    // ─── 4. بيت الوطن ──────────────────────────────────────────
    Building(
      id: 'bld_004',
      name: 'مشروع بيت الوطن F-45',
      description:
          'فرصة استثمارية وسكنية ممتازة بالحي الثاني بيت الوطن. '
          'خطط سداد مرنة تمتد حتى 4 سنوات وبدون فوائد.',
      area: 'بيت الوطن',
      startingPrice: 1850000,
      totalFloors: 5,
      totalUnits: 10,
      availableUnits: 5,
      finishingStatus: FinishingStatus.underConstruction,
      isUnderConstruction: true,
      deliveryDate: DateTime(2027, 1),
      constructionProgress: 0.45,
      milestones: [
        ConstructionMilestone(
          title: 'صب الأساسات والخوازيق',
          date: DateTime(2025, 2),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'الهيكل الخرساني بالكامل',
          date: DateTime(2025, 9),
          isCompleted: true,
        ),
        ConstructionMilestone(
          title: 'المباني والتشطيبات الخارجية',
          date: DateTime(2026, 4),
          isCompleted: false,
        ),
        ConstructionMilestone(
          title: 'المداخل والمصاعد',
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
      amenities: [
        'مصعد كهربائي',
        'جراج سفلي',
        'خزانات مياه مركزية',
        'إطلالة على شارع عريض',
      ],
    ),

    // ─── 5. النرجس الجديدة ─────────────────────────────────────
    Building(
      id: 'bld_005',
      name: 'عمارة النرجس فلاتس ريزيدنس',
      description:
          'عمارة سكنية فاخرة بنظام سمارت هوم في أرق مناطق النرجس الجديدة. '
          'واجهات متميزة مع زجاج مزدوج عازل للصوت والحرارة.',
      area: 'النرجس الجديدة',
      startingPrice: 4800000,
      totalFloors: 5,
      totalUnits: 8,
      availableUnits: 2,
      finishingStatus: FinishingStatus.superLux,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000005',
      amenities: [
        'سمارت هوم',
        'مصعد بانوراما',
        'تراس وروف مشترك',
        'حراسة 24 ساعة',
        'شواحن سيارات كهربائية',
      ],
    ),
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
      freeDescription: 'فيو مباشر على الحديقة المركزية — قريبة من البوابة الرئيسية',
      area: 'المستثمرين',
      unitType: UnitType.apartment,
      price: 3500000,
      priceNotes: {PriceNote.cash, PriceNote.negotiable},
      floor: 3,
      totalFloors: 5,
      areaSqm: 180,
      rooms: 3,
      bathrooms: 2,
      reception: 'ريسبشن قطعتين',
      hasSeparateKitchen: true,
      finishingStatus: FinishingStatus.superLux,
      orientation: ApartmentOrientation.front,
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
      freeDescription: 'قريب من المحور المركزي — إطلالة على الحدائق',
      area: 'الأندلس',
      unitType: UnitType.duplex,
      price: 4200000,
      priceNotes: {PriceNote.installment},
      floor: 4,
      totalFloors: 6,
      areaSqm: 220,
      rooms: 4,
      bathrooms: 3,
      reception: 'ريسبشن L شيب كبير',
      hasSeparateKitchen: true,
      finishingStatus: FinishingStatus.semiFinished,
      orientation: ApartmentOrientation.front,
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

    // ─── 3. جاردينيا (عمارة جاردينيا هايتس ١ - حرف ت) ─────────────
    Apartment(
      id: 'apt_gardenia_001',
      title: 'جاردينيا هايتس ١ حرف ت - بيزمنت 180م²',
      description:
          'شقة بيزمنت بمساحة ١٨٠ متر مربع في حي جاردينيا هايتس ١ (حرف ت). '
          'موقع متميز بالحي وقريب من الخدمات والمحاور الرئيسية.',
      freeDescription: 'مناسبة كعيادة أو مكتب — دور بيزمنت بمدخل مستقل',
      area: 'جاردينيا',
      unitType: UnitType.apartment,
      price: 2000000,
      priceNotes: {PriceNote.cash},
      floor: -1,
      totalFloors: 5,
      areaSqm: 180,
      rooms: 3,
      bathrooms: 2,
      reception: 'ريسبشن واسع',
      hasSeparateKitchen: true,
      finishingStatus: FinishingStatus.semiFinished,
      orientation: ApartmentOrientation.rear,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000003',
      amenities: ['دور بيزمنت', 'جراج خاص', 'مصعد', 'حارس أمن', 'قريب من الخدمات'],
    ),

    Apartment(
      id: 'apt_gardenia_002',
      title: 'جاردينيا هايتس ١ حرف ت - أرضي 170م²',
      description:
          'شقة بالدور الأرضي بمساحة ١٧٠ متر مربع بحي جاردينيا هايتس ١ (حرف ت). '
          'تتكون من ٣ غرف وريسبشن واسع و٢ حمام ومطبخ، نصف تشطيب.',
      area: 'جاردينيا',
      unitType: UnitType.apartment,
      price: 3300000,
      priceNotes: {PriceNote.cash, PriceNote.negotiable},
      floor: 0,
      totalFloors: 5,
      areaSqm: 170,
      rooms: 3,
      bathrooms: 2,
      reception: 'ريسبشن قطعتين',
      hasSeparateKitchen: true,
      finishingStatus: FinishingStatus.semiFinished,
      orientation: ApartmentOrientation.front,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000003',
      amenities: ['دور أرضي', 'ريسبشن واسع', '٢ حمام ومطبخ', 'مصعد', 'حارس أمن'],
    ),

    Apartment(
      id: 'apt_gardenia_003',
      title: 'جاردينيا هايتس ١ حرف ت - ثاني خلفي 120م²',
      description:
          'شقة بالدور الثاني خلفي بمساحة ١٢٠ متر مربع بحي جاردينيا هايتس ١ (حرف ت). '
          'تتكون من غرفتين وريسبشن وحمام ومطبخ، نصف تشطيب.',
      area: 'جاردينيا',
      unitType: UnitType.apartment,
      price: 2350000,
      priceNotes: {PriceNote.negotiable},
      floor: 2,
      totalFloors: 5,
      areaSqm: 120,
      rooms: 2,
      bathrooms: 1,
      reception: 'ريسبشن',
      hasSeparateKitchen: false,
      finishingStatus: FinishingStatus.semiFinished,
      orientation: ApartmentOrientation.rear,
      isUnderConstruction: false,
      constructionProgress: 1.0,
      whatsappNumber: '+201000000003',
      amenities: ['دور ثاني خلفي', 'ريسبشن', 'مطبخ وحمام', 'مصعد', 'إطلالة هادئة'],
    ),

    // ─── 4. بيت الوطن ──────────────────────────────────────────
    Apartment(
      id: 'apt_004',
      title: 'شقة تحت الإنشاء في بيت الوطن',
      description:
          'فرصة استثمارية ممتازة في بيت الوطن. '
          'شقة بدون تشطيب بسعر مميز مع خطة سداد مرنة. '
          'هيتسلم يناير 2027 بإذن الله.',
      freeDescription: 'خطة سداد مرنة حتى ٤ سنوات بدون فوائد',
      area: 'بيت الوطن',
      unitType: UnitType.apartment,
      price: 1900000,
      priceNotes: {PriceNote.installment, PriceNote.negotiable},
      floor: 2,
      totalFloors: 5,
      areaSqm: 140,
      rooms: 2,
      bathrooms: 1,
      reception: 'ريسبشن',
      hasSeparateKitchen: false,
      finishingStatus: FinishingStatus.underConstruction,
      orientation: ApartmentOrientation.side,
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
      title: 'بنتهاوس فاخر بالنرجس الجديدة',
      description:
          'بنتهاوس حصري بإطلالة بانورامية في حي النرجس الجديدة. '
          'تشطيب سوبر لوكس مع تراس واسع وجاكوزي. '
          'لمحبي الفخامة والخصوصية.',
      freeDescription: 'روف خاص بجاكوزي — إطلالة بانورامية 360°',
      area: 'النرجس الجديدة',
      unitType: UnitType.duplex,
      price: 5500000,
      priceNotes: {PriceNote.cash},
      floor: 6,
      totalFloors: 5,
      areaSqm: 250,
      rooms: 4,
      bathrooms: 3,
      reception: 'ريسبشن كبير قطعتين',
      hasSeparateKitchen: true,
      finishingStatus: FinishingStatus.superLux,
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

  /// Get apartments filtered by area name (supports exact or partial match for "النرجس").
  static List<Apartment> getByArea(String area) {
    return apartments.where((apt) {
      if (apt.area == area) return true;
      if (area == 'النرجس الجديدة' && apt.area == 'النرجس') return true;
      if (area == 'النرجس' && apt.area == 'النرجس الجديدة') return true;
      return false;
    }).toList();
  }

  /// Get buildings filtered by area name.
  static List<Building> getBuildingsByArea(String area) {
    return buildings.where((bld) {
      if (bld.area == area) return true;
      if (area == 'النرجس الجديدة' && bld.area == 'النرجس') return true;
      if (area == 'النرجس' && bld.area == 'النرجس الجديدة') return true;
      return false;
    }).toList();
  }

  /// Get a single apartment by its ID.
  static Apartment? getById(String id) {
    try {
      return apartments.firstWhere((apt) => apt.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get a single building by its ID.
  static Building? getBuildingById(String id) {
    try {
      return buildings.firstWhere((bld) => bld.id == id);
    } catch (_) {
      return null;
    }
  }
}
