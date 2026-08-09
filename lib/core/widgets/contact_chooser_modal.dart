import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../utils/whatsapp_launcher.dart';

/// Communication platforms supported for contacting team members.
enum ContactPlatform {
  whatsapp,
  facebook,
  all,
}

/// Shows an ultra-premium glassmorphic modal sheet with semi-transparent backdrop
/// allowing the user to select which team member to contact.
///
/// When [platform] is [ContactPlatform.whatsapp], ONLY WhatsApp contact options
/// are shown. When [platform] is [ContactPlatform.facebook], ONLY Facebook options
/// are shown.
Future<void> showContactChooserModal(
  BuildContext context, {
  String message = '',
  ContactPlatform platform = ContactPlatform.all,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => ContactChooserModal(
      message: message,
      platform: platform,
    ),
  );
}

class ContactChooserModal extends StatelessWidget {
  final String message;
  final ContactPlatform platform;

  const ContactChooserModal({
    super.key,
    this.message = '',
    this.platform = ContactPlatform.all,
  });

  Future<void> _launchFacebook(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر فتح صفحة الفيسبوك'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contacts = AppConstants.teamContacts;

    // Platform-specific styling & strings
    final isWhatsAppOnly = platform == ContactPlatform.whatsapp;
    final isFacebookOnly = platform == ContactPlatform.facebook;

    final String titleText = isWhatsAppOnly
        ? 'تواصل عبر واتساب'
        : (isFacebookOnly ? 'تواصل عبر فيسبوك' : 'اختر مسؤول التواصل');

    final String subtitleText = isWhatsAppOnly
        ? 'اختر مسؤول المبيعات المراد مراسلته عبر واتساب للاستفسار والمعاينة'
        : (isFacebookOnly
            ? 'اختر مسؤول المبيعات المراد التواصل معه عبر فيسبوك للمتابعة'
            : 'يسعدنا تواصلك المباشر مع أحد مسؤولي المبيعات والمعاينات');

    final Color primaryPlatformColor = isWhatsAppOnly
        ? const Color(0xFF25D366)
        : (isFacebookOnly ? const Color(0xFF1877F2) : AppColors.accent);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              decoration: BoxDecoration(
                // Semi-transparent frosted glass background
                color: AppColors.surface.withValues(alpha: 0.65),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: primaryPlatformColor.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryPlatformColor.withValues(alpha: 0.20),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Drag Indicator Bar
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Glowing Platform Icon Header Badge
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      gradient: isWhatsAppOnly
                          ? const LinearGradient(
                              colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                            )
                          : (isFacebookOnly
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF1877F2),
                                    Color(0xFF0F52AC)
                                  ],
                                )
                              : AppColors.accentGradient),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryPlatformColor.withValues(alpha: 0.45),
                          blurRadius: 22,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isWhatsAppOnly
                          ? const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                              size: 34,
                            )
                          : (isFacebookOnly
                              ? const FaIcon(
                                  FontAwesomeIcons.facebookF,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.support_agent_rounded,
                                  color: AppColors.textOnPrimary,
                                  size: 36,
                                )),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Header Title
                  Text(
                    titleText,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  // Header Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      subtitleText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Team Representatives List
                  Column(
                    children: contacts.map((contact) {
                      return _RepresentativeCard(
                        contact: contact,
                        message: message,
                        platform: platform,
                        onFacebookTap: () =>
                            _launchFacebook(context, contact.facebookUrl),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 8),

                  // Close / Cancel Text Button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RepresentativeCard extends StatelessWidget {
  final TeamContact contact;
  final String message;
  final ContactPlatform platform;
  final VoidCallback onFacebookTap;

  const _RepresentativeCard({
    required this.contact,
    required this.message,
    required this.platform,
    required this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWhatsAppOnly = platform == ContactPlatform.whatsapp;
    final isFacebookOnly = platform == ContactPlatform.facebook;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // Translucent frosted card surface
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isWhatsAppOnly
              ? const Color(0xFF25D366).withValues(alpha: 0.4)
              : (isFacebookOnly
                  ? const Color(0xFF1877F2).withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.15)),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Representative Info (Avatar + Name + BLUE VERIFIED BADGE + Role)
          Row(
            children: [
              // Avatar Circle with Initials & Metallic Gradient Ring
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isWhatsAppOnly
                        ? [
                            const Color(0xFF25D366),
                            const Color(0xFF075E54),
                          ]
                        : (isFacebookOnly
                            ? [
                                const Color(0xFF1877F2),
                                const Color(0xFF0F52AC),
                              ]
                            : [
                                AppColors.accent,
                                AppColors.primaryDark,
                              ]),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isWhatsAppOnly
                              ? const Color(0xFF25D366)
                              : (isFacebookOnly
                                  ? const Color(0xFF1877F2)
                                  : AppColors.accent))
                          .withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    contact.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          contact.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 6),

                        // OFFICIAL BLUE VERIFIED BADGE
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1877F2), // Official Verified Blue
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x661877F2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentLight2,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── ACTION BUTTONS ───────────────────────────────────────
          // Mode 1: WhatsApp ONLY
          if (isWhatsAppOnly) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  launchWhatsApp(
                    phoneNumber: contact.whatsappNumber,
                    message: message.isNotEmpty
                        ? message
                        : 'مرحباً ${contact.name}، أود الاستفسار عن العقارات المتاحة وتحديد موعد معاينة',
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF25D366),
                        Color(0xFF128C7E),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF25D366).withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'مراسلة ${contact.name} عبر واتساب',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
          // Mode 2: Facebook ONLY
          else if (isFacebookOnly) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onFacebookTap();
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1877F2),
                        Color(0xFF0F52AC),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1877F2).withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'زيارة بروفايل ${contact.name} على فيسبوك',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
          // Mode 3: ALL Platforms (Both WhatsApp & Facebook buttons)
          else ...[
            Row(
              children: [
                // WhatsApp Button
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        launchWhatsApp(
                          phoneNumber: contact.whatsappNumber,
                          message: message.isNotEmpty
                              ? message
                              : 'مرحباً ${contact.name}، أود الاستفسار عن العقارات المتاحة',
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF25D366),
                              Color(0xFF128C7E),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF25D366)
                                  .withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                              size: 17,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'واتساب',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Facebook Button
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onFacebookTap();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1877F2),
                              Color(0xFF0F52AC),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1877F2)
                                  .withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'فيسبوك',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
