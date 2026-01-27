import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Widget child;
  final Duration duration;
  final double opacity;
  final bool showDebugIndicator;

  const AnimatedGradientBackground({
    Key? key,
    required this.colors,
    required this.child,
    this.duration = const Duration(seconds: 6),
    this.opacity = 1.0,
    this.showDebugIndicator = false,
  }) : super(key: key);

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<AlignmentGeometry> _alignments;
  late List<AlignmentGeometry> _nextAlignments;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.repeat();

    // Define smooth gradient direction transitions
    _alignments = [
      Alignment.topLeft,
      Alignment.bottomRight,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.topLeft,
    ];

    _nextAlignments = [
      Alignment.bottomRight,
      Alignment.topLeft,
      Alignment.bottomLeft,
      Alignment.topRight,
      Alignment.bottomRight,
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        // Determine current segment (0-3, each taking 0.25 of the animation)
        final segment = (progress * 4).floor();
        final segmentProgress = (progress * 4) - segment;

        // Get current and next alignments with bounds checking
        final currentBegin = _alignments[segment % _alignments.length];
        final currentEnd = _nextAlignments[segment % _nextAlignments.length];
        final nextBegin = _alignments[(segment + 1) % _alignments.length];
        final nextEnd = _nextAlignments[(segment + 1) % _nextAlignments.length];

        // Interpolate between current and next with easing
        final easeProgress = _easeInOutCubic(segmentProgress);
        final begin = AlignmentGeometry.lerp(currentBegin, nextBegin, easeProgress) ??
            Alignment.topLeft;
        final end = AlignmentGeometry.lerp(currentEnd, nextEnd, easeProgress) ??
            Alignment.bottomRight;

        // Generate color stops based on number of colors
        final colorStops = List<double>.generate(
          widget.colors.length,
              (index) => index / (widget.colors.length - 1),
        );

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.colors,
                  begin: begin,
                  end: end,
                  stops: colorStops,
                ),
              ),
              child: Opacity(
                opacity: widget.opacity,
                child: child,
              ),
            ),
            // Debug indicator - shows animation progress (only visible if enabled)
            if (widget.showDebugIndicator)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * progress,
                      height: 3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Easing function for smoother animation
  double _easeInOutCubic(double t) {
    return t < 0.5
        ? 4 * t * t * t
        : 1 - pow(-2 * t + 2, 3) / 2;
  }
}