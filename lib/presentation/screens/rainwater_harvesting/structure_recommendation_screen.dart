import 'package:flutter/material.dart';

import '../../../core/models/structure_prediction.dart';
import '../../../core/models/structure_recommendation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/rainwater_prediction_service.dart';


class StructureRecommendationScreen extends StatefulWidget {
  final String source;
  final String soilType;
  final double catchmentArea;
  final String aquiferType;
  final double depthM;
  final double openSpaceSqm;
  final String existingStructure;

  const StructureRecommendationScreen({
    Key? key,
    required this.source,
    required this.soilType,
    required this.catchmentArea,
    required this.aquiferType,
    required this.depthM,
    required this.openSpaceSqm,
    required this.existingStructure,
  }) : super(key: key);

  @override
  State<StructureRecommendationScreen> createState() =>
      _StructureRecommendationScreenState();
}

class _StructureRecommendationScreenState
    extends State<StructureRecommendationScreen> {
  late StructureRecommendation topRecommendation;
  StructurePrediction? _prediction;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final recommendations = StructureRecommendation.getRecommendations(
      source: widget.source,
      soilType: widget.soilType,
      catchmentArea: widget.catchmentArea,
    );
    topRecommendation = recommendations.first;
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    try {
      final prediction = await RainwaterPredictionService.predictStructure(
        roofAreaSqm: widget.catchmentArea,
        soilType: widget.soilType,
        aquiferType: widget.aquiferType,
        depthM: widget.depthM,
        openSpaceSqm: widget.openSpaceSqm,
        existingStructure: widget.existingStructure,
      );

      if (mounted) {
        setState(() {
          _prediction = prediction;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 50,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.darkGrey,
              size: 24,
            ),
          ),
        ),
        title: const Text(
          'Structure Recommendation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.deepAquiferBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Analyzing your parameters...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.warningOrange,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Unable to fetch recommendation',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mediumGrey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            _fetchPrediction();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepAquiferBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Try Again',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Structure Image Section
                      Container(
                        width: double.infinity,
                        height: 280,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Stack(
                          children: [
                            // Image placeholder
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(topRecommendation.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Recommended badge
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.fieldGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Recommended',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Title and Description Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Most Suitable Option',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.mediumGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _prediction?.recommendedStructure ??
                                      topRecommendation.title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Audio explanation'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F7F6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.volume_up,
                                      color: AppColors.tealStart,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _prediction?.reason ??
                                  topRecommendation.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGrey,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Listen to Explanation Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Playing audio explanation...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.fieldGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Listen to Explanation',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Dimensions Section (from API)
                      if (_prediction != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildDimensionsCard(_prediction!.dimensions),
                        ),
                      if (_prediction != null) const SizedBox(height: 24),

                      // Cost and Savings Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFE0E0E0)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          color: AppColors.warningOrange,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'COST',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.mediumGrey,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _prediction?.estimatedCost.range ??
                                          topRecommendation.costRange,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Estimated',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.mediumGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFE0E0E0)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.water_drop,
                                          color: AppColors.tealStart,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'VOLUME',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.mediumGrey,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _prediction?.dimensions.volumeCapacity ??
                                          '${topRecommendation.capacity} L',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Capacity',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.mediumGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Design Basis Section (from API)
                      if (_prediction != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildDesignBasisCard(_prediction!),
                        ),
                      if (_prediction != null) const SizedBox(height: 24),

                      // Why was this chosen Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
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
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.fieldGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Why was this chosen?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildReasonRow('Soil Type', widget.soilType),
                              const SizedBox(height: 16),
                              _buildReasonRow('Water Source', widget.source),
                              const SizedBox(height: 16),
                              _buildReasonRow(
                                'Catchment Area',
                                '${widget.catchmentArea.toStringAsFixed(0)} Sq.ft',
                              ),
                              const SizedBox(height: 16),
                              _buildReasonRow(
                                'Aquifer Type',
                                widget.aquiferType,
                              ),
                              const SizedBox(height: 16),
                              _buildReasonRow(
                                'Water Depth',
                                '${widget.depthM.toStringAsFixed(1)} m',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Download Guide Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Downloading installation guide...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.description,
                                    color: AppColors.fieldGreen,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Download Guide',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'PDF (English) - 2.5 MB',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.mediumGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.download,
                                  color: AppColors.fieldGreen,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contact Expert Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Connecting to expert...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE4CC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.warningOrange,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Contact Expert',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Ask Questions',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.mediumGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.mediumGrey,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDimensionsCard(DimensionsData dimensions) {
    return Container(
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
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.tealStart,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.architecture,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Technical Dimensions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReasonRow('Shape', dimensions.shape),
          const SizedBox(height: 12),
          _buildReasonRow('Depth', dimensions.depth),
          const SizedBox(height: 12),
          _buildReasonRow('Diameter/Width', dimensions.diameter),
          const SizedBox(height: 12),
          _buildReasonRow('Volume Capacity', dimensions.volumeCapacity),
        ],
      ),
    );
  }

  Widget _buildDesignBasisCard(StructurePrediction prediction) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tealStart.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.tealStart,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Design Basis',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            prediction.designBasis,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.mediumGrey,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.mediumGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }
}
