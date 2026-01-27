// Updated HeaderWithWave - more modern and integrated with app bar
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class HeaderWithWave extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;

  const HeaderWithWave({
    Key? key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.deepAquiferBlue,
            AppColors.tealStart,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepAquiferBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBackButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withOpacity(0.2),
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
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
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
            ],
          ),
        ],
      ),
    );
  }
}

// Updated CurrentDataCard with better visual hierarchy
class CurrentDataCard extends StatelessWidget {
  final double currentDepth;
  final double totalDepth;
  final String remainingPercentage;
  final double flowRate;

  const CurrentDataCard({
    Key? key,
    required this.currentDepth,
    required this.totalDepth,
    required this.remainingPercentage,
    required this.flowRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (currentDepth / totalDepth * 100).clamp(0, 100).toInt();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.lightGrey.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Water depth visual indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 160,
                  child: CustomPaint(
                    size: const Size(160, 160),
                    painter: _WaterDepthPainter(
                      percentage: percentage.toDouble(),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${currentDepth.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepAquiferBlue,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warningOrange.withOpacity(0.1),
                    AppColors.warningOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppColors.warningOrange.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.warningOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$remainingPercentage Remaining',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warningOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    label: 'TOTAL DEPTH',
                    value: '${totalDepth.toStringAsFixed(0)} Ft',
                    icon: Icons.waves_rounded,
                    color: AppColors.deepAquiferBlue,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.lightGrey,
                  ),
                  _buildStatItem(
                    label: 'FLOW RATE',
                    value: '${flowRate.toStringAsFixed(1)} L/min',
                    icon: Icons.arrow_upward_rounded,
                    color: AppColors.fieldGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _WaterDepthPainter extends CustomPainter {
  final double percentage;

  _WaterDepthPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    final backgroundPaint = Paint()
      ..color = AppColors.lightGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground (filled) circle
    final sweepAngle = (percentage / 100) * 2 * 3.14159;
    final foregroundPaint = Paint()
      ..color = AppColors.deepAquiferBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Updated QualityScoreCard with better design
class QualityScoreCard extends StatelessWidget {
  final double qualityScore;
  final String qualityStatus;

  const QualityScoreCard({
    Key? key,
    required this.qualityScore,
    required this.qualityStatus,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'EXCELLENT':
        return const Color(0xFF20B2AA);
      case 'GOOD':
        return const Color(0xFF4CAF50);
      case 'FAIR':
        return const Color(0xFFFFC107);
      case 'POOR':
        return AppColors.criticalRed;
      default:
        return AppColors.mediumGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(qualityStatus);

    return Container(
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
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.2),
                    statusColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                qualityScore >= 80
                    ? Icons.emoji_events_rounded
                    : qualityScore >= 60
                    ? Icons.thumb_up_rounded
                    : Icons.warning_rounded,
                color: statusColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Quality',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${qualityScore.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        '/100',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                qualityStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}