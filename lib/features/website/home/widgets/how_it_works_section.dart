import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_5th_real_estate/core/widgets/reveal_on_scroll.dart';
import '../../../../core/theme/app_colors.dart';
import 'section_bar.dart';

/// How It Works section — Transparent & Glassmorphic.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const List<
      ({
        String stepNumber,
        IconData icon,
        String title,
        String desc,
      })> _steps = [
    (
      stepNumber: '1',
      icon: Icons.search_rounded,
      title: 'تصفح واختر عقارك',
      desc: 'استكشف كل وحدات التجمع الخامس المتاحة، وفلتر حسب الدور والتشطيب والمساحة للوصول لاختيارك المثالي'
    ),
    (
      stepNumber: '2',
      icon: Icons.mark_chat_read_rounded,
      title: 'احجز معاينة فورية',
      desc: 'تواصل مباشرة عبر واتساب لتحديد موعد المعاينة المناسب لك، واحصل على إجابة فورية عن كل استفساراتك'
    ),
    (
      stepNumber: '3',
      icon: Icons.vpn_key_rounded,
      title: 'استلم مفتاحك',
      desc: 'أكمل إجراءات التعاقد بسهولة وأمان، واستلم مفتاح وحدتك السكنية الجديدة'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionBar(
                icon: Icons.rocket_launch_rounded,
                title: 'خطوات الشراء',
                subtitle:
                    'امتلك وحدتك العقارية في 3 خطوات واضحة — من الاختيار حتى استلام المفتاح',
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 800;
              

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          Expanded(
                            child: RevealOnScroll(
                              direction: RevealDirection.scale,
                              delayMilliseconds: i * 90,
                              child: _buildDesktopStepCard(context, steps[i]),
                            ),
                          ),
                          if (i < steps.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(top: 70),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.accent,
                                size: 28,
                              ),
                            ),
                        ],
                      ],
                    );
                  }

                  // Mobile & Tablet: Streamlined Step Cards
                  return Column(
                    children: steps
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildMobileStepCard(context, s),
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

  Widget _buildMobileStepCard(
    BuildContext context,
    ({String stepNumber, IconData icon, String title, String desc}) step,
  ) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.25),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number badge + icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.4),
                  ),
                ),
                child: Center(
                  child: Icon(
                    step.icon,
                    size: 22,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'خطوة ${step.stepNumber}',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            step.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      step.desc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopStepCard(
    BuildContext context,
    ({String stepNumber, IconData icon, String title, String desc}) step,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                color: AppColors.accent.withValues(alpha: 0.25),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Step icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Icon(
                    step.icon,
                    size: 30,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  step.title,
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
        ),
      ),
    );
  }
}
