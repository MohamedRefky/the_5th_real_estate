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
  PublicPropertyRepository();

  static final PublicPropertyRepository instance =
      PublicPropertyRepository();

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

        // 1. Launch ALL queries simultaneously in parallel
        final List<Future<dynamic>> futures = [
          FirebaseFirestore.instance.collection('properties').get(),
          FirebaseFirestore.instance.collection('buildings').get(),
          FirebaseFirestore.instance.collectionGroup('units').get(),
        ];

        for (final rootCol in ['properties', 'buildings']) {
          for (final area in targetAreas) {
            futures.add(
              FirebaseFirestore.instance
                  .collection(rootCol)
                  .doc(area)
                  .collection('units')
                  .get(),
            );
          }
        }

        final results = await Future.wait(futures, eagerError: false);

        // 2. Process root collections (indices 0 and 1)
        for (var i = 0; i < 2; i++) {
          final res = results[i];
          if (res is QuerySnapshot<Map<String, dynamic>>) {
            for (final areaDoc in res.docs) {
              final areaId = areaDoc.id;
              final areaData = areaDoc.data();
              if (areaData.containsKey('projectName') ||
                  areaData.containsKey('price') ||
                  areaData.containsKey('unitType')) {
                final isPublished = (areaData['isPublished'] as bool?) ?? true;
                if (isPublished) {
                  try {
                    byId[areaDoc.id] = propertyToApartment(
                      admin.Property.fromFirestore(
                        areaDoc.id,
                        areaData,
                        fallbackArea: areaData['area'] as String? ?? areaId,
                      ),
                    );
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error parsing property doc ${areaDoc.id}: $e');
                    }
                  }
                }
              }
            }
          }
        }

        // 3. Process unit subcollections (indices 2 onwards)
        for (var i = 2; i < results.length; i++) {
          final res = results[i];
          if (res is QuerySnapshot<Map<String, dynamic>>) {
            for (final doc in res.docs) {
              if (!byId.containsKey(doc.id)) {
                final data = doc.data();
                final isPublished = (data['isPublished'] as bool?) ?? true;
                if (isPublished) {
                  final parentAreaId = doc.reference.parent.parent?.id;
                  try {
                    byId[doc.id] = propertyToApartment(
                      admin.Property.fromFirestore(
                        doc.id,
                        data,
                        fallbackArea: parentAreaId,
                      ),
                    );
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error parsing unit doc ${doc.id}: $e');
                    }
                  }
                }
              }
            }
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
