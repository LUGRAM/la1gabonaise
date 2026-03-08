import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/storage/app_storage.dart';
import '../model/data/onboarding_mock.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final slides = kOnboardingSlides;
  int get total => slides.length;

  bool get isLast => currentPage.value == total - 1;

  void nextPage() {
    if (isLast) {
      _finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void skip() => _finish();

  void onPageChanged(int index) => currentPage.value = index;

  Future<void> _finish() async {
    await AppStorage.instance.setOnboardingDone();
    Get.offAllNamed(AppRoutes.register);
  }

  void goToLogin() => Get.offAllNamed(AppRoutes.login);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
