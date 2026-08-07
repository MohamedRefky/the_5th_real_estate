import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';

/// Root widget for "The 5th Estate" — العقار الخامس
///
/// Configured with:
/// - Arabic (ar) locale and RTL directionality
/// - Material 3 luxurious light theme
/// - Named-route navigation (routes added in later steps)
class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'العقار الخامس',
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

      // ── Placeholder Home ──────────────────────────────────────
      // Will be replaced with actual routes in Step 3
      home: const _PlaceholderHome(),
    );
  }
}

/// Temporary placeholder to verify theme + RTL are working.
/// This will be removed once the Home Screen is built.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('العقار الخامس'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_work_rounded,
              size: 80,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            Text(
              'مرحباً بك في العقار الخامس',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'جاري بناء التطبيق...',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text('ابدأ الآن'),
            ),
          ],
        ),
      ),
    );
  }
}
