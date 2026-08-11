import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/firebase/app_firebase.dart';

/// Auth state notifier for the hidden admin area.
///
/// Listens to `FirebaseAuth.authStateChanges` and notifies listeners whenever
/// the signed-in state changes. Route guarding and the login/dashboard screens
/// watch this instead of polling the auth SDK.
class AuthController extends ChangeNotifier {
  AuthController._();

  static final AuthController instance = AuthController._();

  User? get user => FirebaseAuth.instance.currentUser;
  bool get isSignedIn => user != null;

  /// Returns true ONLY if the current signed-in user's email is in the allowed admin list.
  bool get isAuthorizedAdmin {
    final u = user;
    if (u == null || u.email == null || u.email!.trim().isEmpty) return false;
    final email = u.email!.trim().toLowerCase();
    return AppConstants.allowedAdminEmails
        .any((allowed) => allowed.toLowerCase() == email);
  }

  bool _listening = false;
  bool _initialized = false;

  /// Initializes Firebase (if needed) and starts listening to auth changes.
  /// Safe to call multiple times.
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    await AppFirebase.initialize();
    if (!_listening) {
      _listening = true;
      FirebaseAuth.instance.authStateChanges().listen((_) => notifyListeners());
    }
    _initialized = true;
  }

  void _checkAuthorization() {
    if (user != null && !isAuthorizedAdmin) {
      signOut();
      throw FirebaseAuthException(
        code: 'unauthorized-admin',
        message:
            'عفواً، هذا البريد الإلكتروني ليس مصرحاً له بالوصول إلى لوحة التحكم.',
      );
    }
  }

  /// Signs in with email + password (admin account only — no sign-up UI).
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _checkAuthorization();
  }

  /// Signs in with the Google account (popup flow — web only).
  ///
  /// On web this uses the Firebase `signInWithPopup` flow, which opens
  /// Google's OAuth popup. Desktop/mobile need the `google_sign_in` plugin.
  Future<void> signInWithGoogle() async {
    if (!kIsWeb) {
      throw UnimplementedError(
        'Google sign-in is implemented for web only — '
        'add the google_sign_in plugin for desktop/mobile.',
      );
    }
    await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    _checkAuthorization();
  }

  /// Signs out of Firebase Auth.
  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
