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
        return _buildRoute(const HomeScreen(), settings);

      case RoutesNames.area:
        final areaName = settings.arguments as String;
        return _buildRoute(AreaScreen(areaName: areaName), settings);

      case RoutesNames.apartmentDetails:
        final apartmentId = settings.arguments as String;
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

  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
