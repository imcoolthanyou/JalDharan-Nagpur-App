import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color deepAquiferBlue = Color(0xFF003366);
  static const Color tealStart = Color(0xFF008888);
  static const Color tealEnd = Color(0xFF20B2AA);

  // Agricultural Context
  static const Color fieldGreen = Color(0xFF2E7032);
  static const Color earthBrown = Color(0xFF795548);

  // Alerts & Indicators
  static const Color warningOrange = Color(0xFFFF8800);
  static const Color criticalRed = Color(0xFFD03F2F);
  static const Color safeBlue = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);

  // Gradients
  static const LinearGradient aquaFlowGradient = LinearGradient(
    colors: [tealStart, tealEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

