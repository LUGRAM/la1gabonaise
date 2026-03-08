import 'package:get/get.dart';
import '../../core/network/network_manager.dart';
import '../../core/storage/app_storage.dart';

/// Bindings injectés au démarrage de l'app (avant le premier écran).
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services globaux permanents
    // Get.put<NetworkManager>(NetworkManager(), permanent: true);
    // AppStorage déjà initialisé dans main.dart via await
  }
}
