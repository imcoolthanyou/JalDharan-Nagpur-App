import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SoilTextureGenerator {
  static Widget generateSandyTexture() {
    return CustomPaint(
      painter: SandyTexturePainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }

  static Widget generateClayTexture() {
    return CustomPaint(
      painter: ClayTexturePainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }

  static Widget generateLoamyTexture() {
    return CustomPaint(
      painter: LoamyTexturePainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }
}

class SandyTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFFC09464)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw diagonal lines pattern for sandy texture
    for (double i = -size.height; i < size.width + size.height; i += 6) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        strokePaint,
      );
    }

    // Add some circles for sandy grain appearance
    for (double x = 0; x < size.width; x += 25) {
      for (double y = 0; y < size.height; y += 25) {
        canvas.drawCircle(Offset(x + 10, y + 10), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SandyTexturePainter oldDelegate) => false;
}

class ClayTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4E37)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF3D2E17)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw parallel diagonal lines for clay texture
    for (double i = -size.height; i < size.width + size.height; i += 5) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        strokePaint,
      );
    }

    // Add secondary lines for more texture
    for (double i = -size.height; i < size.width + size.height; i += 5) {
      canvas.drawLine(
        Offset(i + 2.5, 0),
        Offset(i + size.height + 2.5, size.height),
        Paint()
          ..color = const Color(0xFF6D5E47)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(ClayTexturePainter oldDelegate) => false;
}

class LoamyTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3D3D3D)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF1D1D1D)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw a more complex pattern for loamy soil
    for (double i = -size.height; i < size.width + size.height; i += 4) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        strokePaint,
      );
    }

    // Add perpendicular lines for more texture
    for (double i = 0; i < size.height; i += 6) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        Paint()
          ..color = const Color(0xFF4D4D4D)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke,
      );
    }

    // Add small dots/particles
    for (double x = 0; x < size.width; x += 15) {
      for (double y = 0; y < size.height; y += 15) {
        canvas.drawCircle(Offset(x + 7, y + 7), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(LoamyTexturePainter oldDelegate) => false;
}
