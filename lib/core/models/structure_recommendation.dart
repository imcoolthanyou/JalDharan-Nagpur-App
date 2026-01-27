class StructureRecommendation {
  final String title;
  final String description;
  final String type; // 'tank', 'pit', 'trenches', 'ponds'
  final double capacity;
  final String costRange;
  final String duration;
  final List<String> benefits;
  final String imageUrl;
  final int suitabilityScore;

  StructureRecommendation({
    required this.title,
    required this.description,
    required this.type,
    required this.capacity,
    required this.costRange,
    required this.duration,
    required this.benefits,
    required this.imageUrl,
    required this.suitabilityScore,
  });

  static List<StructureRecommendation> getRecommendations({
    required String source,
    required String soilType,
    required double catchmentArea,
  }) {
    List<StructureRecommendation> recommendations = [];

    // For Roof + Sandy soil
    if (source == 'Roof' && soilType == 'Sandy') {
      recommendations = [
        StructureRecommendation(
          title: 'Recharge Pit',
          description:
              'This structure is ideal for your farm as it occupies minimal space and efficiently recharges groundwater in sandy soil conditions.',
          type: 'pit',
          capacity: (catchmentArea * 0.65).roundToDouble(),
          costRange: '₹5,000 - ₹8,000',
          duration: '3-4 days',
          benefits: [
            'Enhances groundwater',
            'Cost-effective',
            'Easy maintenance',
            'Quick water percolation',
          ],
          imageUrl: 'assets/recharge_pit.png',
          suitabilityScore: 95,
        ),
        StructureRecommendation(
          title: 'Underground Tank',
          description:
              'Ideal for roof harvesting with sandy soil. Stores water efficiently with minimal evaporation.',
          type: 'tank',
          capacity: (catchmentArea * 0.85).roundToDouble(),
          costRange: '₹15,000 - ₹25,000',
          duration: '5-7 days',
          benefits: [
            'Minimal evaporation',
            'Space-efficient',
            'Long lifespan (20+ years)',
            'Low maintenance',
          ],
          imageUrl: 'assets/tank.png',
          suitabilityScore: 85,
        ),
      ];
    }
    // For Roof + Clay soil
    else if (source == 'Roof' && soilType == 'Clay') {
      recommendations = [
        StructureRecommendation(
          title: 'Elevated Tank',
          description:
              'Best for clay soil as water percolation is slow. Elevated design prevents stagnation.',
          type: 'tank',
          capacity: (catchmentArea * 0.90).roundToDouble(),
          costRange: '₹20,000 - ₹30,000',
          duration: '6-8 days',
          benefits: [
            'Perfect for clay soil',
            'High storage capacity',
            'Easy water distribution',
            'Gravity-fed system',
          ],
          imageUrl: 'assets/elevated_tank.png',
          suitabilityScore: 92,
        ),
        StructureRecommendation(
          title: 'Surface Tank',
          description:
              'Suitable for clay-based soil. Easy to construct and maintain with good water retention.',
          type: 'tank',
          capacity: (catchmentArea * 0.80).roundToDouble(),
          costRange: '₹12,000 - ₹18,000',
          duration: '4-5 days',
          benefits: [
            'Simple construction',
            'Good water retention',
            'Visible water level',
            'Easy maintenance access',
          ],
          imageUrl: 'assets/surface_tank.png',
          suitabilityScore: 88,
        ),
      ];
    }
    // For Roof + Loamy soil
    else if (source == 'Roof' && soilType == 'Loamy') {
      recommendations = [
        StructureRecommendation(
          title: 'Combination System',
          description:
              'Perfect for loamy soil. Combines both storage and recharge for optimal utilization.',
          type: 'tank',
          capacity: (catchmentArea * 0.88).roundToDouble(),
          costRange: '₹25,000 - ₹35,000',
          duration: '7-10 days',
          benefits: [
            'Best of both worlds',
            'Optimized efficiency',
            'Balanced recharge',
            'Flexible design',
          ],
          imageUrl: 'assets/combination.png',
          suitabilityScore: 96,
        ),
        StructureRecommendation(
          title: 'Underground Tank + Recharge Trench',
          description: 'Hybrid system for loamy soil maximizing water utilization.',
          type: 'trenches',
          capacity: (catchmentArea * 0.75).roundToDouble(),
          costRange: '₹18,000 - ₹26,000',
          duration: '5-7 days',
          benefits: [
            'Dual functionality',
            'High recharge rate',
            'Water security',
            'Long-term benefit',
          ],
          imageUrl: 'assets/hybrid.png',
          suitabilityScore: 90,
        ),
      ];
    }
    // For Land + Sandy soil
    else if (source == 'Land' && soilType == 'Sandy') {
      recommendations = [
        StructureRecommendation(
          title: 'Recharge Trenches',
          description:
              'Excellent for land with sandy soil. Water percolates quickly to groundwater.',
          type: 'trenches',
          capacity: (catchmentArea * 0.70).roundToDouble(),
          costRange: '₹10,000 - ₹15,000',
          duration: '4-5 days',
          benefits: [
            'Fast recharge',
            'Large coverage area',
            'Cost-effective',
            'Minimal maintenance',
          ],
          imageUrl: 'assets/trenches.png',
          suitabilityScore: 94,
        ),
        StructureRecommendation(
          title: 'Check Dams',
          description:
              'Ideal for sloped land with sandy soil to slow down runoff.',
          type: 'ponds',
          capacity: (catchmentArea * 0.60).roundToDouble(),
          costRange: '₹8,000 - ₹14,000',
          duration: '3-5 days',
          benefits: [
            'Slows water flow',
            'Natural recharge',
            'Wildlife habitat',
            'Scenic addition',
          ],
          imageUrl: 'assets/checkdams.png',
          suitabilityScore: 82,
        ),
      ];
    }
    // For Land + Clay soil
    else if (source == 'Land' && soilType == 'Clay') {
      recommendations = [
        StructureRecommendation(
          title: 'Retention Ponds',
          description:
              'Perfect for clay soil where water doesn\'t percolate quickly. Acts as natural storage.',
          type: 'ponds',
          capacity: (catchmentArea * 0.95).roundToDouble(),
          costRange: '₹15,000 - ₹22,000',
          duration: '6-8 days',
          benefits: [
            'Excellent retention',
            'Large storage',
            'Natural filtration',
            'Ecosystem support',
          ],
          imageUrl: 'assets/ponds.png',
          suitabilityScore: 93,
        ),
        StructureRecommendation(
          title: 'Contour Trenches',
          description:
              'Suitable for clay soil with contoured land. Stops erosion and improves recharge.',
          type: 'trenches',
          capacity: (catchmentArea * 0.65).roundToDouble(),
          costRange: '₹12,000 - ₹18,000',
          duration: '4-6 days',
          benefits: [
            'Prevents erosion',
            'Slows runoff',
            'Vegetation support',
            'Landscape integration',
          ],
          imageUrl: 'assets/contour_trenches.png',
          suitabilityScore: 87,
        ),
      ];
    }
    // For Land + Loamy soil
    else if (source == 'Land' && soilType == 'Loamy') {
      recommendations = [
        StructureRecommendation(
          title: 'Multi-purpose Pond',
          description:
              'Ideal for loamy soil. Combines storage, recharge, and agricultural benefits.',
          type: 'ponds',
          capacity: (catchmentArea * 0.92).roundToDouble(),
          costRange: '₹20,000 - ₹30,000',
          duration: '7-9 days',
          benefits: [
            'Multiple uses',
            'Balanced hydrology',
            'Sustainable design',
            'Community benefit',
          ],
          imageUrl: 'assets/multipond.png',
          suitabilityScore: 95,
        ),
        StructureRecommendation(
          title: 'Infiltration Basins',
          description:
              'Great for loamy soil. Allows gradual infiltration with good recharge.',
          type: 'ponds',
          capacity: (catchmentArea * 0.78).roundToDouble(),
          costRange: '₹14,000 - ₹20,000',
          duration: '5-7 days',
          benefits: [
            'Steady recharge',
            'Flood prevention',
            'Land restoration',
            'Natural filtration',
          ],
          imageUrl: 'assets/basins.png',
          suitabilityScore: 89,
        ),
      ];
    }

    return recommendations;
  }
}

extension on double {
  double roundToDouble() {
    return (this * 100).round() / 100;
  }
}
