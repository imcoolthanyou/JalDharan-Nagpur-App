class GroundwaterData {
  final double currentDepth;
  final double totalDepth;
  final double flowRate;
  final String remainingPercentage;
  final double qualityScore;
  final String qualityStatus;
  final double currentSession;
  final double estimatedExtraction;
  final double tdsLevel;
  final String tdsStatus;
  final double phLevel;
  final String phStatus;
  final double voltage;
  final double current;
  final String motorStatus;
  final double extractionRate;
  final String extractionStatus;
  final String lastUpdated;

  // Prediction fields
  final double predictedDepth7Days;
  final double predictedDepth14Days;
  final double predictedDepth30Days;
  final String trend30Days;
  final String waterStressLevel;

  // Weather data fields
  final double? weatherTemp;
  final String? weatherCondition;
  final String? weatherDescription;
  final String? weatherIcon;
  final String? rainAlert;

  GroundwaterData({
    required this.currentDepth,
    required this.totalDepth,
    required this.flowRate,
    required this.remainingPercentage,
    required this.qualityScore,
    required this.qualityStatus,
    required this.currentSession,
    required this.estimatedExtraction,
    required this.tdsLevel,
    required this.tdsStatus,
    required this.phLevel,
    required this.phStatus,
    required this.voltage,
    required this.current,
    required this.motorStatus,
    required this.extractionRate,
    required this.extractionStatus,
    required this.lastUpdated,
    required this.predictedDepth7Days,
    required this.predictedDepth14Days,
    required this.predictedDepth30Days,
    required this.trend30Days,
    required this.waterStressLevel,
    this.weatherTemp,
    this.weatherCondition,
    this.weatherDescription,
    this.weatherIcon,
    this.rainAlert,
  });

  // Helper to calculate Power in kW
  double get powerKw => (voltage * current) / 1000;

  // Helper to format lastUpdated as HH:MM format
  String get formattedTime {
    try {
      final dateTime = DateTime.parse(lastUpdated);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return lastUpdated; // Fallback to original if parsing fails
    }
  }

  // Helper for Quality Score
  double getQualityScore() {
    switch (qualityStatus.toLowerCase()) {
      case 'excellent':
        return 95.0;
      case 'good':
        return 80.0;
      case 'poor':
        return 45.0;
      default:
        return 20.0;
    }
  }

  // Factory constructor from JSON (for API integration)
  factory GroundwaterData.fromJson(Map<String, dynamic> json) {
    final sensor = json['sensor_data'] ?? {};
    final quality = json['water_quality'] ?? {};
    final motor = json['motor_load'] ?? {};
    final trend = json['groundwater_trend'] ?? {}; // Safely handle null
    final weather = json['weather_data'] ?? {}; // Safely handle null

    final currentDepth = (sensor['water_depth_m'] ?? 0.0).toDouble();
    final totalDepth = 50.0;

    return GroundwaterData(
      currentDepth: currentDepth,
      totalDepth: totalDepth,
      flowRate: (sensor['flow_rate_L_min'] ?? 0.0).toDouble(),
      remainingPercentage: '${((1 - (currentDepth / totalDepth)) * 100).toStringAsFixed(1)}%',
      qualityScore: 80.0,
      qualityStatus: quality['quality_class'] ?? 'Good',
      currentSession: (json['water_extraction']?['current_session_m3'] ?? 0.0).toDouble(),
      estimatedExtraction: (json['water_extraction']?['extracted_amount_m3'] ?? 0.0).toDouble(),
      tdsLevel: (sensor['tds_value'] ?? 0.0).toDouble(),
      tdsStatus: 'Safe',
      phLevel: (sensor['ph'] ?? 7.0).toDouble(),
      phStatus: 'Balanced',
      voltage: (sensor['voltage'] ?? 0.0).toDouble(),
      current: (sensor['pump_current_amps'] ?? 0.0).toDouble(),
      motorStatus: motor['motor_status'] ?? 'Off',
      extractionRate: (sensor['flow_rate_L_min'] ?? 0.0).toDouble(),
      extractionStatus: 'Active',
      lastUpdated: json['timestamp'] ?? DateTime.now().toString(),
      // Prediction data
      predictedDepth7Days: (trend['predicted_depth_7days'] ?? 0.0).toDouble(),
      predictedDepth14Days: (trend['predicted_depth_14days'] ?? 0.0).toDouble(),
      predictedDepth30Days: (trend['predicted_depth_30days'] ?? 0.0).toDouble(),
      trend30Days: trend['trend_30days'] ?? 'stable',
      waterStressLevel: trend['water_stress_level'] ?? 'low',
      // Weather data
      weatherTemp: (weather['temp'] ?? 0.0).toDouble(),
      weatherCondition: weather['condition'] ?? 'Clear',
      weatherDescription: weather['description'] ?? 'clear',
      weatherIcon: weather['icon'] ?? '01d',
      rainAlert: weather['rain_alert'] ?? '',
    );
  }

  // Mock data for Current Data tab
  static GroundwaterData mockCurrentData() {
    return GroundwaterData(
      currentDepth: 35,
      totalDepth: 50,
      flowRate: 2.5,
      remainingPercentage: '30%',
      qualityScore: 85,
      qualityStatus: 'Excellent',
      currentSession: 450,
      estimatedExtraction: 2800,
      tdsLevel: 250,
      tdsStatus: 'Safe',
      phLevel: 7.2,
      phStatus: 'Balanced',
      voltage: 230,
      current: 5.2,
      motorStatus: 'Normal',
      extractionRate: 2.5,
      extractionStatus: 'Optimal',
      lastUpdated: '10 mins ago',
      predictedDepth7Days: 34.8,
      predictedDepth14Days: 34.5,
      predictedDepth30Days: 34.0,
      trend30Days: 'falling',
      waterStressLevel: 'moderate',
      // Weather data
      weatherTemp: 28.5,
      weatherCondition: 'Partly Cloudy',
      weatherDescription: 'partly cloudy',
      weatherIcon: '02d',
      rainAlert: 'No rain expected',
    );
  }

  // Mock data for Average Data tab
  static GroundwaterData mockAverageData() {
    return GroundwaterData(
      currentDepth: 38,
      totalDepth: 50,
      flowRate: 2.0,
      remainingPercentage: '24%',
      qualityScore: 82,
      qualityStatus: 'Good',
      currentSession: 425,
      estimatedExtraction: 2600,
      tdsLevel: 260,
      tdsStatus: 'Safe',
      phLevel: 7.1,
      phStatus: 'Balanced',
      voltage: 230,
      current: 4.8,
      motorStatus: 'Normal',
      extractionRate: 2.4,
      extractionStatus: 'Optimal',
      lastUpdated: '7 days average',
      predictedDepth7Days: 37.8,
      predictedDepth14Days: 37.5,
      predictedDepth30Days: 37.0,
      trend30Days: 'stable',
      waterStressLevel: 'low',
      // Weather data
      weatherTemp: 26.3,
      weatherCondition: 'Clear',
      weatherDescription: 'clear sky',
      weatherIcon: '01d',
      rainAlert: 'No rain expected',
    );
  }
}

