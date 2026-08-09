import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  /// plus any remaining legacy flat docs, newest first.
  Future<List<Property>> fetchAll() async {
    final areaSnaps = await Future.wait([
      for (final area in areaOptions) _units(area).get(),
    ]);

    // Legacy flat docs are still read until the migration deletes them.
    final legacySnap = await _legacyCollection.get();

    final byId = <String, Property>{};
    for (final snap in [legacySnap, ...areaSnaps]) {
      for (final doc in snap.docs) {
        byId[doc.id] = Property.fromFirestore(doc.id, doc.data());
      }
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

  /// Creates a new property document in its area folder. Newly picked images
  /// are uploaded to Storage first, then their URLs are stored with the doc.
  Future<String> create(Property property, List<XFile> newImages) async {
    final urls = await _upload(newImages);
    final doc = await _units(property.area).add(
      property.copyWith(imageUrls: [...property.imageUrls, ...urls]).toFirestore(),
    );
    PublicPropertyRepository.instance.invalidate();
    return doc.id;
  }

  /// Updates an existing property. Images in [removedImageUrls] are deleted
  /// from Storage; newly picked images are uploaded.
  Future<void> update(
    String id,
    Property property,
    List<XFile> newImages,
    List<String> removedImageUrls,
  ) async {
    if (removedImageUrls.isNotEmpty) {
      await _deleteStorageFiles(removedImageUrls);
    }
    final urls = await _upload(newImages);
    final keptUrls = property.imageUrls
        .where((url) => !removedImageUrls.contains(url))
        .toList();
    await _units(property.area).doc(id).update(
          property
              .copyWith(imageUrls: [...keptUrls, ...urls])
              .toFirestore(isUpdate: true),
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

  Future<List<String>> _upload(List<XFile> files) async {
    final urls = <String>[];
    for (final file in files) {
      final name = file.name.isNotEmpty
          ? file.name
          : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref('properties/${DateTime.now().millisecondsSinceEpoch}_$name');
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
