import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/location_model.dart';
import '../providers/globe_provider.dart';

class LocationManager extends StatelessWidget {
  const LocationManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.locations.length,
                itemBuilder: (context, index) {
                  final location = provider.locations[index];
                  return _CollapsibleLocationCard(
                    location: location,
                    provider: provider,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollapsibleLocationCard extends StatelessWidget {
  final LocationModel location;
  final GlobeProvider provider;

  const _CollapsibleLocationCard({
    required this.location,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: location.isVisible
            ? AppColors.glassBackground
            : AppColors.glassBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: location.isVisible
              ? location.color.withOpacity(0.5)
              : AppColors.glassBorder,
          width: location.isVisible ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Color Indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: location.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: location.color.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Name + Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: location.isVisible
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                      ),
                    ),
                    if (location.description != null)
                      Text(
                        location.description!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: location.isVisible,
                onChanged: (_) => provider.toggleLocation(location),
                activeColor: location.color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: 12),

          // Coordinates
          Row(
            children: [
              Flexible(
                child: _buildCoordinateChip(
                  icon: Icons.location_on,
                  label: 'Lat',
                  value: location.coordinates.latitude.toStringAsFixed(2),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: _buildCoordinateChip(
                  icon: Icons.explore,
                  label: 'Lon',
                  value: location.coordinates.longitude.toStringAsFixed(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Size Control
          Row(
            children: [
              const Icon(Icons.circle,
                  size: 10, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Text(
                'Size',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: Slider(
                  value: location.size / 30,
                  min: 0.2,
                  max: 1.0,
                  activeColor: location.color,
                  inactiveColor: AppColors.tertiaryDark,
                  onChanged: (value) {
                    provider.updateLocationSize(location.id, value * 30);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: location.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  location.size.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: location.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Focus Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => provider.focusOnLocation(location),
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text('Focus on Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: location.color.withOpacity(0.2),
                foregroundColor: location.color,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: location.color.withOpacity(0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tertiaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.neonBlue),
          const SizedBox(width: 2),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonBlue,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
