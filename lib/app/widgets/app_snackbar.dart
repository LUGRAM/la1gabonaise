import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Succès',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success.withOpacity(0.12),
      colorText: AppColors.textPrimary,
      borderColor: AppColors.success,
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
      duration: const Duration(seconds: 3),
    );
  }

  static void error(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Erreur',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error.withOpacity(0.12),
      colorText: AppColors.textPrimary,
      borderColor: AppColors.error,
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: AppColors.error),
      duration: const Duration(seconds: 4),
    );
  }

  static void info(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info.withOpacity(0.12),
      colorText: AppColors.textPrimary,
      borderColor: AppColors.info,
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: AppColors.info),
      duration: const Duration(seconds: 3),
    );
  }
}
