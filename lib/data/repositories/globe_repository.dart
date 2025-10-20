import 'dart:ui';

import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/point_connection_style.dart';
import '../models/location_model.dart';

class GlobeRepository {
  List<LocationModel> getDefaultLocations() {
    return LocationModel.defaultLocations;
  }

  List<PointConnection> getDefaultConnections(List<LocationModel> locations) {
    if (locations.length < 4) return [];

    return [
      PointConnection(
        id: 'conn_1',
        start: locations[0].coordinates, // London
        end: locations[1].coordinates, // New York
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
      PointConnection(
        id: 'conn_2',
        start: locations[1].coordinates, // New York
        end: locations[2].coordinates, // Tokyo
        label: '${locations[1].name} → ${locations[2].name}',
        isMoving: true,
        curveScale: 1.5,
        style: const PointConnectionStyle(
          type: PointConnectionType.dashed,
          color: Color(0xFF8B5CF6),
          lineWidth: 2.5,
        ),
      ),
      PointConnection(
        id: 'conn_3',
        start: locations[2].coordinates, // Tokyo
        end: locations[3].coordinates, // Paris
        label: '${locations[2].name} → ${locations[3].name}',
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

  String getLocationInfo(GlobeCoordinates coordinates) {
    return 'Lat: ${coordinates.latitude.toStringAsFixed(4)}, '
           'Lon: ${coordinates.longitude.toStringAsFixed(4)}';
  }

  double calculateDistance(GlobeCoordinates start, GlobeCoordinates end) {
    // Simplified distance calculation (Haversine formula could be used for accuracy)
    final latDiff = (start.latitude - end.latitude).abs();
    final lonDiff = (start.longitude - end.longitude).abs();
    return (latDiff + lonDiff) / 2;
  }
}