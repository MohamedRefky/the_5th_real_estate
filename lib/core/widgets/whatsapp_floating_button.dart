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
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    switch (variant) {
      case WhatsAppFloatingButtonVariant.fabExtended:
        return Container(
          margin: EdgeInsets.only(
            bottom: isMobile ? 6 : 12,
            left: isMobile ? 6 : 12,
            right: isMobile ? 6 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF25D366).withValues(alpha: 0.45),
                blurRadius: isMobile ? 12 : 20,
                offset: Offset(0, isMobile ? 3 : 6),
              ),
            ],
          ),
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
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 20,
                  vertical: isMobile ? 9 : 13,
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
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: isMobile ? 18 : 22,
                    ),
                    SizedBox(width: isMobile ? 7 : 10),
                    Text(
                      fabLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: isMobile ? 13 : 15,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case WhatsAppFloatingButtonVariant.gradientPill:
        return Container(
          margin: EdgeInsets.only(
            bottom: isMobile ? 6 : 12,
            left: isMobile ? 6 : 12,
            right: isMobile ? 6 : 12,
          ),
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
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 20,
                  vertical: isMobile ? 9 : 13,
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
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.45),
                      blurRadius: isMobile ? 12 : 20,
                      offset: Offset(0, isMobile ? 3 : 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: isMobile ? 18 : 22,
                    ),
                    SizedBox(width: isMobile ? 7 : 10),
                    Text(
                      'تواصل معنا',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: isMobile ? 13 : 15,
                        letterSpacing: 0.2,
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
