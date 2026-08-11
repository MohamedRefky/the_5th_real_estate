import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../data/public_property_repository.dart';
import '../models/property.dart';

/// All reads/writes to the `properties/{area}/units` subcollections for the
/// admin dashboard. Each unit document lives under its neighborhood's folder,
/// mirroring the public website organization.
///
/// During the data-migration window the legacy flat `properties` collection
/// is also read so nothing disappears; writes always target the new per-area
/// structure.
///
/// Security is enforced by the Firestore Security Rules (admin UID only for
/// writes); this service only runs inside the authenticated admin area.
class PropertyService {
  PropertyService._();

  static final PropertyService instance = PropertyService._();

  CollectionReference<Map<String, dynamic>> get _legacyCollection =>
      FirebaseFirestore.instance.collection('properties');

  CollectionReference<Map<String, dynamic>> _units(String area) =>
      FirebaseFirestore.instance
          .collection('properties')
          .doc(area)
          .collection('units');

  /// All properties (published and hidden) across the new per-area folders
  /// plus legacy flat docs and collectionGroup units, newest first.
  Future<List<Property>> fetchAll() async {
    final byId = <String, Property>{};
    Object? lastError;

    // 1. Per-area subcollections
    for (final area in areaOptions) {
      try {
        final snap = await _units(area).get();
        for (final doc in snap.docs) {
          byId[doc.id] = Property.fromFirestore(
            doc.id,
            doc.data(),
            fallbackArea: doc.data()['area'] as String? ?? area,
          );
        }
      } catch (e) {
        lastError = e;
        if (kDebugMode) {
          print('Error fetching properties for area $area: $e');
        }
      }
    }

    // 2. Legacy root collection
    try {
      final legacySnap = await _legacyCollection.get();
      for (final doc in legacySnap.docs) {
        if (!byId.containsKey(doc.id)) {
          byId[doc.id] = Property.fromFirestore(doc.id, doc.data());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching legacy properties: $e');
      }
    }

    // 3. Collection group (best effort fallback)
    try {
      final groupSnap =
          await FirebaseFirestore.instance.collectionGroup('units').get();
      for (final doc in groupSnap.docs) {
        if (!byId.containsKey(doc.id)) {
          final data = doc.data();
          if (data.containsKey('unitType') ||
              data.containsKey('bedrooms') ||
              doc.reference.path.contains('properties')) {
            final parentAreaId = doc.reference.parent.parent?.id;
            byId[doc.id] = Property.fromFirestore(
              doc.id,
              data,
              fallbackArea: data['area'] as String? ?? parentAreaId,
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collectionGroup units: $e');
      }
    }

    if (byId.isEmpty && lastError != null) {
      throw lastError;
    }

    final items = byId.values.toList()
      ..sort((a, b) {
        final aT = a.updatedAt ?? a.createdAt;
        final bT = b.updatedAt ?? b.createdAt;
        if (aT == null && bT == null) return 0;
        if (aT == null) return 1;
        if (bT == null) return -1;
        return bT.compareTo(aT);
      });
    return items;
  }

  /// Creates a new property document in its area folder.
  Future<String> create(Property property) async {
    final doc = await _units(property.area).add(
      property.toFirestore(),
    );
    PublicPropertyRepository.instance.invalidate();
    return doc.id;
  }

  /// Updates an existing property.
  Future<void> update(
    String id,
    Property property,
  ) async {
    await _units(property.area).doc(id).update(
          property.toFirestore(isUpdate: true),
        );
    PublicPropertyRepository.instance.invalidate();
  }

  /// Toggles published status without touching the rest of the document.
  Future<void> setPublished(String id, Property property, bool value) async {
    await _units(property.area).doc(id).update({
      'isPublished': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    PublicPropertyRepository.instance.invalidate();
  }

  /// Deletes the property document and its images from Storage.
  Future<void> delete(String id, Property property) async {
    if (property.imageUrls.isNotEmpty) {
      await _deleteStorageFiles(property.imageUrls);
    }
    await _units(property.area).doc(id).delete();
    PublicPropertyRepository.instance.invalidate();
  }

  Future<void> _deleteStorageFiles(List<String> urls) async {
    for (final url in urls) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      } catch (_) {
        // Best-effort: the file may already be gone.
      }
    }
  }
}
