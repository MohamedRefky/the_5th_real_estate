import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/auth_controller.dart';

/// Wraps admin screens. Initializes Firebase/auth, and redirects signed-out
/// visitors to the hidden login page. The real security boundary is the
/// Firestore/Storage Security Rules — this only hides the admin UI.
class AdminRouteGuard extends StatefulWidget {
  final Widget child;
  const AdminRouteGuard({super.key, required this.child});

  @override
  State<AdminRouteGuard> createState() => _AdminRouteGuardState();
}

class _AdminRouteGuardState extends State<AdminRouteGuard> {
  bool _ready = false;
  bool _signedIn = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await AuthController.instance.ensureInitialized();
      if (!mounted) return;
      setState(() {
        _ready = true;
        _signedIn = AuthController.instance.isSignedIn;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _ready = true);
      _showSetupError(e);
    }
  }

  void _showSetupError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تعذر تشغيل Firebase: $e'),
        backgroundColor: AppColors.error,
      ),
    );
    Navigator.pushReplacementNamed(context, RoutesNames.adminLogin);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }
    if (!_signedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesNames.adminLogin);
        }
      });
      return const SizedBox.shrink();
    }
    return widget.child;
  }
}
