import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controller/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl  = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _ctrl       = Get.find<AuthController>();

  static const _steps = ['Email', 'Code OTP', 'Nouveau MDP'];

  @override
  void initState() {
    super.initState();
    // Reset l'étape à chaque ouverture
    _ctrl.forgotStep.value = 0;
    // Écouter les changements pour rebuild
    _ctrl.forgotStep.listen((_) { if (mounted) setState(() {}); });
    _ctrl.isLoading.listen((_) { if (mounted) setState(() {}); });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _newPwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step    = _ctrl.forgotStep.value;
    final loading = _ctrl.isLoading.value;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: step > 0
                    ? () { setState(() => _ctrl.forgotStep.value--); }
                    : () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
              ),
            ),
            const SizedBox(height: 16),

            // Icône étape
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Center(child: Text(
                ['🔑', '💬', '🔒'][step],
                style: const TextStyle(fontSize: 32),
              )),
            ),
            const SizedBox(height: 16),

            // Progress steps
            Row(children: List.generate(3, (i) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2), height: 3,
                decoration: BoxDecoration(
                  color: i <= step ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ))),
            const SizedBox(height: 8),
            Text(
              'ÉTAPE ${step + 1} / 3 · ${_steps[step].toUpperCase()}',
              style: AppTextStyles.labelRed,
            ),
            const SizedBox(height: 20),

            // Contenu par étape
            if (step == 0) ...[
              Text('Mot de passe\noublié ?', style: AppTextStyles.display2, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              const Text('Entrez votre email pour recevoir un code',
                  style: AppTextStyles.body2, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              AppInput(
                label: 'Email', hint: 'votre@email.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textMuted, size: 18),
              ),
            ] else if (step == 1) ...[
              Text('Vérifier votre\nidentité', style: AppTextStyles.display2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Code envoyé à ${_emailCtrl.text}',
                  style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              PinCodeTextField(
                appContext: context, length: 6,
                onChanged: (v) => _ctrl.forgotOtpCode.value = v,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box, borderRadius: BorderRadius.circular(12),
                  fieldHeight: 52, fieldWidth: 42,
                  activeFillColor: AppColors.primaryGlow, activeColor: AppColors.primary,
                  selectedFillColor: AppColors.surfaceHigh, selectedColor: AppColors.primary,
                  inactiveFillColor: AppColors.surfaceVar, inactiveColor: AppColors.border,
                ),
                enableActiveFill: true,
                textStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ] else ...[
              Text('Nouveau\nmot de passe', style: AppTextStyles.display2, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              AppInput(
                label: 'Nouveau mot de passe', hint: '••••••••',
                controller: _newPwdCtrl, obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
              ),
            ],

            const Spacer(),

            AppButton(
              label: step == 2 ? 'Réinitialiser →' : 'Continuer →',
              loading: loading,
              onTap: step == 0
                  ? () => _ctrl.sendForgotEmail(_emailCtrl.text.trim())
                  : step == 1
                  ? () => setState(() => _ctrl.forgotStep.value = 2)
                  : () => _ctrl.resetPassword(
                  email: _emailCtrl.text.trim(),
                  password: _newPwdCtrl.text),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}