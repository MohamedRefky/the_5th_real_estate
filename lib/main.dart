import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GoogleFonts.config.allowRuntimeFetching = true;

  // Clean URLs (no `#/`) so /admin/login, /admin/dashboard work directly.
  usePathUrlStrategy();

  runApp(const TheApp());
}
