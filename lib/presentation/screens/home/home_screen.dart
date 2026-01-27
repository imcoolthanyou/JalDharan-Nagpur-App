import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/models/groundwater_data.dart';
import '../../../core/services/dashboard_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/home_widgets.dart';
import '../../widgets/animated_gradient_background.dart';
import '../analytics/analytics_screen.dart';
import '../rainwater_harvesting/rainwater_harvesting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late GroundwaterData _currentData;
  final DashboardApiService _apiService = DashboardApiService();
  bool _isLoading = false;
  late Timer _autoRefreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _currentData = GroundwaterData.mockCurrentData();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (mounted) {
        _fetchDashboardData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _apiService.fetchDashboardData();

      if (!mounted) return;

      if (_hasDataChanged(data)) {
        setState(() {
          _currentData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Dashboard API Error: $e');
    }
  }

  bool _hasDataChanged(GroundwaterData newData) {
    return _currentData.currentDepth != newData.currentDepth ||
        _currentData.flowRate != newData.flowRate ||
        _currentData.tdsLevel != newData.tdsLevel ||
        _currentData.phLevel != newData.phLevel ||
        _currentData.voltage != newData.voltage ||
        _currentData.current != newData.current ||
        _currentData.motorStatus != newData.motorStatus ||
        _currentData.currentSession != newData.currentSession ||
        _currentData.estimatedExtraction != newData.estimatedExtraction ||
        _currentData.qualityStatus != newData.qualityStatus ||
        _currentData.lastUpdated != newData.lastUpdated ||
        _currentData.predictedDepth7Days != newData.predictedDepth7Days ||
        _currentData.predictedDepth14Days != newData.predictedDepth14Days ||
        _currentData.predictedDepth30Days != newData.predictedDepth30Days ||
        _currentData.trend30Days != newData.trend30Days ||
        _currentData.waterStressLevel != newData.waterStressLevel ||
        _currentData.weatherTemp != newData.weatherTemp ||
        _currentData.weatherCondition != newData.weatherCondition ||
        _currentData.rainAlert != newData.rainAlert;
  }

  @override
  void dispose() {
    _autoRefreshTimer.cancel();
    super.dispose();
  }

  Color _getWaterStressColor(String stressLevel) {
    switch (stressLevel.toLowerCase()) {
      case 'high':
        return AppColors.criticalRed;
      case 'moderate':
        return AppColors.warningOrange;
      case 'low':
      default:
        return AppColors.fieldGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Fixed Header with Animated Gradient
          AnimatedGradientBackground(
            colors: [
              AppColors.deepAquiferBlue,
              AppColors.tealStart,
              AppColors.tealEnd,
              AppColors.deepAquiferBlue,
            ],
            duration: const Duration(seconds: 8),
            showDebugIndicator: false,
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
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jal Dharan',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Groundwater Monitoring',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current Data Content (No tabs)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last updated chip
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.6,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.lightGrey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: AppColors.deepAquiferBlue,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _currentData.formattedTime,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepAquiferBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Weather Widget
                  if (_currentData.weatherTemp != null)
                    _buildWeatherCard(),
                  const SizedBox(height: 20),

                  // Current Data Card
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth,
                    ),
                    child: CurrentDataCard(
                      currentDepth: _currentData.currentDepth,
                      totalDepth: _currentData.totalDepth,
                      remainingPercentage: _currentData.remainingPercentage,
                      flowRate: _currentData.flowRate,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Water Quality & Parameters',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGrey,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quality Score
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth,
                    ),
                    child: QualityScoreCard(
                      qualityScore: _currentData.qualityScore,
                      qualityStatus: _currentData.qualityStatus,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Parameter Cards Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.maxWidth - 12) / 2;
                      return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: [
                          _buildModernParameterCard(
                            title: 'TDS Level',
                            value: _currentData.tdsLevel,
                            unit: 'ppm',
                            status: _currentData.tdsStatus,
                            icon: Icons.water_drop_rounded,
                            iconColor: const Color(0xFF20B2AA),
                            maxWidth: cardWidth,
                          ),
                          _buildModernParameterCard(
                            title: 'pH Level',
                            value: _currentData.phLevel,
                            unit: 'pH',
                            status: _currentData.phStatus,
                            icon: Icons.science_rounded,
                            iconColor: const Color(0xFF9C27B0),
                            maxWidth: cardWidth,
                          ),
                          _buildModernParameterCard(
                            title: 'Pump Status',
                            value: _currentData.motorStatus == 'Normal' ? 1 : (_currentData.motorStatus == 'Off' ? 0 : 2),
                            unit: _currentData.motorStatus,
                            status: _currentData.motorStatus,
                            icon: Icons.power_settings_new_rounded,
                            iconColor: _currentData.motorStatus == 'Normal'
                                ? const Color(0xFF4CAF50)
                                : (_currentData.motorStatus == 'Off'
                                ? AppColors.mediumGrey
                                : AppColors.warningOrange),
                            maxWidth: cardWidth,
                          ),
                          _buildModernParameterCard(
                            title: 'Power (kW)',
                            value: _currentData.powerKw,
                            unit: 'kW',
                            status: '${(_currentData.powerKw * 1000 / 230).toStringAsFixed(1)}A',
                            icon: Icons.flash_on_rounded,
                            iconColor: const Color(0xFFFFC107),
                            maxWidth: cardWidth,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Warning Card
                  _buildModernWarningCard(),
                  const SizedBox(height: 20),

                  // Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Extraction & Visualization',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGrey,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Extraction Card
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.deepAquiferBlue.withOpacity(0.05),
                          AppColors.tealStart.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.lightGrey,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.deepAquiferBlue, AppColors.tealStart],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Extraction Session',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildExtractionStat(
                                      label: 'Current Session',
                                      value: '${_currentData.currentSession.toStringAsFixed(0)} m³',
                                    ),
                                    _buildExtractionStat(
                                      label: 'Estimated Extraction',
                                      value: '${_currentData.estimatedExtraction.toStringAsFixed(0)} m³',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visualization Card (Rainwater Harvesting with Green Background)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth,
                    ),
                    child: _buildModernVisualizationCard(),
                  ),
                  const SizedBox(height: 20),

                  // Knowledge Hub Card
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/knowledge_hub');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.deepAquiferBlue,
                                    AppColors.tealStart,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.library_books_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Knowledge Hub',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Learn from expert water conservation guides',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mediumGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.mediumGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/jal_shayak');
        },
        backgroundColor: AppColors.deepAquiferBlue,
        elevation: 8,
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildModernParameterCard({
    required String title,
    required double value,
    required String unit,
    required String status,
    required IconData icon,
    required Color iconColor,
    required double maxWidth,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.mediumGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Flexible(
                  child: Text(
                    value.toStringAsFixed(value == value.toInt() ? 0 : 1),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: status.contains('Good') || status.contains('+')
                    ? AppColors.fieldGreen.withOpacity(0.1)
                    : AppColors.warningOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: status.contains('Good') || status.contains('+')
                      ? AppColors.fieldGreen
                      : AppColors.warningOrange,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernWarningCard() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warningOrange.withOpacity(0.1),
            AppColors.warningOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warningOrange.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warningOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Low Water Level Alert',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No rain expected in the next 2 days.\nConsider reducing water usage.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mediumGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractionStat({required String label, required String value}) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.deepAquiferBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    final temp = _currentData.weatherTemp ?? 25.0;
    final condition = _currentData.weatherCondition ?? 'Clear';
    final rainAlert = _currentData.rainAlert ?? '';
    final hasRain = rainAlert.toLowerCase().contains('rain expected');
    final iconCode = _currentData.weatherIcon ?? '01d';

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deepAquiferBlue.withOpacity(0.08),
            AppColors.tealStart.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightGrey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        hasRain
                            ? AppColors.warningOrange.withOpacity(0.2)
                            : AppColors.deepAquiferBlue.withOpacity(0.2),
                        hasRain
                            ? AppColors.warningOrange.withOpacity(0.1)
                            : AppColors.tealStart.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getWeatherEmoji(iconCode),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${temp.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepAquiferBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasRain)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warningOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_queue_rounded,
                          size: 16,
                          color: AppColors.warningOrange,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Rain Alert',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warningOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (rainAlert.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasRain
                        ? AppColors.warningOrange.withOpacity(0.08)
                        : AppColors.fieldGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasRain
                          ? AppColors.warningOrange.withOpacity(0.2)
                          : AppColors.fieldGreen.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasRain ? Icons.info_rounded : Icons.check_circle_rounded,
                        size: 18,
                        color: hasRain ? AppColors.warningOrange : AppColors.fieldGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rainAlert,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: hasRain
                                ? AppColors.warningOrange
                                : AppColors.fieldGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getWeatherEmoji(String iconCode) {
    final code = iconCode.replaceAll(RegExp(r'\D'), '');
    switch (code) {
      case '01':
        return '☀️';
      case '02':
        return '⛅';
      case '03':
        return '☁️';
      case '04':
        return '☁️';
      case '09':
        return '🌧️';
      case '10':
        return '🌦️';
      case '11':
        return '⛈️';
      case '13':
        return '❄️';
      case '50':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  Widget _buildModernVisualizationCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RainwaterHarvestingScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.fieldGreen,
              AppColors.fieldGreen.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.fieldGreen.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rainwater Harvesting',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Design & Recommendations',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Get Structure Recommendations',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}