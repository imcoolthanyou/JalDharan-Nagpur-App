///
/// Socket.IO Connection Status Widget
///
/// Display current Socket.IO connection status in the UI
/// Can be used in AppBar or header for debugging
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';

class SocketStatusIndicator extends StatelessWidget {
  final bool showLabel;

  const SocketStatusIndicator({
    Key? key,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, child) {
        final isConnected = socketService.isConnected;
        final isConnecting = socketService.isConnecting;

        Color statusColor = Colors.grey;
        String statusText = 'Offline';
        IconData statusIcon = Icons.cloud_off;

        if (isConnected) {
          statusColor = Colors.green;
          statusText = 'Live';
          statusIcon = Icons.cloud_done;
        } else if (isConnecting) {
          statusColor = Colors.orange;
          statusText = 'Connecting...';
          statusIcon = Icons.cloud_queue;
        }

        if (!showLabel) {
          return Tooltip(
            message: statusText,
            child: Icon(statusIcon, color: statusColor, size: 20),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, color: statusColor, size: 16),
            const SizedBox(width: 4),
            Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

///
/// Reconnect Button
///
/// Manual reconnect button for debugging socket issues
///
class SocketReconnectButton extends StatelessWidget {
  const SocketReconnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, child) {
        return IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Reconnect Socket',
          onPressed: socketService.isConnected
              ? null
              : () => socketService.reconnect(),
        );
      },
    );
  }
}

///
/// Latest Data Display Widget
///
/// Show the latest sensor data received from Socket.IO
///
class LatestDataDisplay extends StatelessWidget {
  const LatestDataDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, child) {
        if (socketService.latestSensorData == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Waiting for sensor data...'),
          );
        }

        final data = socketService.latestSensorData!;
        final sensorData = data['sensor_data'] ?? {};

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Latest Sensor Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Depth: ${sensorData['water_depth_m']} m'),
              Text('Flow: ${sensorData['flow_rate_L_min']} L/min'),
              Text('pH: ${sensorData['ph']}'),
              Text('TDS: ${sensorData['tds_value']} ppm'),
            ],
          ),
        );
      },
    );
  }
}

