import 'package:get/get.dart';
import '../transitions/app_transitions.dart';

import '../../features/splash/pages/splash_page.dart';
import '../../features/splash/binding/splash_binding.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/onboarding/binding/onboarding_binding.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/otp_page.dart';
import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/auth/pages/pick_profile_page.dart';
import '../../features/auth/binding/auth_binding.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/home/binding/home_binding.dart';
import '../../features/search/pages/search_page.dart';
import '../../features/search/binding/search_binding.dart';
import '../../features/downloads/pages/downloads_page.dart';
import '../../features/downloads/binding/downloads_binding.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/profile/pages/edit_profile_page.dart';
import '../../features/profile/pages/settings_page.dart';
import '../../features/profile/pages/subscription_page.dart';
import '../../features/profile/pages/notifications_page.dart';
import '../../features/profile/binding/profile_binding.dart';
import '../../features/subscription/pages/plans_page.dart';
import '../../features/subscription/pages/payment_page.dart';
import '../../features/subscription/pages/payment_success_page.dart';
import '../../features/subscription/binding/subscription_binding.dart';
import '../../features/player/pages/player_page.dart';
import '../../features/player/binding/player_binding.dart';
import '../../features/home/pages/content_detail_page.dart';
import '../../features/home/pages/catalogue_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.splash,      page: () => const SplashPage(),      binding: SplashBinding(),      transition: Transition.fadeIn),
    GetPage(name: AppRoutes.onboarding,  page: () => const OnboardingPage(),  binding: OnboardingBinding(),  customTransition: SlideUpTransition(),    transitionDuration: const Duration(milliseconds: 400)),
    GetPage(name: AppRoutes.login,       page: () => const LoginPage(),       binding: AuthBinding(),        customTransition: FadeScaleTransition(),  transitionDuration: const Duration(milliseconds: 350)),
    GetPage(name: AppRoutes.register,    page: () => const RegisterPage(),    binding: AuthBinding(),        customTransition: SlideRightTransition(), transitionDuration: const Duration(milliseconds: 350)),
    GetPage(name: AppRoutes.otp,         page: () => const OtpPage(),         binding: AuthBinding(),        customTransition: SlideRightTransition()),
    GetPage(name: AppRoutes.forgotPwd,   page: () => const ForgotPasswordPage(), binding: AuthBinding()),
    GetPage(name: AppRoutes.pickProfile, page: () => const PickProfilePage(), binding: AuthBinding(),        customTransition: FadeScaleTransition()),
    GetPage(name: AppRoutes.home,        page: () => const HomePage(),        binding: HomeBinding(),        customTransition: FadeScaleTransition(), transitionDuration: const Duration(milliseconds: 450)),
    GetPage(name: AppRoutes.search,      page: () => const SearchPage(),      binding: SearchBinding(),      customTransition: SlideRightTransition()),
    GetPage(name: AppRoutes.downloads,   page: () => const DownloadsPage(),   binding: DownloadsBinding(),   customTransition: SlideRightTransition()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfilePage(), binding: ProfileBinding(), customTransition: SlideRightTransition()),
    GetPage(name: AppRoutes.profile,     page: () => const ProfilePage(),     binding: ProfileBinding()),
    GetPage(name: AppRoutes.settings,    page: () => const SettingsPage(),    binding: ProfileBinding()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsPage(), binding: ProfileBinding()),
    GetPage(name: AppRoutes.subscription, page: () => const SubscriptionPage(), binding: ProfileBinding()),
    GetPage(name: '/plans',              page: () => const PlansPage(),       binding: SubscriptionBinding()),
    GetPage(name: AppRoutes.payment,     page: () => const PaymentPage(),     binding: SubscriptionBinding()),
    GetPage(name: AppRoutes.paymentSuccess, page: () => const PaymentSuccessPage(), binding: SubscriptionBinding()),
    GetPage(name: AppRoutes.catalogue, page: () => const CataloguePage(), customTransition: SlideRightTransition(), transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: AppRoutes.contentDetail, page: () => const ContentDetailPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: AppRoutes.player,      page: () => const PlayerPage(),      binding: PlayerBinding(), fullscreenDialog: true, customTransition: SlideUpTransition()),
  ];
}