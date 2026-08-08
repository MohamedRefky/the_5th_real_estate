import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import 'section_bar.dart';

/// Contact Us section — WhatsApp & Facebook UI Cards.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      'مرحبًا، أريد الاستفسار عن العقارات المتاحة في التجمع الخامس وتحديد موعد معاينة',
    );
    final url = Uri.parse('https://wa.me/+201000000001?text=$message');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(url);
    }
  }

  Future<void> _openFacebook() async {
    final url = Uri.parse('https://facebook.com');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const SectionBar(
                icon: Icons.headset_mic_rounded,
                title: 'تواصل معنا',
                subtitle:
                    'يسعدنا تواصلك المباشر لمساعدتك في اختيار وتحديد معاينة وحدتك العقارية المثالية',
              ),

              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 700;

                  if (isDesktop) {
                    return Row(
                      children: [
                        Expanded(
                          child: RevealOnScroll(
                            direction: RevealDirection.fromRight,
                            delayMilliseconds: 0,
                            child: _ContactCard(
                              title: 'تواصل عبر واتساب',
                              subtitle:
                                  'استجابة فورية واستشارات عقارية مباشرة 24/7',
                              iconWidget: const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                size: 32,
                                color: Color(0xFF25D366),
                              ),
                              badgeText: 'واتساب',
                              accentColor: const Color(0xFF25D366),
                              onTap: _openWhatsApp,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: RevealOnScroll(
                            direction: RevealDirection.fromRight,
                            delayMilliseconds: 160,
                            child: _ContactCard(
                              title: 'تابعنا على فيسبوك',
                              subtitle:
                                  'اكتشف أحدث العروض والمشاريع الحصرية فور طرحها',
                              iconWidget: const FaIcon(
                                FontAwesomeIcons.facebookF,
                                size: 28,
                                color: Color(0xFF1877F2),
                              ),
                              badgeText: 'فيسبوك',
                              accentColor: const Color(0xFF1877F2),
                              onTap: _openFacebook,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      RevealOnScroll(
                        direction: RevealDirection.fromRight,
                        delayMilliseconds: 0,
                        child: _ContactCard(
                          title: 'تواصل عبر واتساب',
                          subtitle:
                              'استجابة فورية واستشارات عقارية مباشرة 24/7',
                          iconWidget: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 32,
                            color: Color(0xFF25D366),
                          ),
                          badgeText: 'واتساب',
                          accentColor: const Color(0xFF25D366),
                          onTap: _openWhatsApp,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RevealOnScroll(
                        direction: RevealDirection.fromRight,
                        delayMilliseconds: 160,
                        child: _ContactCard(
                          title: 'تابعنا على فيسبوك',
                          subtitle:
                              'اكتشف أحدث العروض والمشاريع الحصرية فور طرحها',
                          iconWidget: const FaIcon(
                            FontAwesomeIcons.facebookF,
                            size: 28,
                            color: Color(0xFF1877F2),
                          ),
                          badgeText: 'فيسبوك',
                          accentColor: const Color(0xFF1877F2),
                          onTap: _openFacebook,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget iconWidget;
  final String badgeText;
  final Color accentColor;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.badgeText,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Glowing Platform Icon Badge
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(child: iconWidget),
                ),

                const SizedBox(width: 18),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Arrow indicator icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
