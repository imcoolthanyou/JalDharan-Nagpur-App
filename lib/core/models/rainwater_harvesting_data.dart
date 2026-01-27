class RainwaterHarvestingData {
  final String source;
  final String soilType;
  final double catchmentArea;
  final String? selectedSoilImage;

  RainwaterHarvestingData({
    required this.source,
    required this.soilType,
    required this.catchmentArea,
    this.selectedSoilImage,
  });

  // Mock initial data
  static RainwaterHarvestingData mockData() {
    return RainwaterHarvestingData(
      source: 'Roof',
      soilType: 'Sandy',
      catchmentArea: 1200,
      selectedSoilImage: 'assets/soil_sandy.png',
    );
  }
}

class SoilType {
  final String name;
  final String imageUrl;

  SoilType({
    required this.name,
    required this.imageUrl,
  });

  static List<SoilType> getAllSoilTypes() {
    return [
      SoilType(name: 'Sandy', imageUrl: 'assets/soil_sandy.png'),
      SoilType(name: 'Clay', imageUrl: 'assets/soil_clay.png'),
      SoilType(name: 'Loamy', imageUrl: 'assets/soil_loamy.png'),
    ];
  }
}

class WaterSource {
  final String name;
  final String icon;

  WaterSource({
    required this.name,
    required this.icon,
  });

  static List<WaterSource> getAllSources() {
    return [
      WaterSource(name: 'Roof', icon: 'roof'),
      WaterSource(name: 'Land', icon: 'land'),
    ];
  }
}
