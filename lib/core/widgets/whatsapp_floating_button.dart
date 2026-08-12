import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'contact_chooser_modal.dart';

/// Visual variants of the floating WhatsApp call-to-action.
enum WhatsAppFloatingButtonVariant {
  /// Gradient pill with the WhatsApp brand icon (apartment details).
  gradientPill,

  /// `FloatingActionButton.extended` style (building details).
  fabExtended,
}

/// Floating WhatsApp CTA shared by the detail screens.
class WhatsAppFloatingButton extends StatelessWidget {
  final String phoneNumber;
  final String message;
  final String? failureMessage;
  final WhatsAppFloatingButtonVariant variant;

  /// Label shown by [WhatsAppFloatingButtonVariant.fabExtended].
  final String fabLabel;

  const WhatsAppFloatingButton({
    super.key,
    this.phoneNumber = '',
    required this.message,
    this.failureMessage,
    this.variant = WhatsAppFloatingButtonVariant.gradientPill,
    this.fabLabel = 'تواصل عبر واتساب',
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case WhatsAppFloatingButtonVariant.fabExtended:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF25D366).withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => showContactChooserModal(
              context,
              message: message,
              platform: ContactPlatform.whatsapp,
            ),
            backgroundColor: const Color(0xFF25D366),
            foregroundColor: Colors.white,
            elevation: 0,
            highlightElevation: 0,
            icon: const Icon(Icons.chat_rounded, size: 24),
            label: Text(
              fabLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        );

      case WhatsAppFloatingButtonVariant.gradientPill:
        return Container(
          margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => showContactChooserModal(
                context,
                message: message,
                platform: ContactPlatform.whatsapp,
              ),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'تواصل معنا',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
