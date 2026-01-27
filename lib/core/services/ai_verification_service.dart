import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AIVerificationResult {
  final bool isRealImage;
  final bool taskCompleted;
  final double confidenceScore;
  final String analysis;
  final String status;

  AIVerificationResult({
    required this.isRealImage,
    required this.taskCompleted,
    required this.confidenceScore,
    required this.analysis,
    required this.status,
  });

  factory AIVerificationResult.fromJson(Map<String, dynamic> json) {
    return AIVerificationResult(
      isRealImage: json['is_real_image'] ?? false,
      taskCompleted: json['task_completed'] ?? false,
      confidenceScore: (json['confidence_score'] ?? 0.0).toDouble(),
      analysis: json['analysis'] ?? '',
      status: json['status'] ?? 'unknown',
    );
  }

  bool get isValid => isRealImage && taskCompleted;
}

class AIVerificationService {
  static final AIVerificationService _instance = AIVerificationService._internal();

  factory AIVerificationService() {
    return _instance;
  }

  AIVerificationService._internal();

 final String _baseUrl=ApiConfig.aiVerificationEndpoint;
  Future<AIVerificationResult> verifyTaskImage({
    required File imageFile,
    required String taskDescription,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.aiVerificationEndpoint);

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      // Add task description
      request.fields['task'] = taskDescription;

      // Send request with timeout
      final response = await request.send().timeout(
        const Duration(seconds: 45), // Increased timeout for AI processing
        onTimeout: () {
          throw Exception('Request timeout: AI is authenticating image...');
        },
      );

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);
        return AIVerificationResult.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request: Check image format and task description');
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Server error: ${responseBody}');
      } else {
        throw Exception(
          'Failed to verify image: ${response.statusCode}',
        );
      }
    } on SocketException catch (e) {
      throw Exception(
          'Connection Error: Cannot reach server at $_baseUrl\n'
              'Make sure:\n'
              '1. Backend server is running\n'
              '2. Server IP address is correct\n'
              '3. Device is on same network\n'
              'Error: $e'
      );
    } on TimeoutException catch (e) {
      throw Exception(
          'Request timed out.\n'
              'Server may be slow or unreachable at $_baseUrl\n'
              'Error: $e'
      );
    } on FormatException catch (e) {
      throw Exception('Invalid response format from server: $e');
    } catch (e) {
      throw Exception('Unexpected error during verification: $e');
    }
  }

  /// Check if the AI verification server is reachable
  Future<bool> isServerReachable({String? baseUrl}) async {
    try {
      // Trying the Health endpoint
      final url = Uri.parse('${baseUrl ?? _baseUrl}/health');
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}