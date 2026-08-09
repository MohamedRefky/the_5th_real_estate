import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/public_property_repository.dart';
import '../models/property.dart';

/// All reads/writes to the `properties` collection for the admin dashboard.
///
/// Security is enforced by the Firestore Security Rules (admin UID only for
/// writes); this service only runs inside the authenticated admin area.
class PropertyService {
  PropertyService._();

  static final PropertyService instance = PropertyService._();

  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('properties');

  /// All properties (published and hidden), newest first.
  Future<List<Property>> fetchAll() async {
    final snapshot = await _collection
        .orderBy('updatedAt', descending: true)
        .get(const GetOptions(source: Source.serverAndCache));
    return snapshot.docs
        .map((doc) => Property.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /// Creates a new property document. New picked images are uploaded to
  /// Storage first, then their URLs are stored with the document.
  Future<String> create(Property property, List<XFile> newImages) async {
    final urls = await _upload(newImages);
    final doc = await _collection.add(
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
    await _collection.doc(id).update(
          property
              .copyWith(imageUrls: [...keptUrls, ...urls])
              .toFirestore(isUpdate: true),
        );
    PublicPropertyRepository.instance.invalidate();
  }

  /// Toggles published status without touching the rest of the document.
  Future<void> setPublished(String id, bool isPublished) async {
    await _collection.doc(id).update({
      'isPublished': isPublished,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    PublicPropertyRepository.instance.invalidate();
  }

  /// Deletes the property document and its images from Storage.
  Future<void> delete(String id, List<String> imageUrls) async {
    if (imageUrls.isNotEmpty) {
      await _deleteStorageFiles(imageUrls);
    }
    await _collection.doc(id).delete();
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
