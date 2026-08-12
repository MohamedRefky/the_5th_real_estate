import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import 'app_router.dart';

/// Root widget for The 5th Real Estate.
///
/// Configured with:
/// - Arabic (ar) locale and RTL directionality
/// - Material 3 luxurious light theme
/// - Named-route navigation via [AppRouter]
class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The 5th Real Estate',
      debugShowCheckedModeBanner: false,

      // ── Arabic & RTL ──────────────────────────────────────────
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Theme ─────────────────────────────────────────────────
      theme: AppTheme.light,

      // ── Routing ───────────────────────────────────────────────
      initialRoute: RoutesNames.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
