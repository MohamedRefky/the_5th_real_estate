import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_5th_real_estate/core/theme/app_colors.dart';
import '../../../../core/widgets/contact_chooser_modal.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import 'section_bar.dart';

/// Contact Us section — WhatsApp & Facebook UI Cards.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  /// Data descriptors for the contact options, shared by both layouts.
  List<_ContactOption> _getOptions(BuildContext context) => [
        _ContactOption(
          title: 'تواصل عبر واتساب',
          subtitle: 'استجابة فورية واستشارات عقارية مباشرة من فريق المبيعات',
          iconWidget: const FaIcon(
            FontAwesomeIcons.whatsapp,
            size: 32,
            color: Color(0xFF25D366),
          ),
          badgeText: 'واتساب',
          accentColor: const Color(0xFF25D366),
          onTap: () => showContactChooserModal(
            context,
            message: 'مرحبًا، أريد الاستفسار عن العقارات المتاحة وتحديد موعد معاينة',
            platform: ContactPlatform.whatsapp,
          ),
        ),
        _ContactOption(
          title: 'تابعنا على فيسبوك',
          subtitle: 'تصفح أحدث العروض والمشاريع وتواصل مع مسؤولي المبيعات',
          iconWidget: const FaIcon(
            FontAwesomeIcons.facebookF,
            size: 28,
            color: Color(0xFF1877F2),
          ),
          badgeText: 'فيسبوك',
          accentColor: const Color(0xFF1877F2),
          onTap: () => showContactChooserModal(
            context,
            platform: ContactPlatform.facebook,
          ),
        ),
      ];

  Widget _buildOption(
    _ContactOption option,
    RevealDirection direction,
    int delayMilliseconds,
  ) {
    return RevealOnScroll(
      direction: direction,
      delayMilliseconds: delayMilliseconds,
      child: _ContactCard(
        title: option.title,
        subtitle: option.subtitle,
        iconWidget: option.iconWidget,
        badgeText: option.badgeText,
        accentColor: option.accentColor,
        onTap: option.onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = _getOptions(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: isMobile ? 16 : 24,
      ),
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

              const SizedBox(height: 24),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 700;

                  if (isDesktop) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildOption(
                            options[0],
                            RevealDirection.fromRight,
                            0,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildOption(
                            options[1],
                            RevealDirection.fromLeft,
                            80,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _buildOption(options[0], RevealDirection.fromRight, 0),
                      const SizedBox(height: 10),
                      _buildOption(options[1], RevealDirection.fromLeft, 80),
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

/// Data holder describing a single contact option card.
class _ContactOption {
  final String title;
  final String subtitle;
  final Widget iconWidget;
  final String badgeText;
  final Color accentColor;
  final VoidCallback onTap;

  const _ContactOption({
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.badgeText,
    required this.accentColor,
    required this.onTap,
  });
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
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 14 : 28),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: isMobile ? 12 : 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Glowing Platform Icon Badge
                Container(
                  width: isMobile ? 46 : 60,
                  height: isMobile ? 46 : 60,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: isMobile ? 8 : 14,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(child: iconWidget),
                ),

                SizedBox(width: isMobile ? 12 : 18),

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
                              fontSize: isMobile ? 14.5 : 18,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 7 : 10,
                              vertical: isMobile ? 2 : 3,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: isMobile ? 10 : 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                          fontSize: isMobile ? 11.5 : 12.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Arrow indicator icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: isMobile ? 14 : 18,
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
