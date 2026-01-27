import 'package:flutter/material.dart';
import 'dart:math';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 2.5;

    path.lineTo(0, 0);
    path.lineTo(0, waveHeight);

    // Create smooth wave using quadratic bezier curves
    double x = 0;
    bool isUp = true;

    while (x < size.width) {
      final nextX = x + waveLength / 2;
      final controlY = isUp ? 0.0 : waveHeight * 2;
      final endY = waveHeight;
      final endX = nextX > size.width ? size.width : nextX;

      path.quadraticBezierTo(
        x + waveLength / 4,
        controlY,
        endX,
        endY,
      );

      x = nextX;
      isUp = !isUp;
    }

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = 35.0;
    final waveLength = size.width / 2;

    // Start from bottom-left
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - waveHeight);

    // Create smooth wave using cubic bezier curves for more elegance
    double x = 0;
    final segments = 4;
    final segmentWidth = size.width / segments;

    for (int i = 0; i < segments; i++) {
      final startX = i * segmentWidth;
      final endX = (i + 1) * segmentWidth;
      final midX = startX + segmentWidth / 2;

      final startY = size.height - waveHeight;
      final peakY = i % 2 == 0
          ? size.height - waveHeight - 25
          : size.height - waveHeight + 25;
      final endY = size.height - waveHeight;

      path.cubicTo(
        startX + segmentWidth * 0.3,
        peakY,
        startX + segmentWidth * 0.7,
        peakY,
        endX,
        endY,
      );
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottomWaveClipper oldClipper) => false;
}

// Alternative: More dramatic wave
class BottomWaveClipperAlt extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);

    // Create flowing wave
    final p1 = size.height - 50;
    final p2 = size.height - 20;

    path.lineTo(0, p1);

    path.cubicTo(
      size.width * 0.25, p1 - 30,
      size.width * 0.25, p2 + 30,
      size.width * 0.5, p2,
    );

    path.cubicTo(
      size.width * 0.75, p2 - 30,
      size.width * 0.75, p1 + 30,
      size.width, p1,
    );

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottomWaveClipperAlt oldClipper) => false;
}