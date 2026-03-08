import 'package:get/get.dart';
import '../service/auth_service.dart';
import '../model/user_model.dart';
import '../model/data/mock_user.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/widgets/app_snackbar.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/storage/app_storage.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();
  static const bool _mockMode = true;

  final Rx<UserModel?> user  = Rx<UserModel?>(null);
  final RxBool isLoading     = false.obs;
  final RxString otpCode     = ''.obs;
  final RxInt otpTimer       = 120.obs;
  String pendingEmail        = '';
  final RxInt forgotStep     = 0.obs;
  final RxString forgotOtpCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.value   = _service.cachedUser;
    pendingEmail = AppStorage.instance.get<String>('pending_email') ?? '';
  }

  // ── Login ─────────────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      if (_mockMode) { user.value = kMockUser; Get.offAllNamed(AppRoutes.home); return; }
      final u = await _service.login(email: email, password: password);
      user.value = u;
      u.plan == null ? Get.offAllNamed('/plans') : Get.offAllNamed(AppRoutes.home);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register (email + password uniquement) ────────────
  Future<void> register({required String email, required String password}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      if (_mockMode) {
        user.value = kMockUser;
        Get.offAllNamed('/plans');
        return;
      }
      await _service.register(email: email, password: password);
      // Pas d'OTP — redirection directe vers les plans
      Get.offAllNamed('/plans');
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  // ── OTP ───────────────────────────────────────────────
  Future<void> verifyOtp() async {
    if (otpCode.value.length < 6) { AppSnackbar.error('Code complet à 6 chiffres requis'); return; }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      if (_mockMode) {
        user.value = kMockUser;
        AppSnackbar.success('Compte vérifié !');
        Get.offAllNamed('/plans');
        return;
      }
      final u = await _service.verifyOtp(email: pendingEmail, code: otpCode.value);
      user.value = u;
      AppSnackbar.success('Compte vérifié !');
      Get.offAllNamed('/plans');
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!_mockMode) await _service.resendOtp(pendingEmail);
    _startOtpTimer();
    AppSnackbar.info('Code renvoyé par SMS');
  }

  void _startOtpTimer() {
    otpTimer.value = 120;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (otpTimer.value > 0) { otpTimer.value--; return true; }
      return false;
    });
  }

  // ── Forgot password ───────────────────────────────────
  Future<void> sendForgotEmail(String email) async {
    if (email.trim().isEmpty) return;
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      if (!_mockMode) await _service.forgotPassword(email.trim());
      forgotStep.value = 1;
      _startOtpTimer();
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({required String email, required String password}) async {
    if (password.length < 8) { AppSnackbar.error('Min. 8 caractères'); return; }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      if (!_mockMode) await _service.resetPassword(email: email, code: forgotOtpCode.value, password: password);
      AppSnackbar.success('Mot de passe réinitialisé !');
      Get.offAllNamed(AppRoutes.login);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    if (!_mockMode) await _service.logout();
    await AppStorage.instance.clearAll();
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  // ── Validators ────────────────────────────────────────
  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email requis';
    if (!GetUtils.isEmail(v)) return 'Email invalide';
    return null;
  }
  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Mot de passe requis';
    if (v.length < 8) return 'Min. 8 caractères';
    return null;
  }
  String? validateRequired(String? v, String label) {
    if (v == null || v.isEmpty) return '$label requis';
    return null;
  }
  String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Téléphone requis';
    if (v.length < 8) return 'Numéro invalide';
    return null;
  }
}