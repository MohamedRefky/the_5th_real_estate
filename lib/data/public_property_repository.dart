import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../features/admin/models/property.dart' as admin show Property;
import '../models/apartment.dart';
import 'dummy_data.dart';
import 'mappers/property_mapper.dart';

/// Public-facing apartment data source for the website.
///
/// Merges the local bundled listings ([DummyData]) with PUBLISHED properties
/// stored in Firestore by the admin dashboard. Firestore listings appear on
/// the website instantly after being added; local listings stay as a fallback
/// and as extra content.
///
/// Firestore data is read from the per-area folders `properties/{area}/units`
/// (plus the legacy flat `properties` collection during the migration window).
///
/// If Firebase is not configured or the query fails (offline, rules, etc.)
/// this transparently falls back to local data only — the site never breaks.
class PublicPropertyRepository {
  PublicPropertyRepository._();

  static final PublicPropertyRepository instance =
      PublicPropertyRepository._();

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
        final byId = <String, Apartment>{};

        // New structure: one folder per area.
        final areaSnaps = await Future.wait([
          for (final area in DummyData.areas)
            FirebaseFirestore.instance
                .collection('properties')
                .doc(area)
                .collection('units')
                .where('isPublished', isEqualTo: true)
                .get(),
        ]);

        // Legacy flat collection — still read until the migration deletes it.
        final legacySnap = await FirebaseFirestore.instance
            .collection('properties')
            .where('isPublished', isEqualTo: true)
            .get();

        for (final snap in [legacySnap, ...areaSnaps]) {
          for (final doc in snap.docs) {
            byId[doc.id] = propertyToApartment(
              admin.Property.fromFirestore(doc.id, doc.data()),
            );
          }
        }
        remote = byId.values.toList();
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
}
