import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/routes/app_routes.dart';

class PaymentSuccessPage extends GetView<SubscriptionController> {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Halo vert
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 3),
                  boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.3), blurRadius: 40, spreadRadius: 10)],
                ),
                child: const Center(child: Icon(Icons.check_rounded, color: AppColors.success, size: 60)),
              ),
              const SizedBox(height: 32),
              Text('Bienvenue sur\nLA1GABONAISE !', style: AppTextStyles.display2, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text('Votre abonnement est actif.\nAccès immédiat au catalogue gabonais.',
                  style: AppTextStyles.body2, textAlign: TextAlign.center),
              const SizedBox(height: 32),

              // Plan chip
              Obx(() => Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(children: [
                  Text('PLAN ACTIVÉ', style: AppTextStyles.label.copyWith(color: AppColors.success)),
                  const SizedBox(height: 6),
                  Text(controller.selectedPlan.value?.name ?? '', style: const TextStyle(fontFamily: 'Playfair', fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(controller.priceLabel, style: AppTextStyles.body2),
                ]),
              )),
              const SizedBox(height: 32),

              AppButton(label: 'Commencer à regarder 🎬', onTap: () => Get.offAllNamed(AppRoutes.home)),
              const SizedBox(height: 12),
              AppButton(label: 'Choisir mon profil', variant: AppButtonVariant.outline, onTap: () => Get.offAllNamed(AppRoutes.pickProfile)),
            ],
          ),
        ),
      ),
    );
  }
}
