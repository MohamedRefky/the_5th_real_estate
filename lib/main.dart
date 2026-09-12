import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:the_5th_real_estate/core/firebase/firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch all synchronous framework build errors silently
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  // Catch all unhandled asynchronous errors across the app
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Global async error suppressed cleanly: $error');
    return true; // Prevents any crash or error dialog
  };

  // Never render red screens or white error boxes to the user.
  // Failing sub-widgets degrade silently while the page stays 100% functional.
  ErrorWidget.builder = (details) => const SizedBox.shrink();

  // Preload local fonts and initialize Firebase concurrently while native splash covers the screen
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    _preloadCairo(),
  ]);

  // Clean URLs (no `#/`) so /admin/login, /admin/dashboard work directly.
  usePathUrlStrategy();

  runApp(const TheApp());
}

/// Preloads local Cairo TTF fonts directly into the Flutter engine's font manager
/// before the first frame is rendered, eliminating missing-glyph boxes (⌧) and font flicker.
Future<void> _preloadCairo() async {
  try {
    final fontLoader = FontLoader('Cairo');
    fontLoader.addFont(rootBundle.load('assets/fonts/Cairo-Regular.ttf'));
    fontLoader.addFont(rootBundle.load('assets/fonts/Cairo-Bold.ttf'));
    fontLoader.addFont(rootBundle.load('assets/fonts/Cairo-ExtraBold.ttf'));
    await fontLoader.load();
  } catch (e) {
    debugPrint('Cairo font preloading failed gracefully: $e');
  }
}
