import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared loading scaffold used by the detail screens.
class ScaffoldLoadingView extends StatelessWidget {
  const ScaffoldLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('...')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Shared "not found" scaffold used by the detail screens.
///
/// When [styled] is `false` (default) the message uses the default text
/// style; when `true` it uses the 18px secondary style.
class ScaffoldNotFoundView extends StatelessWidget {
  final String message;
  final bool styled;

  const ScaffoldNotFoundView({
    super.key,
    required this.message,
    this.styled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خطأ')),
      body: Center(
        child: styled
            ? Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              )
            : Text(message),
      ),
    );
  }
}
