import 'package:get/get.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../app/routes/app_routes.dart';

class ProfileController extends GetxController {
  AuthController get _auth => Get.find<AuthController>();

  String get userName => _auth.user.value?.name ?? 'Utilisateur';
  String get userPlan => _auth.user.value?.plan ?? 'Aucun';

  final RxBool autoplay   = true.obs;
  final RxBool dataSaver  = false.obs;
  final RxBool newContent = true.obs;
  final RxBool liveNotif  = true.obs;
  final RxBool payNotif   = true.obs;

  void goToSubscription() => Get.toNamed(AppRoutes.subscription);
  void goToSettings()     => Get.toNamed(AppRoutes.settings);
  void goToParental()     => Get.toNamed(AppRoutes.parental);
  void goToHelp()         => Get.toNamed(AppRoutes.help);
  void goToNotifications() => Get.toNamed(AppRoutes.notifications);

  Future<void> logout() async {
    await Get.find<AuthController>().logout();
  }
}
