class AnalyticsPoint {
  final double x;
  final double value;
  final bool isPredicted;

  AnalyticsPoint({
    required this.x,
    required this.value,
    required this.isPredicted,
  });
}

class TrendData {
  final String title;
  final String currentValue;
  final String unit;
  final String trend;
  final String trendStatus; // 'up', 'down', 'stable'
  final String status; // 'normal', 'warning', 'critical', 'safe'
  final String criticalZone;
  final List<AnalyticsPoint> weeklyData;
  final List<AnalyticsPoint> monthlyData;

  TrendData({
    required this.title,
    required this.currentValue,
    required this.unit,
    required this.trend,
    required this.trendStatus,
    required this.status,
    required this.criticalZone,
    required this.weeklyData,
    required this.monthlyData,
  });

  // Mock data for Groundwater Trends
  static TrendData mockGroundwaterTrends() {
    return TrendData(
      title: 'Groundwater Trends',
      currentValue: '120',
      unit: 'ft',
      trend: '-5%',
      trendStatus: 'down',
      status: 'warning',
      criticalZone: '140 ft',
      weeklyData: [
        AnalyticsPoint(x: 0, value: 118, isPredicted: false),
        AnalyticsPoint(x: 1, value: 119, isPredicted: false),
        AnalyticsPoint(x: 2, value: 118.5, isPredicted: false),
        AnalyticsPoint(x: 3, value: 120, isPredicted: false),
        AnalyticsPoint(x: 4, value: 121, isPredicted: false),
        AnalyticsPoint(x: 5, value: 120.5, isPredicted: false),
        AnalyticsPoint(x: 6, value: 120, isPredicted: false),
        AnalyticsPoint(x: 6, value: 120, isPredicted: true),
        AnalyticsPoint(x: 6.5, value: 121.2, isPredicted: true),
        AnalyticsPoint(x: 7, value: 122.5, isPredicted: true),
      ],
      monthlyData: [
        AnalyticsPoint(x: 0, value: 115, isPredicted: false),
        AnalyticsPoint(x: 5, value: 117, isPredicted: false),
        AnalyticsPoint(x: 10, value: 119, isPredicted: false),
        AnalyticsPoint(x: 15, value: 120, isPredicted: false),
        AnalyticsPoint(x: 20, value: 119, isPredicted: false),
        AnalyticsPoint(x: 25, value: 118.5, isPredicted: false),
        AnalyticsPoint(x: 30, value: 120, isPredicted: false),
        AnalyticsPoint(x: 30, value: 120, isPredicted: true),
        AnalyticsPoint(x: 40, value: 125, isPredicted: true),
        AnalyticsPoint(x: 50, value: 128, isPredicted: true),
      ],
    );
  }

  // Mock data for Water pH Trends
  static TrendData mockWaterPhTrends() {
    return TrendData(
      title: 'Water pH Trends',
      currentValue: '7.2',
      unit: '',
      trend: '0%',
      trendStatus: 'stable',
      status: 'normal',
      criticalZone: 'NEUTRAL BASELINE',
      weeklyData: [
        AnalyticsPoint(x: 0, value: 7.1, isPredicted: false),
        AnalyticsPoint(x: 1, value: 7.15, isPredicted: false),
        AnalyticsPoint(x: 2, value: 7.2, isPredicted: false),
        AnalyticsPoint(x: 3, value: 7.18, isPredicted: false),
        AnalyticsPoint(x: 4, value: 7.22, isPredicted: false),
        AnalyticsPoint(x: 5, value: 7.2, isPredicted: false),
        AnalyticsPoint(x: 6, value: 7.2, isPredicted: false),
        AnalyticsPoint(x: 6, value: 7.2, isPredicted: true),
        AnalyticsPoint(x: 6.5, value: 7.21, isPredicted: true),
        AnalyticsPoint(x: 7, value: 7.22, isPredicted: true),
      ],
      monthlyData: [
        AnalyticsPoint(x: 0, value: 7.0, isPredicted: false),
        AnalyticsPoint(x: 5, value: 7.1, isPredicted: false),
        AnalyticsPoint(x: 10, value: 7.15, isPredicted: false),
        AnalyticsPoint(x: 15, value: 7.2, isPredicted: false),
        AnalyticsPoint(x: 20, value: 7.18, isPredicted: false),
        AnalyticsPoint(x: 25, value: 7.19, isPredicted: false),
        AnalyticsPoint(x: 30, value: 7.2, isPredicted: false),
        AnalyticsPoint(x: 30, value: 7.2, isPredicted: true),
        AnalyticsPoint(x: 40, value: 7.21, isPredicted: true),
        AnalyticsPoint(x: 50, value: 7.22, isPredicted: true),
      ],
    );
  }

