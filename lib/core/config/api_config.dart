class ApiConfig {
  // Update this URL to match your backend IP
  static const String baseUrl = 'http://192.168.56.1:8000';

  // Dashboard endpoints
  static const String dashboardEndpoint = '$baseUrl/mobile/dashboard';
  static const String weatherForecastEndpoint = '$baseUrl/weather/forecast';

  // Rainwater harvesting endpoints
  static const String predictStructureEndpoint = '$baseUrl/predict/structure';

  // AI endpoints
  static const String aiVerificationEndpoint = '$baseUrl/ai_verification';
  static const String aiRagEndpoint = '$baseUrl/ai_rag';

  // Request timeouts
  static const Duration requestTimeout = Duration(seconds: 10);
}
