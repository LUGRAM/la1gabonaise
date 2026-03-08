import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put (pas lazyPut) pour instancier immédiatement
    // et déclencher onReady() même si build() n'accède pas à controller
    Get.put<SplashController>(SplashController());
  }
}