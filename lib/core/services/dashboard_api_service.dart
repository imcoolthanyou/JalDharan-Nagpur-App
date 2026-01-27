import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException, TimeoutException;
import 'package:http/http.dart' as http;
import '../models/groundwater_data.dart';
import '../config/api_config.dart';

class DashboardApiService {
  // Singleton pattern
  static final DashboardApiService _instance = DashboardApiService._internal();

  factory DashboardApiService() {
    return _instance;
  }

  DashboardApiService._internal();

  /// Fetch dashboard data from the mobile endpoint
  ///
  /// Returns: GroundwaterData with current sensor readings
  /// Throws: Exception if the request fails
  Future<GroundwaterData> fetchDashboardData({
    String userId = 'test_user',
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.dashboardEndpoint}?user_id=$userId',
      );

      final response = await http.get(url).timeout(
        ApiConfig.requestTimeout,
        onTimeout: () {
          throw Exception('Request timeout: Could not reach server');
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GroundwaterData.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found (404): $url');
      } else if (response.statusCode == 500) {
        throw Exception('Server error (500): ${response.body}');
      } else {
        throw Exception(
          'Failed to load dashboard data: ${response.statusCode}\n'
          '${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw Exception('Network error: Unable to connect to server\n$e');
    } on TimeoutException catch (e) {
      throw Exception('Request timed out: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Check if the API is reachable (health check)
  Future<bool> isServerReachable() async {
    try {
      final url = Uri.parse('${ApiConfig.dashboardEndpoint}?user_id=test_user');
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
