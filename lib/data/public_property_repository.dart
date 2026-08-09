import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../features/admin/models/property.dart'
    as admin show Property, PriceNote, PropertyFinishing, PropertyOrientation, UnitType;
import '../models/apartment.dart';
import 'dummy_data.dart';

/// Public-facing apartment data source for the website.
///
/// Merges the local bundled listings ([DummyData]) with PUBLISHED properties
/// stored in Firestore by the admin dashboard. Firestore listings appear on
/// the website instantly after being added; local listings stay as a fallback
/// and as extra content.
///
/// If Firebase is not configured or the query fails (offline, rules, etc.)
/// this transparently falls back to local data only — the site never breaks.
class PublicPropertyRepository {
  PublicPropertyRepository._();

  static final PublicPropertyRepository instance =
      PublicPropertyRepository._();

  /// WhatsApp number used for admin-added listings (editable later).
  static const String defaultWhatsapp = '+201000000001';

  List<Apartment>? _cache;

  /// All apartments (local + published Firestore), newest first.
  Future<List<Apartment>> all() async {
    if (_cache != null) return _cache!;
    return _load();
  }

  /// Apartments belonging to [area].
  Future<List<Apartment>> byArea(String area) async {
    final allApartments = await all();
    return allApartments.where((apt) => _areaMatches(apt.area, area)).toList();
  }

  /// Single apartment by id (Firestore doc id or local id).
  Future<Apartment?> byId(String id) async {
    final allApartments = await all();
    for (final apt in allApartments) {
      if (apt.id == id) return apt;
    }
    return null;
  }

  /// Clears the cache so the next call refetches from Firestore.
  void invalidate() => _cache = null;

  Future<List<Apartment>> _load() async {
    final local = DummyData.apartments;
    var remote = const <Apartment>[];
    try {
      if (Firebase.apps.isNotEmpty) {
        final snap = await FirebaseFirestore.instance
            .collection('properties')
            .where('isPublished', isEqualTo: true)
            .get(const GetOptions(source: Source.serverAndCache));
        remote = snap.docs
            .map((doc) => _propertyToApartment(
                  admin.Property.fromFirestore(doc.id, doc.data()),
                ))
            .toList();
      }
    } catch (_) {
      // Offline / not set up / permission denied → local data only.
      remote = const [];
    }

    final merged = [...remote, ...local];
    merged.sort((a, b) {
      final aT = a.updatedAt ?? a.createdAt;
      final bT = b.updatedAt ?? b.createdAt;
      if (aT == null && bT == null) return 0;
      if (aT == null) return 1;
      if (bT == null) return -1;
      return bT.compareTo(aT);
    });
    _cache = merged;
    return merged;
  }

  bool _areaMatches(String aptArea, String area) {
    if (aptArea == area) return true;
    if (area == 'النرجس الجديدة' && aptArea == 'النرجس') return true;
    if (area == 'النرجس' && aptArea == 'النرجس الجديدة') return true;
    return false;
  }

  /// Maps an admin `properties` doc onto the public [Apartment] model.
  Apartment _propertyToApartment(admin.Property p) {
    return Apartment(
      id: p.id ?? '',
      title: p.buildingLabel != null && p.buildingLabel!.isNotEmpty
          ? '${p.projectName} — ${p.buildingLabel}'
          : p.projectName,
      description:
          p.description ?? '${p.projectName} — ${p.unitType.label} ${p.floor}',
      freeDescription: p.description,
      area: p.area,
      unitType: _unitType(p.unitType),
      price: p.price,
      priceNotes: p.priceNote == null
          ? const {}
          : {_priceNote(p.priceNote!)},
      floor: _floorIndex(p.floor),
      totalFloors: 1,
      areaSqm: p.areaSqm,
      rooms: p.bedrooms,
      bathrooms: p.bathrooms,
      reception: p.hasReception ? 'ريسبشن' : 'بدون ريسبشن',
      hasSeparateKitchen: p.hasKitchen,
      finishingStatus: _finishing(p.finishingStatus),
      orientation: _orientation(p.orientation),
      isUnderConstruction: false,
      whatsappNumber: defaultWhatsapp,
      imageUrls: p.imageUrls,
      amenities: const [],
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    );
  }

  UnitType _unitType(admin.UnitType t) {
    for (final e in UnitType.values) {
      if (e.label == t.label) return e;
    }
    if (t.label == 'عماره') return UnitType.building;
    return UnitType.apartment;
  }

  PriceNote _priceNote(admin.PriceNote n) {
    for (final e in PriceNote.values) {
      if (e.label == n.label) return e;
    }
    if (n.label == 'بالعداد') return PriceNote.installment;
    return PriceNote.cash;
  }

  FinishingStatus _finishing(admin.PropertyFinishing f) {
    switch (f.label) {
      case 'سوبر لوكس':
      case 'تشطيب كامل':
        return FinishingStatus.superLux;
      case 'نص تشطيب':
      case '٣_٤ تشطيب':
        return FinishingStatus.semiFinished;
      default:
        return FinishingStatus.semiFinished;
    }
  }

  ApartmentOrientation _orientation(admin.PropertyOrientation? o) {
    for (final e in ApartmentOrientation.values) {
      if (e.label == o?.label) return e;
    }
    return ApartmentOrientation.front;
  }

  int _floorIndex(String floor) {
    switch (floor) {
      case 'بيزمنت':
        return -1;
      case 'أرضي':
        return 0;
      case 'أول':
        return 1;
      case 'تاني':
        return 2;
      case 'تالت':
        return 3;
      case 'رابع':
        return 4;
      case 'خامس':
        return 5;
      case 'روف':
        return 6;
      default:
        return 0;
    }
  }
}
