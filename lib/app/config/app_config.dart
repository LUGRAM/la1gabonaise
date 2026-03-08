abstract class AppConfig {
  // ── Environnement ─────────────────────────
  static const bool isDev = true;
  static const String _prod = 'https://la1gabonaise.com/api';
  static const String _dev  = 'http://localhost:8000/api';
  // Android emulator → http://10.0.2.2:8000/api
  // Device physique  → http://<IP_locale>:8000/api
  static String get baseUrl => isDev ? _dev : _prod;

  // ── Endpoints ─────────────────────────────
  static const String login        = '/auth/login';
  static const String register     = '/auth/register';
  static const String otpVerify    = '/auth/otp/verify';
  static const String otpResend    = '/auth/otp/resend';
  static const String forgotPwd    = '/auth/forgot-password';
  static const String resetPwd     = '/auth/reset-password';
  static const String logout       = '/auth/logout';
  static const String me           = '/user/profile';
  static const String contents     = '/contents';
  static const String categories   = '/categories';
  static const String plans        = '/subscription/plans';
  static const String subscribe    = '/subscription/subscribe';

  // ── Timeouts ──────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── Storage keys ──────────────────────────
  static const String kToken          = 'access_token';
  static const String kRefreshToken   = 'refresh_token';
  static const String kUser           = 'user_data';
  static const String kOnboarding     = 'onboarding_done';
  static const String kActiveProfile  = 'active_profile';

  // ── App ───────────────────────────────────
  static const String appName    = 'LA1GABONAISE';
  static const String appVersion = '1.0.0';
  static const String supportMail = 'support@la1gabonaise.com';
}