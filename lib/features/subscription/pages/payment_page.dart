import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_input.dart';

class PaymentPage extends GetView<SubscriptionController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneCtrl = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(children: [
                IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20)),
                Text('Ajouter vos infos de paiement', style: AppTextStyles.h1),
              ]),
              const SizedBox(height: 20),

              // Plan sélectionné
              Obx(() => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(controller.selectedPlan.value?.name ?? '', style: const TextStyle(fontFamily: 'Playfair', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
                    const Text('Sans engagement', style: AppTextStyles.body2),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(controller.priceLabel.split('/').first, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    Text('/ ${controller.priceLabel.split('/').last}', style: AppTextStyles.body2),
                  ]),
                ]),
              )),
              const SizedBox(height: 24),

              Text('MODE DE PAIEMENT', style: AppTextStyles.label),
              const SizedBox(height: 12),

              // Méthodes paiement
              Obx(() => Column(children: [
                _PayMethodTile(
                  label: 'Airtel Money',
                  sub: 'Paiement instantané',
                  color: AppColors.primary,
                  shortName: 'airtel\nmoney',
                  isSelected: controller.selectedPayment.value == PaymentMethod.airtelMoney,
                  onTap: () => controller.selectPaymentMethod(PaymentMethod.airtelMoney),
                ),
                const SizedBox(height: 10),
                _PayMethodTile(
                  label: 'Moov Money',
                  sub: 'Paiement instantané',
                  color: AppColors.gold,
                  shortName: 'MOOV',
                  isSelected: controller.selectedPayment.value == PaymentMethod.moovMoney,
                  onTap: () => controller.selectPaymentMethod(PaymentMethod.moovMoney),
                ),
                const SizedBox(height: 10),
                _PayMethodTile(
                  label: 'Carte bancaire',
                  sub: 'Visa · Mastercard',
                  color: const Color(0xFF1A1F71),
                  shortName: 'VISA',
                  isSelected: controller.selectedPayment.value == PaymentMethod.visa,
                  onTap: () => controller.selectPaymentMethod(PaymentMethod.visa),
                ),
              ])),
              const SizedBox(height: 20),

              AppInput(
                label: 'Numéro de paiement',
                hint: '07 XX XX XX',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: const Text('+241', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                onChanged: (v) => controller.phoneNumber.value = v,
              ),
              const SizedBox(height: 8),
              const Text('Un SMS de confirmation vous sera envoyé.', style: AppTextStyles.body2),
              const SizedBox(height: 16),

              // Sécurité
              Row(children: [
                const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 14),
                const SizedBox(width: 6),
                Text('Paiement sécurisé · CinetPay · SSL', style: AppTextStyles.bodySmall),
              ]),
              const SizedBox(height: 24),

              Obx(() => AppButton(
                label: 'Valider le paiement',
                loading: controller.isLoading.value,
                onTap: controller.processPayment,
              )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PayMethodTile extends StatelessWidget {
  final String label;
  final String sub;
  final Color color;
  final String shortName;
  final bool isSelected;
  final VoidCallback onTap;
  const _PayMethodTile({required this.label, required this.sub, required this.color, required this.shortName, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGlow : AppColors.surfaceVar,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Container(width: 56, height: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            child: Center(child: Text(shortName, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, fontFamily: 'monospace')))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            Text(sub, style: AppTextStyles.bodySmall),
          ])),
          Container(width: 20, height: 20, decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null),
        ]),
      ),
    );
  }
}
