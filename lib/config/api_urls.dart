class ApiUrls {
  static const String BASE_URL = 'http://localhost:8000/api';

  /// AUTHENTICATION
  static const String login = '/login';
  static const String getProfile = '/user';

  /// ACTIVITY
  static const String getShifts = '/shifts';
  static const String getMeetings = '/meetings';
  static const String createActivity = '/activity';
}
