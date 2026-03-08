import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Subscription', style: AppTextStyles.h1),
        leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20)),
      ),
      body: const Center(child: Text('// TODO: Subscription screen', style: TextStyle(color: AppColors.textMuted, fontFamily: 'monospace'))),
    );
  }
}
