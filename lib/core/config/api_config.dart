import 'app_config.dart';
class ApiConfig {
  static String get baseUrl => AppConfig.apiBaseUrl;
  static String get accessKey => AppConfig.apiAccessKey;
  static const String convertEndpoint = '/convert';
  static String getConvertUrl({
    required String from,
    required String to,
    required double amount,
  }) {
    if (!AppConfig.isConfigValid) {
      throw Exception('API Configuration Error: ${AppConfig.validationMessage}');
    }
    return '$baseUrl$convertEndpoint?from=$from&to=$to&amount=$amount&access_key=$accessKey';
  }
  static bool get isConfigured => AppConfig.isConfigValid;
  static String get configError => AppConfig.validationMessage;
} 