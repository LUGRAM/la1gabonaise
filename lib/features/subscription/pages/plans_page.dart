import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/routes/app_routes.dart';

class PlansPage extends GetView<SubscriptionController> {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ABONNEMENT', style: AppTextStyles.labelRed),
                const SizedBox(height: 8),
                Text('Choisissez votre\nabonnement', style: AppTextStyles.display2),
                const Text('Paiement mobile money · Sans engagement', style: AppTextStyles.body2),
                const SizedBox(height: 16),
                // Toggle Mensuel / Hebdomadaire
                Obx(() => Container(
                  decoration: BoxDecoration(color: AppColors.surfaceVar, borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(3),
                  child: Row(children: [
                    _togBtn('Mensuel', controller.isMonthly.value, () => controller.isMonthly.value = true),
                    _togBtn('Hebdomadaire', !controller.isMonthly.value, () => controller.isMonthly.value = false),
                  ]),
                )),
              ]),
            ),
            const SizedBox(height: 16),
            // Plans
            Expanded(
              child: Obx(() => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: controller.plans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) {
                  final plan = controller.plans[i];
                  final isSelected = controller.selectedPlan.value?.id == plan.id;
                  return GestureDetector(
                    onTap: () => controller.selectPlan(plan),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                        gradient: plan.isPopular
                            ? const LinearGradient(
                                begin: Alignment.topLeft, end: Alignment.bottomRight,
                                colors: [Color(0xFF1A0003), Color(0xFF2E0005)])
                            : null,
                        color: plan.isPopular ? null : AppColors.surfaceVar,
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(plan.name,
                            style: TextStyle(fontFamily: 'Playfair', fontSize: 24, fontWeight: FontWeight.w700,
                              color: plan.isPopular ? AppColors.primary : AppColors.textMuted))),
                          if (plan.isPopular)
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(3)),
                              child: const Text('POPULAIRE', style: TextStyle(fontSize: 9, color: Colors.black, fontFamily: 'monospace', letterSpacing: 1))),
                        ]),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          '${controller.isMonthly.value ? plan.priceMonthly : plan.priceWeekly} FCFA / ${controller.isMonthly.value ? "mois" : "semaine"}',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                        )),
                        const SizedBox(height: 12),
                        ...plan.features.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(children: [
                            const Icon(Icons.check_circle_outline, color: AppColors.success, size: 16),
                            const SizedBox(width: 8),
                            Text(f, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                          ]),
                        )),
                        const SizedBox(height: 14),
                        AppButton(
                          label: 'COMMENCER ${plan.name}',
                          onTap: () {
                            controller.selectPlan(plan);
                            Get.toNamed(AppRoutes.payment);
                          },
                          variant: plan.isPopular ? AppButtonVariant.filled : AppButtonVariant.outline,
                        ),
                      ]),
                    ),
                  );
                },
              )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _togBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textMuted)),
        ),
      ),
    );
  }
}
