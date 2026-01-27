import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/analytics_data.dart';
import '../../../core/theme/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.deepAquiferBlue,
                  AppColors.tealStart,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 0),
                        const Expanded(
                          child: Text(
                            'Analytics & Prediction',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppColors.deepAquiferBlue,
                      unselectedLabelColor: AppColors.mediumGrey,
                      indicatorColor: AppColors.deepAquiferBlue,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Weekly'),
                        Tab(text: 'Monthly'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWeeklyView(),
                _buildMonthlyView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTrendCard(TrendData.mockGroundwaterTrends(), isWeekly: true),
          const SizedBox(height: 16),
          _buildTrendCard(TrendData.mockWaterPhTrends(), isWeekly: true),
          const SizedBox(height: 16),
          _buildTrendCard(TrendData.mockTdsTrends(), isWeekly: true),
          const SizedBox(height: 16),
          _buildTrendCard(TrendData.mockQualityScoreTrends(), isWeekly: true),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMonthlyView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTrendCard(TrendData.mockGroundwaterTrends(), isWeekly: false),
          const SizedBox(height: 16),
          _buildTrendCard(TrendData.mockWaterPhTrends(), isWeekly: false),
          const SizedBox(height: 16),
          _buildTrendCard(TrendData.mockTdsTrends(), isWeekly: false),
          const SizedBox(height: 16),
          _buildTrendCard(TrendData.mockQualityScoreTrends(), isWeekly: false),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTrendCard(TrendData data, {required bool isWeekly}) {
    final chartData = isWeekly ? data.weeklyData : data.monthlyData;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepAquiferBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURRENT LEVEL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mediumGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${data.currentValue} ${data.unit}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTrendColor(data.trendStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data.trend,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _getTrendColor(data.trendStatus),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Status/Warning section
          if (data.status == 'warning' || data.status == 'critical')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(data.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(data.status).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: _getStatusColor(data.status),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Warning: Level dropping rapidly',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(data.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (data.status == 'warning' || data.status == 'critical')
            const SizedBox(height: 16),
          // Chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getChartInterval(data),
                    getDrawingHorizontalLine: (value) {
                      if (value == double.parse(data.currentValue)) {
                        return FlLine(
                          color: Colors.red.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      }
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 0.8,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: isWeekly ? 1 : 10,
                        getTitlesWidget: (value, meta) {
                          if (isWeekly) {
                            final labels = [
                              '1 Week',
                              '3 Weeks',
                              'Today',
                              '+3B Days'
                            ];
                            if (value.toInt() < labels.length) {
                              return Text(
                                labels[value.toInt()],
                                style: const TextStyle(
                                  color: AppColors.mediumGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              );
                            }
                          } else {
                            final labels = ['2 Weeks', '1 Week', 'Today'];
                            if (value.toInt() < labels.length) {
                              return Text(
                                labels[value.toInt()],
                                style: const TextStyle(
                                  color: AppColors.mediumGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              );
                            }
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              color: AppColors.mediumGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: chartData.first.x,
                  maxX: chartData.last.x,
                  minY: _getMinY(chartData),
                  maxY: _getMaxY(chartData),
                  lineBarsData: [
                    // History line
                    LineChartBarData(
                      spots: chartData
                          .where((p) => !p.isPredicted)
                          .map((p) => FlSpot(p.x, p.value))
                          .toList(),
                      isCurved: true,
                      color: _getTrendLineColor(data.title),
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: _getTrendLineColor(data.title),
                            strokeWidth: 0,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _getTrendLineColor(data.title).withOpacity(0.1),
                      ),
                    ),
                    // Prediction line (dashed effect with dots)
                    LineChartBarData(
                      spots: chartData
                          .where((p) => p.isPredicted)
                          .map((p) => FlSpot(p.x, p.value))
                          .toList(),
                      isCurved: true,
                      color: _getTrendLineColor(data.title).withOpacity(0.5),
                      barWidth: 2,
                      dashArray: [5, 5],
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 2.5,
                            color: _getTrendLineColor(data.title).withOpacity(0.6),
                            strokeWidth: 0,
                          );
                        },
                      ),
                    ),
                  ],

                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 2,
                      color: _getTrendLineColor(data.title),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'HISTORY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mediumGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 2,
                      decoration: BoxDecoration(
                        color: _getTrendLineColor(data.title).withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AI FORECAST',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mediumGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Critical zone indicator
          if (data.status == 'warning' || data.status == 'critical')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.criticalZone,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Color _getTrendColor(String trendStatus) {
    switch (trendStatus) {
      case 'up':
        return AppColors.criticalRed;
      case 'down':
        return AppColors.criticalRed;
      case 'stable':
      default:
        return AppColors.safeBlue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'critical':
        return AppColors.criticalRed;
      case 'warning':
        return AppColors.warningOrange;
      case 'safe':
      case 'normal':
      default:
        return AppColors.safeBlue;
    }
  }

  Color _getTrendLineColor(String title) {
    switch (title) {
      case 'Groundwater Trends':
        return AppColors.tealStart;
      case 'Water pH Trends':
        return AppColors.tealEnd;
      case 'TDS Trends':
        return AppColors.deepAquiferBlue;
      case 'Water Quality Score Trends':
        return AppColors.fieldGreen;
      default:
        return AppColors.tealStart;
    }
  }

  double _getChartInterval(TrendData data) {
    try {
      final currentValue = double.parse(data.currentValue);
      if (currentValue > 100) return 5;
      if (currentValue > 50) return 2;
      return 1;
    } catch (e) {
      return 0.5;
    }
  }

  double _getMinY(List<AnalyticsPoint> data) {
    return data.map((p) => p.value).reduce((a, b) => a < b ? a : b) - 5;
  }

  double _getMaxY(List<AnalyticsPoint> data) {
    return data.map((p) => p.value).reduce((a, b) => a > b ? a : b) + 5;
  }
}
