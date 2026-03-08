import 'package:get/get.dart';
import '../../../app/config/app_config.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/storage/app_storage.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    final storage   = AppStorage.instance;
    final token     = storage.getToken();
    final onboarded = storage.isOnboardingDone;

    if (token != null) {
      Get.offAllNamed(AppRoutes.home);
    } else if (!onboarded) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}