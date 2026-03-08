import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_input.dart';
import '../../../app/routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  final _formKey      = GlobalKey<FormState>();
  final _ctrl         = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _ctrl.isLoading.listen((_) { if (mounted) setState(() {}); });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _ctrl.register(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0003), AppColors.bg],
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 32),
                Center(child: RichText(text: const TextSpan(children: [
                  TextSpan(text: 'LA',        style: TextStyle(fontFamily: 'Playfair', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                  TextSpan(text: '1',         style: TextStyle(fontFamily: 'Playfair', fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 4)),
                  TextSpan(text: 'GABONAISE', style: TextStyle(fontFamily: 'Playfair', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                ]))),
                const SizedBox(height: 4),
                const Center(child: Text('ICI C\'EST MADE IN GABON',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: AppColors.textMuted, letterSpacing: 4))),
                const SizedBox(height: 36),
                Text('Créer un compte', style: AppTextStyles.display3),
                const SizedBox(height: 4),
                const Text('Rejoignez le streaming 100% gabonais', style: AppTextStyles.body2),
                const SizedBox(height: 28),

                AppInput(
                  label: 'Email', hint: 'votre@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _ctrl.validateEmail,
                  prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textMuted, size: 18),
                ),
                const SizedBox(height: 14),
                AppInput(
                  label: 'Mot de passe', hint: '••••••••',
                  controller: _passwordCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: _ctrl.validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
                ),
                const SizedBox(height: 14),
                AppInput(
                  label: 'Confirmer le mot de passe', hint: '••••••••',
                  controller: _confirmCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirmation requise';
                    if (v != _passwordCtrl.text) return 'Les mots de passe ne correspondent pas';
                    return null;
                  },
                  onSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: 20),

                // CGU
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Text(
                    'J\'accepte les Conditions d\'utilisation et la Politique de confidentialité de LA1GABONAISE',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.6),
                  )),
                ]),
                const SizedBox(height: 24),

                AppButton(
                  label: 'CRÉER UN COMPTE',
                  loading: _ctrl.isLoading.value,
                  onTap: _submit,
                ),
                const SizedBox(height: 20),

                Center(child: GestureDetector(
                  onTap: () => Get.offNamed(AppRoutes.login),
                  child: RichText(text: const TextSpan(
                    text: 'Déjà un compte ? ',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    children: [TextSpan(text: 'Se connecter',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))],
                  )),
                )),
                const SizedBox(height: 36),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

}