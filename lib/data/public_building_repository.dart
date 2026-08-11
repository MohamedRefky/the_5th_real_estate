import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_5th_real_estate/data/dummy_data.dart';
import '../features/admin/models/admin_building.dart';
import '../models/building.dart';
import 'mappers/building_mapper.dart';

class PublicBuildingRepository {
  PublicBuildingRepository();

  static final PublicBuildingRepository instance =
      PublicBuildingRepository();

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
    var remote = <Building>[];
    try {
      if (Firebase.apps.isNotEmpty) {
        final byId = <String, Building>{};
        final targetAreas = {
          ...DummyData.areas,
          'جاردينيا',
          'بيت الوطن',
          'الأندلس',
          'المستثمرين',
          'النرجس الجديدة',
          'النرجس',
        };

        for (final area in targetAreas) {
          try {
            final snap = await FirebaseFirestore.instance
                .collection('buildings')
                .doc(area)
                .collection('units')
                .get();
            for (final doc in snap.docs) {
              final data = doc.data();
              final isPublished = (data['isPublished'] as bool?) ?? true;
              if (isPublished) {
                byId[doc.id] = adminBuildingToBuilding(
                  AdminBuilding.fromFirestore(doc.id, data),
                );
              }
            }
          } catch (_) {}
        }
        remote = byId.values.toList();
      }
    } catch (_) {
      remote = const [];
    }

    final merged = [...remote];
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
