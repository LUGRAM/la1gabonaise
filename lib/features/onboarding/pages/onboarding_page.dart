import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';
import '../widget/progress_dots.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  static const _bgColors = [
    [Color(0xFF0A1220), Color(0xFF050810)],
    [Color(0xFF0D1A2E), Color(0xFF091220)],
    [Color(0xFF1A0D00), Color(0xFF0D0800)],
    [Color(0xFF001A0D), Color(0xFF00100A)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Un seul PageView ──────────────────────────
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.total,
                itemBuilder: (_, i) {
                  final slide = controller.slides[i];
                  final colors = _bgColors[i % _bgColors.length];
                  return Column(
                    children: [
                      // Visual
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: colors,
                            ),
                          ),
                          child: Center(
                            child: Text(slide.emoji, style: const TextStyle(fontSize: 90)),
                          ),
                        ),
                      ),
                      // Texte
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: AppColors.bg,
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(slide.eyebrow.toUpperCase(), style: AppTextStyles.labelRed),
                              const SizedBox(height: 10),
                              Text(slide.title, style: AppTextStyles.display2),
                              const SizedBox(height: 12),
                              Text(slide.description, style: AppTextStyles.body2),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8, runSpacing: 8,
                                children: slide.chips.map((c) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGlow,
                                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(c, style: const TextStyle(fontSize: 11, color: Colors.white)),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ── Footer fixe (progress + boutons) ─────────
            Container(
              color: AppColors.bg,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  Obx(() => Row(children: [
                    Expanded(child: OnboardingProgressDots(
                      total: controller.total,
                      current: controller.currentPage.value,
                    )),
                    const SizedBox(width: 16),
                    if (!controller.isLast)
                      GestureDetector(
                        onTap: controller.skip,
                        child: const Text('Passer →',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ),
                  ])),
                  const SizedBox(height: 16),
                  Obx(() {
                    final isLast = controller.isLast;
                    return Column(children: [
                      AppButton(
                        label: isLast ? 'Créer un compte' : 'Suivant →',
                        onTap: controller.nextPage,
                      ),
                      if (isLast) ...[
                        const SizedBox(height: 10),
                        AppButton(
                          label: 'Se connecter',
                          variant: AppButtonVariant.outline,
                          onTap: controller.goToLogin,
                        ),
                      ],
                    ]);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}