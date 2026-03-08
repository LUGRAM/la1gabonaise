import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controller/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';

class OtpPage extends GetView<AuthController> {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
                ),
              ),
              const SizedBox(height: 24),

              Container(width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Center(child: Text('💬', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 24),

              Text('Vérifier votre numéro', style: AppTextStyles.display3, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Code à 6 chiffres envoyé par SMS au\n',
                  style: AppTextStyles.body2,
                  children: [
                    TextSpan(text: controller.pendingEmail,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Pin fields
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (v) => controller.otpCode.value = v,
                onCompleted: (_) => controller.verifyOtp(),
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 46,
                  activeFillColor: AppColors.primaryGlow,
                  activeColor: AppColors.primary,
                  selectedFillColor: AppColors.surfaceHigh,
                  selectedColor: AppColors.primary,
                  inactiveFillColor: AppColors.surfaceVar,
                  inactiveColor: AppColors.border,
                ),
                enableActiveFill: true,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Timer
              Obx(() {
                final s = controller.otpTimer.value;
                final mm = (s ~/ 60).toString().padLeft(2, '0');
                final ss = (s % 60).toString().padLeft(2, '0');
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVar,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    const Text('Expire dans ', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text('$mm:$ss',
                        style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                  ]),
                );
              }),
              const SizedBox(height: 16),

              Obx(() => controller.otpTimer.value == 0
                  ? GestureDetector(
                      onTap: controller.resendOtp,
                      child: const Text('Renvoyer le code',
                          style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    )
                  : const Text('Pas reçu ? Patienter...', style: TextStyle(fontSize: 12, color: AppColors.textMuted))),

              const Spacer(),
              Obx(() => AppButton(
                label: 'Vérifier →',
                loading: controller.isLoading.value,
                onTap: controller.verifyOtp,
              )),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
