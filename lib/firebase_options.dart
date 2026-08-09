import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Firebase options for the FlutterFire SDKs.
///
/// Values from the Firebase console (Web app `real-estate-app-7031d`).
/// If you re-run `flutterfire configure` this file is regenerated.
class DefaultFirebaseOptions {
  static const FirebaseOptions _options = FirebaseOptions(
    apiKey: 'AIzaSyAKsjPqjRTxJ2usZPZqUMuoDL9iP8Tj76A',
    appId: '1:200241901984:web:e4db36925ae15e382434c5',
    messagingSenderId: '200241901984',
    projectId: 'real-estate-app-7031d',
    authDomain: 'real-estate-app-7031d.firebaseapp.com',
    storageBucket: 'real-estate-app-7031d.firebasestorage.app',
    measurementId: 'G-M0BE9Z89SK',
  );

  static FirebaseOptions get currentPlatform => _options;

  /// True once real config is present (guards against leftover placeholders).
  static bool get isConfigured =>
      _options.apiKey.isNotEmpty &&
      !_options.apiKey.startsWith('YOUR_') &&
      _options.projectId.isNotEmpty &&
      !_options.projectId.startsWith('YOUR_');
}
