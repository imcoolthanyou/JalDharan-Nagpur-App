class WeatherData {
  final double temperature;
  final String condition;
  final String description;
  final String iconCode;
  final String rainAlert;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.rainAlert,
  });

  /// Factory constructor from JSON
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temp'] ?? 0.0).toDouble(),
      condition: json['condition'] ?? 'Clear',
      description: json['description'] ?? 'clear',
      iconCode: json['icon'] ?? '01d',
      rainAlert: json['rain_alert'] ?? '',
    );
  }

  /// Mock weather data for testing
  static WeatherData mockWeatherData() {
    return WeatherData(
      temperature: 28.5,
      condition: 'Partly Cloudy',
      description: 'partly cloudy',
      iconCode: '02d',
      rainAlert: 'No rain expected',
    );
  }

  /// Get weather icon based on icon code
  String getWeatherEmoji() {
    final code = iconCode.replaceAll(RegExp(r'\D'), '');
    switch (code) {
      case '01': return '☀️'; // Clear sky
      case '02': return '⛅'; // Few clouds
      case '03': return '☁️'; // Scattered clouds
      case '04': return '☁️'; // Broken clouds
      case '09': return '🌧️'; // Shower rain
      case '10': return '🌦️'; // Rain
      case '11': return '⛈️'; // Thunderstorm
      case '13': return '❄️'; // Snow
      case '50': return '🌫️'; // Mist/Haze
      default: return '🌤️';
    }
  }

  /// Check if rain is expected
  bool hasRainAlert() {
    return rainAlert.toLowerCase().contains('rain expected') ||
        rainAlert.toLowerCase().contains('thunderstorm');
  }
}
