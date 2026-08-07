import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'section_bar.dart';

/// Contact Us section — WhatsApp & Facebook UI Cards.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
                subtitle: 'يسعدنا تواصلك المباشر لمساعدتك في اختيار وتحديد معاينة وحدتك العقارية المثالية',
              ),

              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 700;

                  if (isDesktop) {
                    return Row(
                      children: [
                        Expanded(
                          child: _ContactCard(
                            title: 'تواصل عبر واتساب',
                            subtitle: 'استجابة فورية واستشارات عقارية مباشرة 24/7',
                            icon: Icons.chat_rounded,
                            badgeText: 'واتساب',
                            accentColor: const Color(0xFF25D366),
                            onTap: () {
                              // TODO: Add WhatsApp link here
                            },
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _ContactCard(
                            title: 'تابعنا على فيسبوك',
                            subtitle: 'اكتشف أحدث العروض والمشاريع الحصرية فور طرحها',
                            icon: Icons.facebook_rounded,
                            badgeText: 'فيسبوك',
                            accentColor: const Color(0xFF1877F2),
                            onTap: () {
                              // TODO: Add Facebook link here
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _ContactCard(
                        title: 'تواصل عبر واتساب',
                        subtitle: 'استجابة فورية واستشارات عقارية مباشرة 24/7',
                        icon: Icons.chat_rounded,
                        badgeText: 'واتساب',
                        accentColor: const Color(0xFF25D366),
                        onTap: () {
                          // TODO: Add WhatsApp link here
                        },
                      ),
                      const SizedBox(height: 20),
                      _ContactCard(
                        title: 'تابعنا على فيسبوك',
                        subtitle: 'اكتشف أحدث العروض والمشاريع الحصرية فور طرحها',
                        icon: Icons.facebook_rounded,
                        badgeText: 'فيسبوك',
                        accentColor: const Color(0xFF1877F2),
                        onTap: () {
                          // TODO: Add Facebook link here
                        },
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
  final IconData icon;
  final String badgeText;
  final Color accentColor;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.icon,
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
                  padding: const EdgeInsets.all(16),
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
                  child: Icon(
                    icon,
                    size: 32,
                    color: accentColor,
                  ),
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
