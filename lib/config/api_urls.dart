class ApiUrls {
  static const String BASE_URL = 'https://inside.beasiswamahaghora.com/api';

  /// AUTHENTICATION
  static const String login = '/login';
  static const String ssoLogin = 'https://beasiswamahaghora.com/login?redirect=https://inside.beasiswamahaghora.com/sso-login-mobile';
  static const String getProfile = '/user';

  /// ACTIVITY
  static const String getShifts = '/shifts';
  static const String getMeetings = '/meetings';
  static const String createActivity = '/activity';
}
