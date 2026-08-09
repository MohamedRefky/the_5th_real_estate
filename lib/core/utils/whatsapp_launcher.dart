import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';

/// Unified WhatsApp launcher.
///
/// Reproduces the behavior previously duplicated across screens:
/// - digits are stripped from [phoneNumber] before building the `wa.me` link,
/// - the OS app is preferred via `LaunchMode.externalApplication`,
/// - when [failureMessage] and [context] are given and the launch fails, a
///   SnackBar is shown instead of a fallback launch,
/// - otherwise it falls back to a default-mode launch.
///
/// Returns `true` when the launcher was opened.
Future<bool> launchWhatsApp({
  required String phoneNumber,
  String message = '',
  BuildContext? context,
  String? failureMessage,
}) async {
  final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
  final encoded = Uri.encodeComponent(message);
  final uri = Uri.parse('https://wa.me/$cleanPhone?text=$encoded');

  var launched = false;
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      launched = true;
    }
  } catch (_) {
    launched = false;
  }

  if (!launched) {
    if (failureMessage != null && context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }
    try {
      await launchUrl(uri);
      launched = true;
    } catch (_) {
      launched = false;
    }
  }

  return launched;
}
