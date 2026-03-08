abstract class AppRoutes {
  // Splash
  static const String splash       = '/';

  // Onboarding
  static const String onboarding   = '/onboarding';

  // Auth
  static const String login        = '/login';
  static const String register     = '/register';
  static const String otp          = '/otp';
  static const String forgotPwd    = '/forgot-password';
  static const String resetPwd     = '/reset-password';

  // Profile selection
  static const String pickProfile  = '/pick-profile';
  static const String createProfile = '/create-profile';
  static const String pickGenres   = '/pick-genres';

  // Main
  static const String home         = '/home';
  static const String search       = '/search';
  static const String myList       = '/my-list';
  static const String downloads    = '/downloads';

  // Content
  static const String contentDetail = '/content-detail';
  static const String catalogue = '/catalogue';
  static const String serieDetail   = '/serie/:id';
  static const String player        = '/player';
  static const String liveEvent     = '/live/:id';
  static const String watchParty    = '/watch-party/:id';

  // Profile & Settings
  static const String profile       = '/profile';
  static const String subscription  = '/subscription';
  static const String payment       = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String settings      = '/settings';
  static const String parental      = '/parental';
  static const String help          = '/help';
  static const String notifications = '/notifications';
}