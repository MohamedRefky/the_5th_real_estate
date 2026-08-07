import 'package:flutter/material.dart';

import '../screens/apartment_details/apartment_details_screen.dart';
import '../screens/area/area_screen.dart';
import '../screens/home/home_screen.dart';

/// Centralised route names — single source of truth for navigation.
class RoutesNames {
  RoutesNames._();

  static const String home = '/';
  static const String area = '/area';
  static const String apartmentDetails = '/apartment-details';
}

/// Generates routes for [MaterialApp.onGenerateRoute].
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.home:
        return _buildRoute(HomeScreen(), settings);

      case RoutesNames.area:
        final areaName = settings.arguments;
        if (areaName is! String) {
          // Restored route without arguments (e.g. after an app restart).
          return _buildRoute(HomeScreen(), settings);
        }
        return _buildRoute(AreaScreen(areaName: areaName), settings);

      case RoutesNames.apartmentDetails:
        final apartmentId = settings.arguments;
        if (apartmentId is! String) {
          // Restored route without arguments (e.g. after an app restart).
          return _buildRoute(HomeScreen(), settings);
        }
        return _buildRoute(
          ApartmentDetailsScreen(apartmentId: apartmentId),
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
