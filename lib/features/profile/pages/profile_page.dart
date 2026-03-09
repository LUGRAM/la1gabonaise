import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../controller/profile_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/l1_bottom_nav.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            // Hero
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, bottom: 20),
              decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A0003), AppColors.bg])),
              child: Column(children: [
                Container(width: 72, height: 72, decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B0000), AppColors.primary]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20)],
                ), child: const Center(child: Text('👨🏿', style: TextStyle(fontSize: 32)))),
                const SizedBox(height: 10),
                Obx(() => Text(controller.userName, style: AppTextStyles.h1)),
                const SizedBox(height: 4),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primaryGlow, border: Border.all(color: AppColors.primary.withOpacity(0.3)), borderRadius: BorderRadius.circular(20)),
                  child: Text(controller.userPlan.toUpperCase() + ' · Actif',
                      style: const TextStyle(fontSize: 10, color: AppColors.primary, fontFamily: 'monospace', letterSpacing: 2, fontWeight: FontWeight.w600)),
                )),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVar,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 13),
                      SizedBox(width: 6),
                      Text('Modifier le profil', style: TextStyle(
                          fontSize: 11, color: AppColors.textMuted,
                          fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ]),
            ),
            // Stats
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(color: AppColors.surfaceVar, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                _stat('14', 'Favoris'), _divider(), _stat('8', 'Téléchargés'), _divider(), _stat('3', 'Profils'),
              ]),
            ),
            const SizedBox(height: 8),
            // Menu
            _menuItem('💳', 'Mon abonnement', onTap: controller.goToSubscription),
            _menuItem('🔔', 'Notifications', badge: '3', onTap: controller.goToNotifications),
            _menuItem('⬇️', 'Téléchargements', onTap: () {}),
            _menuItem('🕐', 'Historique', onTap: () {}),
            _menuItem('👶', 'Contrôle parental', onTap: controller.goToParental),
            _menuItem('⚙️', 'Paramètres', onTap: controller.goToSettings),
            _menuItem('❓', 'Aide & Support', onTap: controller.goToHelp),
            _menuItem('🚪', 'Se déconnecter', isRed: true, onTap: controller.logout),
            const SizedBox(height: 100),
          ]),
        ),
        const Positioned(bottom: 0, left: 0, right: 0, child: L1BottomNav(currentIndex: 3)),
      ]),
    );
  }

  Widget _stat(String num, String label) => Expanded(child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Column(children: [
      Text(num, style: const TextStyle(fontFamily: 'Playfair', fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
      Text(label, style: AppTextStyles.bodySmall),
    ]),
  ));

  Widget _divider() => Container(width: 1, height: 36, color: AppColors.border);

  Widget _menuItem(String icon, String label, {String? badge, bool isRed = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        child: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(
            color: isRed ? AppColors.primaryGlow : AppColors.surfaceVar,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isRed ? AppColors.primary.withOpacity(0.2) : AppColors.border),
          ), child: Center(child: Text(icon, style: const TextStyle(fontSize: 16)))),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isRed ? AppColors.primary : AppColors.textPrimary))),
          if (badge != null) Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: Text(badge, style: const TextStyle(fontSize: 9, color: Colors.white, fontFamily: 'monospace'))),
          Icon(Icons.chevron_right, color: isRed ? AppColors.primary : AppColors.textDisabled, size: 18),
        ]),
      ),
    );
  }
}