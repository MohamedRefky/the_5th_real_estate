import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// How It Works section (3 steps process).
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final steps = [
      (
        stepNumber: '1',
        icon: Icons.search_rounded,
        title: 'تصفح العقارات 🔍',
        desc: 'استكشف الوحدات المتاحة بالفلاتر والأدوار والمساحات المناسبة لك'
      ),
      (
        stepNumber: '2',
        icon: Icons.mark_chat_read_rounded,
        title: 'تواصل معى لتحديد معاينه 💬',
        desc: 'تواصل مباشرة عبر واتساب لتحديد موعد المعاينة والإجابة على كل استفساراتك'
      ),
      (
        stepNumber: '3',
        icon: Icons.vpn_key_rounded,
        title: 'استلم مفتاحك 🔑',
        desc: 'أكمل إجراءات التعاقد بسهولة واستلم وحدتك السكنية الجديدة'
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'خطوات الشراء',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'امتلك وحدتك العقارية في 3 خطوات بسيطة ومباشرة',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.accent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 800;

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: steps
                          .map((s) => Expanded(
                                child: _buildStepCard(context, s),
                              ))
                          .toList(),
                    );
                  }

                  return Column(
                    children: steps
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
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
    ({String stepNumber, IconData icon, String title, String desc}) step,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    step.icon,
                    size: 32,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      step.stepNumber,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              step.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              step.desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
