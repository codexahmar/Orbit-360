import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';

class StatsDisplay extends StatelessWidget {
  const StatsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, child) {
        final hasClick = provider.clickCoordinates != null;
        final hasHover = provider.hoverCoordinates != null;

        return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              if (hasClick)
                _buildCoordinateCard(
                  title: 'Click Position',
                  icon: Icons.touch_app,
                  coordinates: provider.clickCoordinates!,
                  gradient: AppColors.nebulaGradient,
                ),
              if (hasHover)
                _buildCoordinateCard(
                  title: 'Hover Position',
                  icon: Icons.mouse,
                  coordinates: provider.hoverCoordinates!,
                  gradient: AppColors.auroraGradient,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoordinateCard({
    required String title,
    required IconData icon,
    required GlobeCoordinates coordinates,
    required List<Color> gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppConstants.normalAnimation,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.glassBackground,
              AppColors.glassBackground.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(
            color: gradient.first.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: gradient.first,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Coordinates
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _buildCoordinateInfo(
                    icon: Icons.location_on,
                    label: 'Latitude',
                    value: coordinates.latitude.toStringAsFixed(4),
                    color: gradient.first,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCoordinateInfo(
                    icon: Icons.explore,
                    label: 'Longitude',
                    value: coordinates.longitude.toStringAsFixed(4),
                    color: gradient.last,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}