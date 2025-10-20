import 'dart:math' as math;
import 'package:flutter/material.dart';

class Helpers {
  // Calculate distance between two coordinates (Haversine formula)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371; // km

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  // Format coordinate for display
  static String formatCoordinate(double value, {bool isLatitude = true}) {
    final direction = isLatitude
        ? (value >= 0 ? 'N' : 'S')
        : (value >= 0 ? 'E' : 'W');
    return '${value.abs().toStringAsFixed(4)}° $direction';
  }

  // Generate gradient color based on index
  static Color getGradientColor(int index, int total) {
    final hue = (index / total) * 360;
    return HSVColor.fromAHSV(1.0, hue, 0.7, 0.9).toColor();
  }

  // Show custom snackbar
  static void showCustomSnackbar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
      ),
    );
  }

  // Responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return baseSize * 0.9;
    } else if (width < 900) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }

  // Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Generate random position for particle effects
  static Offset getRandomPosition(Size size) {
    final random = math.Random();
    return Offset(
      random.nextDouble() * size.width,
      random.nextDouble() * size.height,
    );
  }

  // Lerp between colors
  static Color lerpGradient(List<Color> colors, double t) {
    if (colors.isEmpty) return Colors.transparent;
    if (colors.length == 1) return colors[0];

    final index = (t * (colors.length - 1)).floor();
    final nextIndex = (index + 1).clamp(0, colors.length - 1);
    final localT = (t * (colors.length - 1)) - index;

    return Color.lerp(colors[index], colors[nextIndex], localT) ??
        colors[index];
  }
}