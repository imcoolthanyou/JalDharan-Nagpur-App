class StructurePrediction {
  final String recommendedStructure;
  final String reason;
  final DimensionsData dimensions;
  final EstimatedCost estimatedCost;
  final String designBasis;

  StructurePrediction({
    required this.recommendedStructure,
    required this.reason,
    required this.dimensions,
    required this.estimatedCost,
    required this.designBasis,
  });

  factory StructurePrediction.fromJson(Map<String, dynamic> json) {
    return StructurePrediction(
      recommendedStructure: json['recommended_structure'] ?? '',
      reason: json['reason'] ?? '',
      dimensions: DimensionsData.fromJson(json['dimensions'] ?? {}),
      estimatedCost: EstimatedCost.fromJson(json['estimated_cost'] ?? {}),
      designBasis: json['design_basis'] ?? '',
    );
  }
}

class DimensionsData {
  final String shape;
  final String depth;
  final String diameter;
  final String volumeCapacity;

  DimensionsData({
    required this.shape,
    required this.depth,
    required this.diameter,
    required this.volumeCapacity,
  });

  factory DimensionsData.fromJson(Map<String, dynamic> json) {
    return DimensionsData(
      shape: json['Shape'] ?? 'Not specified',
      depth: json['Depth'] ?? 'Not specified',
      diameter: json['Diameter'] ?? 'Not specified',
      volumeCapacity: json['Volume Capacity'] ?? 'Not specified',
    );
  }
}

class EstimatedCost {
  final int min;
  final int max;
  final String currency;

  EstimatedCost({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory EstimatedCost.fromJson(Map<String, dynamic> json) {
    return EstimatedCost(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }

  String get range => '₹${min.toString()} - ₹${max.toString()}';
  String get average => '₹${((min + max) / 2).toStringAsFixed(0)}';
}
