import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_input.dart';
import '../../../app/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(children: [
        Container(height: 200, decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0003), AppColors.bg]),
        )),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 40),
                Center(child: RichText(text: const TextSpan(children: [
                  TextSpan(text: 'LA', style: TextStyle(fontFamily: 'Playfair', fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                  TextSpan(text: '1', style: TextStyle(fontFamily: 'Playfair', fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 4)),
                  TextSpan(text: 'GABONAISE', style: TextStyle(fontFamily: 'Playfair', fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                ]))),
                const SizedBox(height: 4),
                const Center(child: Text('ICI C\'EST MADE IN GABON',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: AppColors.textMuted, letterSpacing: 4))),
                const SizedBox(height: 36),
                Text('Connexion', style: AppTextStyles.display3),
                const SizedBox(height: 4),
                const Text('Bon retour sur LA1GABONAISE', style: AppTextStyles.body2),
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
                  textInputAction: TextInputAction.done,
                  validator: _ctrl.validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.forgotPwd),
                      child: const Text('Mot de passe oublié ?',
                          style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    )),
                const SizedBox(height: 24),
                AppButton(
                  label: 'SE CONNECTER',
                  loading: _ctrl.isLoading.value,
                  onTap: _submit,
                ),
                const SizedBox(height: 20),
                Row(children: const [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'monospace'))),
                  Expanded(child: Divider(color: AppColors.border)),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: AppButton(label: 'G  Google', variant: AppButtonVariant.outline, onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: AppButton(label: 'f  Facebook', variant: AppButtonVariant.outline, onTap: () {})),
                ]),
                const SizedBox(height: 28),
                Center(child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.register),
                  child: RichText(text: const TextSpan(
                    text: 'Pas encore de compte ? ',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    children: [TextSpan(text: 'S\'inscrire',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))],
                  )),
                )),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _ctrl.login(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
  }
}