  // Mock data for TDS Trends
  static TrendData mockTdsTrends() {
    return TrendData(
      title: 'TDS Trends',
      currentValue: '245',
      unit: 'ppm',
      trend: '+2%',
      trendStatus: 'up',
      status: 'normal',
      criticalZone: 'MAX SAFE LIMIT',
      weeklyData: [
        AnalyticsPoint(x: 0, value: 240, isPredicted: false),
        AnalyticsPoint(x: 1, value: 242, isPredicted: false),
        AnalyticsPoint(x: 2, value: 244, isPredicted: false),
        AnalyticsPoint(x: 3, value: 243, isPredicted: false),
        AnalyticsPoint(x: 4, value: 245, isPredicted: false),
        AnalyticsPoint(x: 5, value: 244, isPredicted: false),
        AnalyticsPoint(x: 6, value: 245, isPredicted: false),
        AnalyticsPoint(x: 6, value: 245, isPredicted: true),
        AnalyticsPoint(x: 6.5, value: 246, isPredicted: true),
        AnalyticsPoint(x: 7, value: 248, isPredicted: true),
      ],
      monthlyData: [
        AnalyticsPoint(x: 0, value: 235, isPredicted: false),
        AnalyticsPoint(x: 5, value: 238, isPredicted: false),
        AnalyticsPoint(x: 10, value: 240, isPredicted: false),
        AnalyticsPoint(x: 15, value: 242, isPredicted: false),
        AnalyticsPoint(x: 20, value: 244, isPredicted: false),
        AnalyticsPoint(x: 25, value: 244, isPredicted: false),
        AnalyticsPoint(x: 30, value: 245, isPredicted: false),
        AnalyticsPoint(x: 30, value: 245, isPredicted: true),
        AnalyticsPoint(x: 40, value: 248, isPredicted: true),
        AnalyticsPoint(x: 50, value: 252, isPredicted: true),
      ],
    );
  }

  // Mock data for Water Quality Score Trends
  static TrendData mockQualityScoreTrends() {
    return TrendData(
      title: 'Water Quality Score Trends',
      currentValue: '92',
      unit: '/100',
      trend: '+1%',
      trendStatus: 'up',
      status: 'normal',
      criticalZone: 'OVERALL SCORE',
      weeklyData: [
        AnalyticsPoint(x: 0, value: 90, isPredicted: false),
        AnalyticsPoint(x: 1, value: 91, isPredicted: false),
        AnalyticsPoint(x: 2, value: 91, isPredicted: false),
        AnalyticsPoint(x: 3, value: 92, isPredicted: false),
        AnalyticsPoint(x: 4, value: 92, isPredicted: false),
        AnalyticsPoint(x: 5, value: 92, isPredicted: false),
        AnalyticsPoint(x: 6, value: 92, isPredicted: false),
        AnalyticsPoint(x: 6, value: 92, isPredicted: true),
        AnalyticsPoint(x: 6.5, value: 92, isPredicted: true),
        AnalyticsPoint(x: 7, value: 93, isPredicted: true),
      ],
      monthlyData: [
        AnalyticsPoint(x: 0, value: 88, isPredicted: false),
        AnalyticsPoint(x: 5, value: 89, isPredicted: false),
        AnalyticsPoint(x: 10, value: 90, isPredicted: false),
        AnalyticsPoint(x: 15, value: 91, isPredicted: false),
        AnalyticsPoint(x: 20, value: 91, isPredicted: false),
        AnalyticsPoint(x: 25, value: 92, isPredicted: false),
        AnalyticsPoint(x: 30, value: 92, isPredicted: false),
        AnalyticsPoint(x: 30, value: 92, isPredicted: true),
        AnalyticsPoint(x: 40, value: 93, isPredicted: true),
        AnalyticsPoint(x: 50, value: 94, isPredicted: true),
      ],
    );
  }
}
