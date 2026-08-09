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

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ClipRRect(
            // Fully rounded corners for floating modal sheet look
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              // Smooth balanced blur effect
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  // Rich dark translucent steel glass container (high contrast, non-washed out)
                  color: AppColors.surface.withValues(alpha: 0.70),
                  borderRadius: BorderRadius.circular(32),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Drag Indicator
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Glowing Platform Header Icon
                    Container(
                      width: 68,
                      height: 68,
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryPlatformColor.withValues(alpha: 0.50),
                            blurRadius: 28,
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

                    // Title
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

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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

                    const SizedBox(height: 22),

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

                    const SizedBox(height: 4),

                    // Cancel Button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
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

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        // Translucent rich slate card background
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(22),
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
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Representative Header
                Row(
                  children: [
                    // Sleek Agent Profile Icon Badge
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
                        borderRadius: BorderRadius.circular(16),
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
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.userTie,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Name + Verified Badge + Title
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
                              // Official Facebook Blue Verified Badge Icon
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF1877F2),
                                size: 19,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact.title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Action Buttons
                if (isWhatsAppOnly) ...[
                  _ActionButton(
                    label: 'مراسلة ${contact.name} عبر واتساب',
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
                            : 'مرحباً ${contact.name}، أود الاستفسار عن العقارات المتاحة وتحديد موعد معاينة',
                      );
                    },
                  ),
                ] else if (isFacebookOnly) ...[
                  _ActionButton(
                    label: 'زيارة بروفايل ${contact.name} على فيسبوك',
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
                                  : 'مرحباً ${contact.name}، أود الاستفسار عن العقارات المتاحة',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: Colors.white,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                label,
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
    );
  }
}
