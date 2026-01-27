import 'package:flutter/material.dart';
import '../../../core/models/rainwater_harvesting_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/rainwater_harvesting_widgets.dart';
import 'structure_recommendation_screen.dart';


class RainwaterHarvestingScreen extends StatefulWidget {
  const RainwaterHarvestingScreen({Key? key}) : super(key: key);

  @override
  State<RainwaterHarvestingScreen> createState() =>
      _RainwaterHarvestingScreenState();
}

class _RainwaterHarvestingScreenState extends State<RainwaterHarvestingScreen> {
  late RainwaterHarvestingData _data;
  late List<SoilType> _soilTypes;

  // Additional parameters for prediction
  String _selectedAquiferType = 'Hard Rock (Basalt)';
  double _depthM = 10.0;
  double _openSpaceSqm = 4.0;
  String _existingStructure = 'None';

  @override
  void initState() {
    super.initState();
    _data = RainwaterHarvestingData.mockData();
    _soilTypes = SoilType.getAllSoilTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: RWHAppBar(
        title: 'Rainwater Harvesting',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Source Section
              SectionTitle(
                title: 'Source',
                subtitle: 'Where will you collect water from?',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SourceToggleButton(
                    label: 'Roof',
                    icon: Icons.home,
                    isSelected: _data.source == 'Roof',
                    onPressed: () {
                      setState(() {
                        _data = RainwaterHarvestingData(
                          source: 'Roof',
                          soilType: _data.soilType,
                          catchmentArea: _data.catchmentArea,
                          selectedSoilImage: _data.selectedSoilImage,
                        );
                      });
                    },
                    type: 'roof',
                  ),
                  const SizedBox(width: 12),
                  SourceToggleButton(
                    label: 'Land',
                    icon: Icons.terrain,
                    isSelected: _data.source == 'Land',
                    onPressed: () {
                      setState(() {
                        _data = RainwaterHarvestingData(
                          source: 'Land',
                          soilType: _data.soilType,
                          catchmentArea: _data.catchmentArea,
                          selectedSoilImage: _data.selectedSoilImage,
                        );
                      });
                    },
                    type: 'land',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Soil Type Section
              SectionTitle(
                title: 'Soil Type',
                subtitle: 'What is the texture of your soil?',
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
                children: List.generate(
                  _soilTypes.length,
                  (index) => SoilTypeCard(
                    name: _soilTypes[index].name,
                    imageUrl: _soilTypes[index].imageUrl,
                    isSelected: _data.soilType == _soilTypes[index].name,
                    onTap: () {
                      setState(() {
                        _data = RainwaterHarvestingData(
                          source: _data.source,
                          soilType: _soilTypes[index].name,
                          catchmentArea: _data.catchmentArea,
                          selectedSoilImage: _soilTypes[index].imageUrl,
                        );
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Catchment Area Section
              CatchmentAreaInput(
                value: _data.catchmentArea,
                onChanged: (newValue) {
                  setState(() {
                    _data = RainwaterHarvestingData(
                      source: _data.source,
                      soilType: _data.soilType,
                      catchmentArea: newValue,
                      selectedSoilImage: _data.selectedSoilImage,
                    );
                  });
                },
              ),
              const SizedBox(height: 32),

              // Aquifer Type Section
              SectionTitle(
                title: 'Aquifer Type',
                subtitle: 'What type of aquifer is present?',
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: DropdownButton<String>(
                  value: _selectedAquiferType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  items: [
                    'Hard Rock (Basalt)',
                    'Hard Rock (Granite)',
                    'Sedimentary',
                    'Alluvial',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedAquiferType = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Water Depth Section
              SectionTitle(
                title: 'Water Depth',
                subtitle: 'How deep is the groundwater level?',
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_depthM.toStringAsFixed(1)} m',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepAquiferBlue,
                              ),
                            ),
                            Text(
                              'Below ground level',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Slider(
                          value: _depthM,
                          min: 1.0,
                          max: 50.0,
                          divisions: 49,
                          activeColor: AppColors.deepAquiferBlue,
                          inactiveColor: AppColors.mediumGrey.withOpacity(0.3),
                          onChanged: (value) {
                            setState(() {
                              _depthM = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Open Space Section
              SectionTitle(
                title: 'Available Open Space',
                subtitle: 'How much space is available for structure?',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _openSpaceSqm = double.tryParse(value) ?? 4.0;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter area in sq.m (e.g., 4.0)',
                    hintStyle: TextStyle(
                      color: AppColors.mediumGrey,
                    ),
                    border: InputBorder.none,
                    suffix: Text(
                      'sq.m',
                      style: TextStyle(
                        color: AppColors.mediumGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Existing Structure Section
              SectionTitle(
                title: 'Existing Structure',
                subtitle: 'Do you have any existing water structure?',
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: DropdownButton<String>(
                  value: _existingStructure,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  items: [
                    'None',
                    'Well',
                    'Boring',
                    'Pond',
                    'Tank',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _existingStructure = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Info Card
              InfoCard(
                title: 'Why is this important?',
                description:
                    'Providing accurate details helps us recommend the most cost-effective and efficient structure for your farm.',
              ),
              const SizedBox(height: 32),

              // Recommend Button
              PrimaryButton(
                label: 'Recommend Structure',
                icon: Icons.water_drop,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StructureRecommendationScreen(
                        source: _data.source,
                        soilType: _data.soilType,
                        catchmentArea: _data.catchmentArea,
                        aquiferType: _selectedAquiferType,
                        depthM: _depthM,
                        openSpaceSqm: _openSpaceSqm,
                        existingStructure: _existingStructure,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
