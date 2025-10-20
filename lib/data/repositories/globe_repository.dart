import 'dart:ui';

import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/point_connection_style.dart';
import '../models/location_model.dart';

class GlobeRepository {
  /// Returns 3 default global locations (Pakistan, Brazil, Australia)
  List<LocationModel> getDefaultLocations() {
    return LocationModel.defaultLocations;
  }

  /// Creates 3 interconnecting animated routes between the locations
  List<PointConnection> getDefaultConnections(List<LocationModel> locations) {
    if (locations.length < 3) return [];

    return [
      // Pakistan → Brazil
      PointConnection(
        id: 'conn_1',
        start: locations[0].coordinates,
        end: locations[1].coordinates,
        label: '${locations[0].name} → ${locations[1].name}',
        isMoving: true,
        curveScale: 1.2,
        style: const PointConnectionStyle(
          type: PointConnectionType.dotted,
          color: Color(0xFF00D9FF),
          lineWidth: 3,
          dashSize: 8,
          spacing: 12,
        ),
      ),

      // Brazil → Australia
      PointConnection(
        id: 'conn_2',
        start: locations[1].coordinates,
        end: locations[2].coordinates,
        label: '${locations[1].name} → ${locations[2].name}',
        isMoving: true,
        curveScale: 1.5,
        style: const PointConnectionStyle(
          type: PointConnectionType.dashed,
          color: Color(0xFF8B5CF6),
          lineWidth: 2.5,
        ),
      ),

      // Australia → Pakistan (closing the triangle)
      PointConnection(
        id: 'conn_3',
        start: locations[2].coordinates,
        end: locations[0].coordinates,
        label: '${locations[2].name} → ${locations[0].name}',
        isMoving: true,
        curveScale: 1.3,
        style: const PointConnectionStyle(
          type: PointConnectionType.solid,
          color: Color(0xFFEC4899),
          lineWidth: 2,
        ),
      ),
    ];
  }

  /// Returns formatted coordinates string
  String getLocationInfo(GlobeCoordinates coordinates) {
    return 'Lat: ${coordinates.latitude.toStringAsFixed(4)}, '
        'Lon: ${coordinates.longitude.toStringAsFixed(4)}';
  }

  /// Rough distance metric (not geographic)
  double calculateDistance(GlobeCoordinates start, GlobeCoordinates end) {
    final latDiff = (start.latitude - end.latitude).abs();
    final lonDiff = (start.longitude - end.longitude).abs();
    return (latDiff + lonDiff) / 2;
  }
}
