import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../features/admin/models/admin_building.dart';
import '../models/building.dart';
import 'dummy_data.dart';
import 'mappers/building_mapper.dart';

/// Public-facing building data source for the website.
///
/// Merges the local bundled listings ([DummyData]) with PUBLISHED buildings
/// stored in Firestore under `buildings/{area}/units` by the admin dashboard.
/// Firestore listings appear on the website instantly after being added;
/// local listings stay as a fallback and as extra content.
///
/// If Firebase is not configured or the query fails (offline, rules, etc.)
/// this transparently falls back to local data only — the site never breaks.
class PublicBuildingRepository {
  PublicBuildingRepository._();

  static final PublicBuildingRepository instance =
      PublicBuildingRepository._();

  List<Building>? _cache;

  /// All buildings (local + published Firestore), newest first.
  Future<List<Building>> all() async {
    if (_cache != null) return _cache!;
    return _load();
  }

  /// Buildings belonging to [area].
  Future<List<Building>> byArea(String area) async {
    final allBuildings = await all();
    return allBuildings.where((b) => _areaMatches(b.area, area)).toList();
  }

  /// Single building by id (Firestore doc id or local id).
  Future<Building?> byId(String id) async {
    final allBuildings = await all();
    for (final b in allBuildings) {
      if (b.id == id) return b;
    }
    return null;
  }

  /// Clears the cache so the next call refetches from Firestore.
  void invalidate() => _cache = null;

  Future<List<Building>> _load() async {
    final local = DummyData.buildings;
    var remote = const <Building>[];
    try {
      if (Firebase.apps.isNotEmpty) {
        final snapshots = await Future.wait([
          for (final area in DummyData.areas)
            FirebaseFirestore.instance
                .collection('buildings')
                .doc(area)
                .collection('units')
                .where('isPublished', isEqualTo: true)
                .get(const GetOptions(source: Source.serverAndCache)),
        ]);
        remote = snapshots
            .expand((snap) => snap.docs)
            .map((doc) => adminBuildingToBuilding(
                  AdminBuilding.fromFirestore(doc.id, doc.data()),
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

  bool _areaMatches(String bldArea, String area) {
    if (bldArea == area) return true;
    if (area == 'النرجس الجديدة' && bldArea == 'النرجس') return true;
    if (area == 'النرجس' && bldArea == 'النرجس الجديدة') return true;
    return false;
  }
}
