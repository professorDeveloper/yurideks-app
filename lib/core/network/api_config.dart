abstract final class ApiConfig {
  static const String baseUrl = 'https://yurideks.uz';
  static const String clientVersion = '1.0.0';
  static const String defaultLocale = 'uz';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String signupPath = '/api/mobile/auth/signup';
  static const String loginPath = '/api/mobile/auth/login';
  static const String refreshPath = '/api/mobile/auth/refresh';
  static const String logoutPath = '/api/mobile/auth/logout';
  static const String mePath = '/api/me';
}
