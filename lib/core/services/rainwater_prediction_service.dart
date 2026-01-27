import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/structure_prediction.dart';
import '../config/api_config.dart';

class RainwaterPredictionService {
  static Future<StructurePrediction> predictStructure({
    required double roofAreaSqm,
    required String soilType,
    required String aquiferType,
    required double depthM,
    required double openSpaceSqm,
    required String existingStructure,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.predictStructureEndpoint);

      final body = {
        'roof_area_sqm': roofAreaSqm,
        'soil_type': soilType,
        'aquifer_type': aquiferType,
        'depth_m': depthM,
        'open_space_sqm': openSpaceSqm,
        'existing_structure': existingStructure,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(
        ApiConfig.requestTimeout,
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return StructurePrediction.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to get prediction: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
