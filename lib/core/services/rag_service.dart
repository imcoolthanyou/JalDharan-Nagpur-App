import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class RAGResponse {
  final String reply;
  final String timestamp;

  RAGResponse({
    required this.reply,
    required this.timestamp,
  });

  factory RAGResponse.fromJson(Map<String, dynamic> json) {
    return RAGResponse(
      reply: json['reply'] ?? 'Unable to process your question. Please try again.',
      timestamp: json['timestamp'] ?? DateTime.now().toString(),
    );
  }
}

class RAGService {
  /// Send a message to the RAG API and get a response

  static Future<RAGResponse> sendMessage(String message) async {
    final String _endpoint=ApiConfig.aiRagEndpoint;
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.aiRagEndpoint),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'message': message,
            }),
          )
          .timeout(
            ApiConfig.requestTimeout,
            onTimeout: () {
              throw Exception(
                'Request timeout: AI is processing your question...',
              );
            },
          );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('✅ RAG Response: $json');
        return RAGResponse.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request: ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: Unable to process your question');
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception(
        'Cannot connect to AI service\n'
        'Endpoint: $_endpoint\n'
        'Error: $e',
      );
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      rethrow;
    }
  }

  /// Stream messages for real-time processing (optional)
  static Future<RAGResponse> sendMessageWithContext({
    required String message,
    required Map<String, dynamic> groundwaterData,
  }) async {
    try {
      // Prepare context from groundwater data
      final context = {
        'current_depth': groundwaterData['currentDepth'],
        'water_quality': groundwaterData['qualityStatus'],
        'ph': groundwaterData['phLevel'],
        'tds': groundwaterData['tdsLevel'],
        'flow_rate': groundwaterData['flowRate'],
        'motor_status': groundwaterData['motorStatus'],
        'weather_condition': groundwaterData['weatherCondition'],
        'rain_alert': groundwaterData['rainAlert'],
      };

      final response = await http
          .post(
            Uri.parse(ApiConfig.aiRagEndpoint),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'message': message,
              'context': context,
            }),
          )
          .timeout(
            ApiConfig.requestTimeout,
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('✅ RAG Response with context: $json');
        return RAGResponse.fromJson(json);
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
