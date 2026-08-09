import 'package:firebase_core/firebase_core.dart';

import '../../../firebase_options.dart';

/// Lazy, single-flight Firebase initialization.
///
/// The public site never calls this — only the hidden admin area does, so the
/// public pages keep working even before real Firebase config exists.
class AppFirebase {
  AppFirebase._();

  static bool _initializing = false;

  static Future<FirebaseApp> initialize() async {
    if (Firebase.apps.isNotEmpty) return Firebase.apps.first;
    if (_initializing) {
      while (Firebase.apps.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      return Firebase.apps.first;
    }
    _initializing = true;
    try {
      if (!DefaultFirebaseOptions.isConfigured) {
        throw StateError(
          'Firebase is not configured yet. Run `flutterfire configure` '
          'and follow FIREBASE_SETUP.md.',
        );
      }
      final app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initializing = false;
      return app;
    } catch (_) {
      _initializing = false;
      rethrow;
    }
  }
}
