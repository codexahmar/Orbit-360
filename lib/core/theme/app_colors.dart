import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryDark = Color(0xFF0A0E27);
  static const Color secondaryDark = Color(0xFF1A1F3A);
  static const Color tertiaryDark = Color(0xFF2A2F4A);

  // Accent Colors
  static const Color neonBlue = Color(0xFF00D9FF);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonPink = Color(0xFFEC4899);
  static const Color neonGreen = Color(0xFF10B981);
  static const Color neonOrange = Color(0xFFFF6B35);

  // Gradient Colors
  static const List<Color> cosmicGradient = [
    Color(0xFF0F0C29),
    Color(0xFF302B63),
    Color(0xFF24243E),
  ];

  static const List<Color> nebulaGradient = [
    Color(0xFF8B5CF6),
    Color(0xFF6366F1),
    Color(0xFF3B82F6),
  ];

  static const List<Color> auroraGradient = [
    Color(0xFF00D9FF),
    Color(0xFF7C3AED),
    Color(0xFFEC4899),
  ];

  // Glass Morphism
  static Color glassBackground = Colors.white.withOpacity(0.05);
  static Color glassBorder = Colors.white.withOpacity(0.1);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB4B4B8);
  static const Color textTertiary = Color(0xFF6B6B70);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
