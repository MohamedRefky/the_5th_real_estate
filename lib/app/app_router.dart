import 'package:flutter/material.dart';

import '../features/admin/screens/dashboard_screen.dart';
import '../features/admin/screens/login_screen.dart';
import '../features/admin/widgets/admin_route_guard.dart';
import '../features/apartment_details/apartment_details_screen.dart';
import '../features/area/area_screen.dart';
import '../features/building_area/buildings_area_screen.dart';
import '../features/building_details/building_details_screen.dart';
import '../features/home/home_screen.dart';

/// Centralised route names — single source of truth for navigation.
class RoutesNames {
  RoutesNames._();

  static const String home = '/';
  static const String area = '/area';
  static const String buildingsArea = '/buildings-area';
  static const String apartmentDetails = '/apartment-details';
  static const String buildingDetails = '/building-details';

  // Hidden admin routes — never linked from the public UI.
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
}

/// Generates routes for [MaterialApp.onGenerateRoute].
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.home:
        return _buildRoute(const HomeScreen(), settings);

      case RoutesNames.area:
        final areaName = (settings.arguments is String)
            ? (settings.arguments as String)
            : 'المستثمرين';
        return _buildRoute(AreaScreen(areaName: areaName), settings);

      case RoutesNames.buildingsArea:
        final areaName = (settings.arguments is String)
            ? (settings.arguments as String)
            : 'المستثمرين';
        return _buildRoute(BuildingsAreaScreen(areaName: areaName), settings);

      case RoutesNames.apartmentDetails:
        final apartmentId = (settings.arguments is String)
            ? (settings.arguments as String)
            : 'apt_001';
        return _buildRoute(
          ApartmentDetailsScreen(apartmentId: apartmentId),
          settings,
        );

      case RoutesNames.buildingDetails:
        final buildingId = (settings.arguments is String)
            ? (settings.arguments as String)
            : 'bld_003';
        return _buildRoute(
          BuildingDetailsScreen(buildingId: buildingId),
          settings,
        );

      case RoutesNames.adminLogin:
        return _buildRoute(const AdminLoginScreen(), settings);

      case RoutesNames.adminDashboard:
        return _buildRoute(
          const AdminRouteGuard(child: AdminDashboardScreen()),
          settings,
        );

      default:
        return _buildRoute(
          const Scaffold(
            body: Center(child: Text('الصفحة غير موجودة')),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
