import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/config/app_config.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/network/app_client.dart';
import 'core/storage/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialisation storage
  await AppStorage.instance.init();

  // Initialisation client HTTP
  AppClient.instance.init();

  runApp(const LA1GabonnaiseApp());
}

class LA1GabonnaiseApp extends StatelessWidget {
  const LA1GabonnaiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.splash,
      initialBinding: InitialBinding(),
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      locale: const Locale('fr', 'GA'),
      fallbackLocale: const Locale('fr', 'FR'),
    );
  }
}