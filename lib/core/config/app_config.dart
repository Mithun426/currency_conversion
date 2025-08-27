class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '', 
  );
  static const String accessKey = String.fromEnvironment(
    'ACCESS_KEY',
    defaultValue: '', 
  );
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  static bool get isConfigValid {
    return baseUrl.isNotEmpty && accessKey.isNotEmpty;
  }
  static String get validationMessage {
    final List<String> missing = [];
    if (baseUrl.isEmpty) {
      missing.add('BASE_URL');
    }
    if (accessKey.isEmpty) {
      missing.add('ACCESS_KEY');
    }
    if (missing.isEmpty) {
      return 'Configuration is valid';
    }
    return 'Missing required environment variables: ${missing.join(', ')}\n'
           'Please run with: flutter run --dart-define=BASE_URL=your_url --dart-define=ACCESS_KEY=your_key';
  }
  static String get apiBaseUrl => baseUrl;
  static String get apiAccessKey => accessKey;
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static void printConfig() {
    if (isDevelopment) {
      print('=== App Configuration ===');
      print('Environment: $environment');
      print('Base URL: ${baseUrl.isNotEmpty ? "✓ Configured" : "✗ Missing"}');
      print('Access Key: ${accessKey.isNotEmpty ? "✓ Configured" : "✗ Missing"}');
      print('Valid: $isConfigValid');
      if (!isConfigValid) {
        print('Error: $validationMessage');
      }
      print('========================');
    }
  }
} 