class AverageDataMetrics {
  final String metric;
  final double value;
  final String unit;
  final double trend;
  final String trendStatus; // 'up', 'down', 'stable'
  final List<double> chartData;

  AverageDataMetrics({
    required this.metric,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendStatus,
    required this.chartData,
  });

  static List<AverageDataMetrics> mockMetrics() {
    return [
      AverageDataMetrics(
        metric: 'Avg. Depth',
        value: 58,
        unit: 'Feet',
        trend: 2,
        trendStatus: 'up',
        chartData: [50, 52, 54, 56, 57, 58, 58],
      ),
      AverageDataMetrics(
        metric: 'Avg. pH',
        value: 7.1,
        unit: 'pH',
        trend: 0,
        trendStatus: 'stable',
        chartData: [7.0, 7.1, 7.1, 7.2, 7.1, 7.1, 7.1],
      ),
      AverageDataMetrics(
        metric: 'Avg. TDS',
        value: 260,
        unit: 'ppm',
        trend: -3,
        trendStatus: 'down',
        chartData: [270, 268, 265, 262, 260, 260, 260],
      ),
      AverageDataMetrics(
        metric: 'Avg. Quality',
        value: 82,
        unit: '/100',
        trend: 1,
        trendStatus: 'up',
        chartData: [80, 80, 81, 82, 82, 82, 82],
      ),
    ];
  }
}
