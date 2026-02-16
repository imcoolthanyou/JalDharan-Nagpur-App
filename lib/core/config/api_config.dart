class ApiConfig {
  // Update this URL to match your backend IP
  // Socket.IO server also runs on the same IP:PORT
  // Example: http://192.168.1.10:8000 (WebSocket connects automatically)
  // Or: http://10.0.2.2:8000 (for Android emulator localhost)
  // Or: http://localhost:8000 (for iOS simulator on Mac)
  static const String baseUrl = 'http://10.205.142.219:8000';

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

  // Socket.IO Configuration
  // ========================
  // The SocketService automatically connects to:
  // WebSocket: ws://{baseUrl}
  //
  // Backend Socket.IO Server emits 'sensor_update' event with RAW SENSOR DATA ONLY:
  // {
  //   "water_depth_m": double,
  //   "flow_rate_L_min": double,
  //   "tds_value": double,
  //   "pump_current_amps": double,
  //   "voltage": double,
  //   "ph": double,
  //   "timestamp": string (ISO format)
  // }
  //
  // This is the LIVE/REAL-TIME sensor data stream.
  // Calculated data (water_quality, motor_load, groundwater_trend, weather_data)
  // comes from the REST endpoint /mobile/dashboard which should be called
  // periodically (every 5-10 seconds) to get the full calculated data.
  //
  // See SOCKET_IO_INTEGRATION.txt for complete documentation
}


