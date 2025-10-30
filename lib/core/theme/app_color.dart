import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // page background color
  static const Color background = Color(0xffFAF9F5);

  static const Color primary = Color(0xFF5FBB70);
  static const Color onPrimary = Color(0xffFAF9F5);

  // general button color
  static const Color buttonColor = Color(0xFF00F3A5);
  static const Color buttonTextColor = Color(0xFFFFFFFF);

  // Community specific colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  static const Color primaryAccent = Color(0xFF00D896);
  static const Color secondaryAccent = Color(0xFF00C486);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Action colors
  static const Color likeActive = Color(0xFFFF6B6B);
  static const Color likeInactive = Color(0xFFBBBBBB);
  static const Color commentIcon = Color(0xFF00D896);

  // Status colors
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);

  // Point change colors (for reports)
  static const Color pointDecrease = Color(
    0xFF2196F3,
  ); // Blue - when points decrease
  static const Color pointIncrease = Color(
    0xFFF44336,
  ); // Red - when points increase

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F3A5), Color(0xFF00D896)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FFFD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD6FECC), Color(0xFF7EECD9)],
  );
}
