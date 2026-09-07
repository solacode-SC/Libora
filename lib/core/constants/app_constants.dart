/// Core application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Libora';
  static const String appVersion = '1.0.0';
  static const String databaseName = 'libora.sqlite';

  // Secure storage keys
  static const String secureStorageGitHubTokenKey = 'libora_github_token';

  // Default pagination / limits
  static const int defaultPageSize = 20;
}
