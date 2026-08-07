import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'section_bar.dart';

/// How It Works section — Dark Mode.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        stepNumber: '1',
        icon: Icons.search_rounded,
        title: 'تصفح العقارات',
        emoji: '🔍',
        desc: 'استكشف الوحدات المتاحة بالفلاتر والأدوار والمساحات المناسبة لك'
      ),
      (
        stepNumber: '2',
        icon: Icons.mark_chat_read_rounded,
        title: 'تواصل معى لتحديد معاينه',
        emoji: '💬',
        desc: 'تواصل مباشرة عبر واتساب لتحديد موعد المعاينة والإجابة على كل استفساراتك'
      ),
      (
        stepNumber: '3',
        icon: Icons.vpn_key_rounded,
        title: 'استلم مفتاحك',
        emoji: '🔑',
        desc: 'أكمل إجراءات التعاقد بسهولة واستلم وحدتك السكنية الجديدة'
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.cream,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionBar(
                index: 5,
                icon: Icons.rocket_launch_rounded,
                title: 'خطوات الشراء',
                subtitle: 'امتلك وحدتك العقارية في 3 خطوات بسيطة ومباشرة',
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 800;

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          Expanded(child: _buildStepCard(context, steps[i])),
                          if (i < steps.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 70),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.accent,
                                size: 28,
                              ),
                            ),
                        ],
                      ],
                    );
                  }

                  return Column(
                    children: steps
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildStepCard(context, s),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    ({String stepNumber, IconData icon, String title, String emoji, String desc}) step,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Step number badge with gold gradient
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  step.stepNumber,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                step.icon,
                size: 30,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 20),

            // Title with emoji
            Text(
              '${step.title} ${step.emoji}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              step.desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.7,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
