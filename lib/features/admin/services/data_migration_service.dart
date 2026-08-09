import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/property.dart';
import '../../../data/public_property_repository.dart';

/// Summary of a one-off data migration run.
class MigrationResult {
  final int migrated;
  final int skipped;
  final int failed;
  final int deleted;

  const MigrationResult({
    required this.migrated,
    required this.skipped,
    required this.failed,
    required this.deleted,
  });

  bool get hasFailures => failed > 0;
}

/// Moves documents from the legacy flat `properties` collection into the new
/// per-area folders `properties/{area}/units` (same doc id), so data uploaded
/// before the reorganization keeps appearing in the right neighborhood.
///
/// Idempotent: documents already present in the target folder are skipped.
class DataMigrationService {
  DataMigrationService._();

  static Future<MigrationResult> migrateLegacyProperties({
    bool deleteLegacy = false,
  }) async {
    final legacy = await FirebaseFirestore.instance
        .collection('properties')
        .get();

    var migrated = 0;
    var skipped = 0;
    var failed = 0;

    for (final doc in legacy.docs) {
      final area = (doc.data()['area'] as String?) ?? areaOptions.first;
      final target = FirebaseFirestore.instance
          .collection('properties')
          .doc(area)
          .collection('units')
          .doc(doc.id);

      try {
        if ((await target.get()).exists) {
          skipped++;
          continue;
        }
        await target.set(doc.data());
        migrated++;
      } catch (_) {
        failed++;
      }
    }

    var deleted = 0;
    if (deleteLegacy) {
      for (final doc in legacy.docs) {
        try {
          await doc.reference.delete();
          deleted++;
        } catch (_) {
          // Keep going; a leftover doc is harmless.
        }
      }
    }

    if (migrated > 0 || deleteLegacy) {
      PublicPropertyRepository.instance.invalidate();
    }

    return MigrationResult(
      migrated: migrated,
      skipped: skipped,
      failed: failed,
      deleted: deleted,
    );
  }
}
