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

    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 16 : 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: ClipRRect(
            // Fully rounded corners for floating modal sheet look
            borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
            child: BackdropFilter(
              // Smooth balanced blur effect
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 14 : 20,
                  14,
                  isMobile ? 14 : 20,
                  16,
                ),
                decoration: BoxDecoration(
                  // Rich dark translucent steel glass container
                  color: AppColors.surface.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
                  border: Border.all(
                    color: primaryPlatformColor.withValues(alpha: 0.30),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPlatformColor.withValues(alpha: 0.20),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.40),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Drag Indicator
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      SizedBox(height: isMobile ? 14 : 18),

                      // Glowing Platform Header Icon
                      Container(
                        width: isMobile ? 54 : 64,
                        height: isMobile ? 54 : 64,
                        decoration: BoxDecoration(
                          color: primaryPlatformColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                          border: Border.all(
                            color: primaryPlatformColor.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryPlatformColor.withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isWhatsAppOnly
                              ? FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: const Color(0xFF25D366),
                                  size: isMobile ? 28 : 34,
                                )
                              : (isFacebookOnly
                                  ? FaIcon(
                                      FontAwesomeIcons.facebookF,
                                      color: const Color(0xFF1877F2),
                                      size: isMobile ? 24 : 30,
                                    )
                                  : Icon(
                                      Icons.support_agent_rounded,
                                      color: AppColors.accent,
                                      size: isMobile ? 28 : 34,
                                    )),
                        ),
                      ),

                      SizedBox(height: isMobile ? 12 : 16),

                      // Title
                      Text(
                        titleText,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          fontSize: isMobile ? 18.5 : 22,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 5),

                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          subtitleText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isMobile ? 12 : 13.5,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: isMobile ? 16 : 20),

                      // Team Representative Cards
                      Column(
                        children: contacts.map((contact) {
                          return _GlassRepresentativeCard(
                            contact: contact,
                            message: message,
                            platform: platform,
                            onFacebookTap: () =>
                                _launchFacebook(context, contact.facebookUrl),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 2),

                      // Cancel Button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ── GLASS REPRESENTATIVE CARD ────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class _GlassRepresentativeCard extends StatelessWidget {
  final TeamContact contact;
  final String message;
  final ContactPlatform platform;
  final VoidCallback onFacebookTap;

  const _GlassRepresentativeCard({
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

    final Color accentColor = isWhatsAppOnly
        ? const Color(0xFF25D366)
        : (isFacebookOnly ? const Color(0xFF1877F2) : AppColors.accent);

    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 10 : 14),
      decoration: BoxDecoration(
        // Translucent rich slate card background
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.30),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Representative Header
                Row(
                  children: [
                    // Sleek Agent Profile Icon Badge
                    Container(
                      width: isMobile ? 44 : 50,
                      height: isMobile ? 44 : 50,
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
                        borderRadius: BorderRadius.circular(isMobile ? 13 : 16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.45),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.40),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.userTie,
                          color: Colors.white,
                          size: isMobile ? 18 : 22,
                        ),
                      ),
                    ),

                    SizedBox(width: isMobile ? 10 : 14),

                    // Name + Verified Badge + Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  contact.nameEn,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    fontSize: isMobile ? 15 : 17,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Official Facebook Blue Verified Badge Icon
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF1877F2),
                                size: 17,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            contact.title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: isMobile ? 11 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 12 : 16),

                // Action Buttons
                if (isWhatsAppOnly) ...[
                  _ActionButton(
                    label: 'مراسلة عبر واتساب',
                    icon: FontAwesomeIcons.whatsapp,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      launchWhatsApp(
                        phoneNumber: contact.whatsappNumber,
                        message: message.isNotEmpty
                            ? message
                            : 'مرحباً ${contact.nameEn}، أود الاستفسار عن العقارات المتاحة وتحديد موعد معاينة',
                      );
                    },
                  ),
                ] else if (isFacebookOnly) ...[
                  _ActionButton(
                    label: 'زيارة صفحة فيسبوك',
                    icon: FontAwesomeIcons.facebookF,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1877F2), Color(0xFF0F52AC)],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onFacebookTap();
                    },
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'واتساب',
                          icon: FontAwesomeIcons.whatsapp,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            launchWhatsApp(
                              phoneNumber: contact.whatsappNumber,
                              message: message.isNotEmpty
                                  ? message
                                  : 'مرحباً ${contact.nameEn}، أود الاستفسار عن العقارات المتاحة',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          label: 'فيسبوك',
                          icon: FontAwesomeIcons.facebookF,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1877F2), Color(0xFF0F52AC)],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            onFacebookTap();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ── ACTION BUTTON WIDGET ─────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class _ActionButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
