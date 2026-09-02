import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/constants/admin_config.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/auth_controller.dart';

/// Wraps admin screens with an Auth Guard.
///
/// Verifies that:
/// 1. `FirebaseAuth.instance.currentUser` is not null.
/// 2. The logged-in user's email exists in [AdminConfig.allowedAdminEmails].
///
/// If unauthenticated or unauthorized, immediately redirects to [RoutesNames.adminLogin].
class AdminRouteGuard extends StatefulWidget {
  final Widget child;
  const AdminRouteGuard({super.key, required this.child});

  @override
  State<AdminRouteGuard> createState() => _AdminRouteGuardState();
}

class _AdminRouteGuardState extends State<AdminRouteGuard> {
  bool _ready = false;
  bool _authorized = false;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initAuthGuard();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initAuthGuard() async {
    try {
      await AuthController.instance.ensureInitialized();

      // Check immediately
      final isAllowed = await _evaluateAuthorization();

      // Listen to future auth state changes (e.g. logout or token expiration)
      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((user) async {
        final allowed = await _evaluateAuthorization();
        if (mounted && allowed != _authorized) {
          setState(() => _authorized = allowed);
          if (!allowed) {
            _redirectToLogin();
          }
        }
      });

      if (!mounted) return;
      setState(() {
        _ready = true;
        _authorized = isAllowed;
      });

      if (!isAllowed) {
        _redirectToLogin();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _ready = true);
      _redirectToLogin(errorMessage: 'تعذر التحقق من الصلاحيات: $e');
    }
  }

  Future<bool> _evaluateAuthorization() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final email = user.email?.trim().toLowerCase();
    if (email == null || email.isEmpty) {
      await FirebaseAuth.instance.signOut();
      return false;
    }

    final isAllowed = AdminConfig.allowedAdminEmails
        .any((allowed) => allowed.trim().toLowerCase() == email);

    if (!isAllowed) {
      // Sign out unauthorized users immediately
      await FirebaseAuth.instance.signOut();
      return false;
    }

    return true;
  }

  void _redirectToLogin({String? errorMessage}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesNames.adminLogin,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || !_authorized) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    return widget.child;
  }
}
