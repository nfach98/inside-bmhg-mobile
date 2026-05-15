class ApiUrls {
  static const String BASE_URL = 'http://localhost:8000/api';

  /// AUTHENTICATION
  static const String login = '$BASE_URL/login';
  static const String getProfile = '$BASE_URL/user';

  /// ACTIVITY
  static const String getShifts = '$BASE_URL/shifts';
  static const String getMeetings = '$BASE_URL/meetings';
  static const String createActivity = '$BASE_URL/activity';
}
