import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/public_building_repository.dart';
import '../models/admin_building.dart';
import '../models/property.dart';

/// All reads/writes to the `buildings/{area}/units` subcollections for the
/// admin dashboard. Each building document lives under its neighborhood's
/// folder, mirroring the public website organization.
///
/// Security is enforced by the Firestore Security Rules (admin UID only for
/// writes); this service only runs inside the authenticated admin area.
class BuildingService {
  BuildingService._();

  static final BuildingService instance = BuildingService._();

  CollectionReference<Map<String, dynamic>> _units(String area) =>
      FirebaseFirestore.instance
          .collection('buildings')
          .doc(area)
          .collection('units');

  /// All buildings (published and hidden) across all areas, newest first.
  Future<List<AdminBuilding>> fetchAll() async {
    final byId = <String, AdminBuilding>{};

    // 1. Per-area subcollections
    for (final area in areaOptions) {
      try {
        final snap = await _units(area).get();
        for (final doc in snap.docs) {
          byId[doc.id] = AdminBuilding.fromFirestore(
            doc.id,
            doc.data(),
            fallbackArea: doc.data()['area'] as String? ?? area,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching buildings for area $area: $e');
        }
      }
    }

    // 2. Legacy root collection
    try {
      final legacySnap =
          await FirebaseFirestore.instance.collection('buildings').get();
      for (final doc in legacySnap.docs) {
        if (!byId.containsKey(doc.id)) {
          byId[doc.id] = AdminBuilding.fromFirestore(doc.id, doc.data());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching legacy buildings: $e');
      }
    }

    // 3. Collection group (best effort fallback)
    try {
      final groupSnap =
          await FirebaseFirestore.instance.collectionGroup('units').get();
      for (final doc in groupSnap.docs) {
        if (!byId.containsKey(doc.id)) {
          final data = doc.data();
          if (data.containsKey('totalFloors') ||
              data.containsKey('availableUnits') ||
              data.containsKey('buildingStructure') ||
              doc.reference.path.contains('buildings')) {
            final parentAreaId = doc.reference.parent.parent?.id;
            byId[doc.id] = AdminBuilding.fromFirestore(
              doc.id,
              data,
              fallbackArea: data['area'] as String? ?? parentAreaId,
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collectionGroup building units: $e');
      }
    }

    final docs = byId.values.toList()
      ..sort((a, b) {
        final aT = a.updatedAt ?? a.createdAt;
        final bT = b.updatedAt ?? b.createdAt;
        if (aT == null && bT == null) return 0;
        if (aT == null) return 1;
        if (bT == null) return -1;
        return bT.compareTo(aT);
      });
    return docs;
  }

  /// Creates a new building document in its area folder. Newly picked images
  /// are uploaded to Storage first, then their URLs are stored with the doc.
  Future<String> create(AdminBuilding building, List<XFile> newImages) async {
    final urls = await _upload(newImages);
    final doc = await _units(building.area).add(
      building
          .copyWith(imageUrls: [...building.imageUrls, ...urls])
          .toFirestore(),
    );
    PublicBuildingRepository.instance.invalidate();
    return doc.id;
  }

  /// Updates an existing building. Images in [removedImageUrls] are deleted
  /// from Storage; newly picked images are uploaded.
  Future<void> update(
    String id,
    AdminBuilding building,
    List<XFile> newImages,
    List<String> removedImageUrls,
  ) async {
    if (removedImageUrls.isNotEmpty) {
      await _deleteStorageFiles(removedImageUrls);
    }
    final urls = await _upload(newImages);
    final keptUrls = building.imageUrls
        .where((url) => !removedImageUrls.contains(url))
        .toList();
    await _units(building.area).doc(id).update(
          building
              .copyWith(imageUrls: [...keptUrls, ...urls])
              .toFirestore(isUpdate: true),
        );
    PublicBuildingRepository.instance.invalidate();
  }

  /// Toggles published status without touching the rest of the document.
  Future<void> setPublished(String id, AdminBuilding building, bool value) async {
    await _units(building.area).doc(id).update({
      'isPublished': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    PublicBuildingRepository.instance.invalidate();
  }

  /// Deletes the building document and its images from Storage.
  Future<void> delete(String id, AdminBuilding building) async {
    if (building.imageUrls.isNotEmpty) {
      await _deleteStorageFiles(building.imageUrls);
    }
    await _units(building.area).doc(id).delete();
    PublicBuildingRepository.instance.invalidate();
  }

  Future<List<String>> _upload(List<XFile> files) async {
    final urls = <String>[];
    for (final file in files) {
      final name = file.name.isNotEmpty
          ? file.name
          : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref('buildings/${DateTime.now().millisecondsSinceEpoch}_$name');
      await ref.putData(await file.readAsBytes());
      urls.add(await ref.getDownloadURL());
    }
    return urls;
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
