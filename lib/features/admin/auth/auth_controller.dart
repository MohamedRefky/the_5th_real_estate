import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

  /// Signs in with email + password (admin account only — no sign-up UI).
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Signs out of Firebase Auth.
  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
