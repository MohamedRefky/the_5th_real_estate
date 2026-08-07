import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_background.dart';

/// How It Works section — premium design with animated background.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    return AnimatedBackground(
      shapeColor: AppColors.accent,
      shapeCount: 12,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // Section icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    color: AppColors.accent,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.goldGradient.createShader(bounds),
                  child: Text(
                    'خطوات الشراء',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'امتلك وحدتك العقارية في 3 خطوات بسيطة ومباشرة',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
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
                                padding: const EdgeInsets.only(top: 60),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: AppColors.accent.withValues(alpha: 0.4),
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
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    ({String stepNumber, IconData icon, String title, String emoji, String desc}) step,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Step number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  step.stepNumber,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(18),
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
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              step.desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.6),
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
