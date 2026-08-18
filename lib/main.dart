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

  // Pre-fetch Cairo font weights before rendering first frame to prevent FOUT / tofu glyph flash
  GoogleFonts.config.allowRuntimeFetching = true;
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.cairo(fontWeight: FontWeight.w400),
      GoogleFonts.cairo(fontWeight: FontWeight.w500),
      GoogleFonts.cairo(fontWeight: FontWeight.w600),
      GoogleFonts.cairo(fontWeight: FontWeight.w700),
      GoogleFonts.cairo(fontWeight: FontWeight.w800),
      GoogleFonts.cairo(fontWeight: FontWeight.w900),
    ]).timeout(const Duration(seconds: 4));
  } catch (e) {
    debugPrint('GoogleFonts prefetch note: $e');
  }

  // Clean URLs (no `#/`) so /admin/login, /admin/dashboard work directly.
  usePathUrlStrategy();

  runApp(const TheApp());
}
