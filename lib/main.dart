import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_5th_real_estate/core/firebase/firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Guarantee no exception ever surfaces as a raw red error screen to the
  // user. Build/layout errors are replaced with a clean branded placeholder
  // while the rest of the app keeps working; details are still logged.
  FlutterError.onError = FlutterError.dumpErrorToConsole;
  ErrorWidget.builder = (details) => const _SafeErrorPlaceholder();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GoogleFonts.config.allowRuntimeFetching = true;

  // Clean URLs (no `#/`) so /admin/login, /admin/dashboard work directly.
  usePathUrlStrategy();

  runApp(const TheApp());
}

/// Graceful, branded replacement for Flutter's red error widget. Rendered in
/// the smallest failing box only; the rest of the page keeps functioning.
class _SafeErrorPlaceholder extends StatelessWidget {
  const _SafeErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF7F3EC),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, size: 34, color: Color(0xFF9A9A8A)),
            SizedBox(height: 8),
            Text(
              'تعذر تحميل هذا العنصر',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3B3B32),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
