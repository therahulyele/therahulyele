import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFFF7A45); // Coral
  static const Color success = Color(0xFF2ECC71); // Emerald

  // New Alternative Colors (can be reverted if not preferred)
  static const Color kPrimary = Color(0xFF2ECC71); // Emerald Green
  static const Color kBackground = Colors.black; // Pure Black
  static const Color kTextWhite = Colors.white; // Pure White
  static const Color kTextGrey = Colors.grey; // Standard Grey

  // Light Theme
  static const Color lightBackground = Color(0xFFF2F2F2); // White Smoke
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF1C2237); // Oxford Blue
  static const Color lightTextSecondary = Color(0xFF6B7280); // Muted text

  // Dark Theme
  static const Color darkBackground = Color(0xFF1C2237); // Oxford Blue
  static const Color darkSurface = Color(0xFF0B3D2E); // Dark Green
  static const Color darkText = Color(0xFFF2F2F2); // White Smoke
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // Muted text

  // Neutrals
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE5E7EB);
  static const Color greyDark = Color(0xFF374151);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Chart Colors
  static const Color chartPrimary = Color(0xFFFF7A45); // Coral
  static const Color chartSecondary = Color(0xFF2ECC71); // Emerald
  static const Color chartTertiary = Color(0xFF8B5CF6); // Purple
  static const Color chartQuaternary = Color(0xFF06B6D4); // Cyan

  // Usage Card Colors
  static const Color usageCardLight = Colors.white;
  static const Color usageCardDark = Color(0xFF0B3D2E);
  static const Color usageCardBorderLight = Color(0xFFE5E7EB);
  static const Color usageCardBorderDark = Color(0xFF374151);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF7A45), // Coral
    Color(0xFFFF8A65), // Light Coral
  ];

  static const List<Color> successGradient = [
    Color(0xFF2ECC71), // Emerald
    Color(0xFF58D68D), // Light Emerald
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1C2237), // Oxford Blue
    Color(0xFF0B3D2E), // Dark Green
  ];
}
