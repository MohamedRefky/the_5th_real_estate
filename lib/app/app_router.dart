import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';

/// Centralised route names — single source of truth for navigation.
class RoutesNames {
  RoutesNames._();

  static const String home = '/';
  static const String area = '/area';
  static const String apartmentDetails = '/apartment-details';
}

/// Generates routes for [MaterialApp.onGenerateRoute].
///
/// Area screen and Apartment details screen will be added in later steps.
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.home:
        return _buildRoute(const HomeScreen(), settings);

      case RoutesNames.area:
        final areaName = settings.arguments as String;
        // Will be replaced with AreaScreen in Step 4
        return _buildRoute(
          Scaffold(
            appBar: AppBar(title: Text(areaName)),
            body: Center(child: Text('شقق $areaName — قريباً')),
          ),
          settings,
        );

      case RoutesNames.apartmentDetails:
        final apartmentId = settings.arguments as String;
        // Will be replaced with ApartmentDetailsScreen in Step 5
        return _buildRoute(
          Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الشقة')),
            body: Center(child: Text('تفاصيل الشقة $apartmentId — قريباً')),
          ),
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

  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
