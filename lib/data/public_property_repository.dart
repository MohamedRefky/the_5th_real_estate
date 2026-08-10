import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../features/admin/models/property.dart' as admin show Property, areaOptions;
import '../models/apartment.dart';
import 'dummy_data.dart';
import 'mappers/property_mapper.dart';

/// Public-facing apartment data source for the website.
///
/// Merges local bundled listings ([DummyData]) with PUBLISHED properties
/// stored in Firestore by the admin dashboard. Firestore listings appear on
/// the website instantly after being added.
class PublicPropertyRepository {
  PublicPropertyRepository._();

  static final PublicPropertyRepository instance =
      PublicPropertyRepository._();

  List<Apartment>? _cache;

  /// All apartments (published Firestore only), newest first.
  Future<List<Apartment>> all({bool forceRefresh = true}) async {
    if (!forceRefresh && _cache != null) return _cache!;
    return _load();
  }

  /// Apartments belonging to [area].
  Future<List<Apartment>> byArea(String area, {bool forceRefresh = true}) async {
    final allApartments = await all(forceRefresh: forceRefresh);
    final results = allApartments.where((apt) => _areaMatches(apt.area, area)).toList();
    if (results.isEmpty && allApartments.isNotEmpty) {
      final cleanTarget = area.trim().replaceAll('حي ', '').replaceAll('منطقة ', '');
      final fallback = allApartments.where((apt) {
        final cleanApt = apt.area.trim().replaceAll('حي ', '').replaceAll('منطقة ', '');
        return cleanApt.contains(cleanTarget) || cleanTarget.contains(cleanApt);
      }).toList();
      if (fallback.isNotEmpty) return fallback;
    }
    return results;
  }

  /// Single apartment by id (Firestore doc id).
  Future<Apartment?> byId(String id) async {
    final allApartments = await all(forceRefresh: true);
    for (final apt in allApartments) {
      if (apt.id == id) return apt;
    }
    return null;
  }

  /// Clears the cache so the next call refetches from Firestore.
  void invalidate() => _cache = null;

  Future<List<Apartment>> _load() async {
    var remote = <Apartment>[];
    try {
      if (Firebase.apps.isNotEmpty) {
        final byId = <String, Apartment>{};

        // 1. Dynamic fetch: Read all area documents under `properties` and `buildings`
        for (final rootCol in ['properties', 'buildings']) {
          try {
            final rootSnap = await FirebaseFirestore.instance
                .collection(rootCol)
                .get();

            for (final areaDoc in rootSnap.docs) {
              final areaId = areaDoc.id; // e.g. "جاردينيا", "المستثمرين", etc.
              final areaData = areaDoc.data();

              // Check if the area document itself is a property document (legacy flat structure)
              if (areaData.containsKey('projectName') ||
                  areaData.containsKey('price') ||
                  areaData.containsKey('unitType')) {
                final isPublished = (areaData['isPublished'] as bool?) ?? true;
                if (isPublished) {
                  byId[areaDoc.id] = propertyToApartment(
                    admin.Property.fromFirestore(
                      areaDoc.id,
                      areaData,
                      fallbackArea: areaData['area'] as String? ?? areaId,
                    ),
                  );
                }
              }

              // Read `properties/{areaId}/units` subcollection
              try {
                final unitsSnap = await areaDoc.reference.collection('units').get();
                for (final unitDoc in unitsSnap.docs) {
                  final data = unitDoc.data();
                  final isPublished = (data['isPublished'] as bool?) ?? true;
                  if (isPublished) {
                    byId[unitDoc.id] = propertyToApartment(
                      admin.Property.fromFirestore(
                        unitDoc.id,
                        data,
                        fallbackArea: areaId, // <-- INFER AREA FROM PARENT DOC ID ("جاردينيا")!
                      ),
                    );
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  print('Error fetching units for $rootCol/$areaId: $e');
                }
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error fetching $rootCol collection: $e');
            }
          }
        }

        // 2. CollectionGroup query across all 'units' subcollections as a backup
        try {
          final groupSnap = await FirebaseFirestore.instance
              .collectionGroup('units')
              .get();
          for (final doc in groupSnap.docs) {
            if (!byId.containsKey(doc.id)) {
              final data = doc.data();
              final isPublished = (data['isPublished'] as bool?) ?? true;
              if (isPublished) {
                final parentAreaId = doc.reference.parent.parent?.id;
                byId[doc.id] = propertyToApartment(
                  admin.Property.fromFirestore(
                    doc.id,
                    data,
                    fallbackArea: parentAreaId,
                  ),
                );
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('CollectionGroup query notice: $e');
          }
        }

        // 3. Fallback for hardcoded areas in admin.areaOptions & DummyData.areas
        final targetAreas = {
          ...DummyData.areas,
          ...admin.areaOptions,
          'جاردينيا',
          'بيت الوطن',
          'الأندلس',
          'المستثمرين',
          'النرجس الجديدة',
          'النرجس',
        };

        for (final rootCol in ['properties', 'buildings']) {
          for (final area in targetAreas) {
            try {
              final snap = await FirebaseFirestore.instance
                  .collection(rootCol)
                  .doc(area)
                  .collection('units')
                  .get();
              for (final doc in snap.docs) {
                if (!byId.containsKey(doc.id)) {
                  final data = doc.data();
                  final isPublished = (data['isPublished'] as bool?) ?? true;
                  if (isPublished) {
                    byId[doc.id] = propertyToApartment(
                      admin.Property.fromFirestore(
                        doc.id,
                        data,
                        fallbackArea: area,
                      ),
                    );
                  }
                }
              }
            } catch (_) {}
          }
        }

        remote = byId.values.toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Firestore properties: $e');
      }
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

  bool _areaMatches(String aptArea, String area) {
    final cleanApt = aptArea.trim()
        .replaceAll('حي ', '')
        .replaceAll('منطقة ', '')
        .replaceAll('جاردنيا', 'جاردينيا');
    final cleanArea = area.trim()
        .replaceAll('حي ', '')
        .replaceAll('منطقة ', '')
        .replaceAll('جاردنيا', 'جاردينيا');
    if (cleanApt == cleanArea) return true;
    if (cleanApt.contains(cleanArea) || cleanArea.contains(cleanApt)) return true;
    if (cleanArea == 'النرجس الجديدة' && cleanApt.contains('النرجس')) return true;
    if (cleanArea == 'النرجس' && cleanApt.contains('النرجس')) return true;
    return false;
  }
}
