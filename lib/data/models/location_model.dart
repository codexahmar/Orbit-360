import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';

class LocationModel {
  final String id;
  final String name;
  final String? description;
  final GlobeCoordinates coordinates;
  final Color color;
  final double size;
  final IconData? icon;
  final bool isVisible;

  LocationModel({
    required this.id,
    required this.name,
    this.description,
    required this.coordinates,
    this.color = Colors.cyan,
    this.size = 8.0,
    this.icon,
    this.isVisible = true,
  });

  LocationModel copyWith({
    String? id,
    String? name,
    String? description,
    GlobeCoordinates? coordinates,
    Color? color,
    double? size,
    IconData? icon,
    bool? isVisible,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
      color: color ?? this.color,
      size: size ?? this.size,
      icon: icon ?? this.icon,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  Point toPoint({VoidCallback? onTap, VoidCallback? onHover}) {
    return Point(
      id: id,
      coordinates: coordinates,
      label: name,
      style: PointStyle(color: color, size: size),
      onTap: onTap,
      onHover: onHover,
      isLabelVisible: true,
    );
  }

  // --- 3 Locations at Distant Points ---
  static LocationModel pakistan = LocationModel(
    id: 'pakistan',
    name: 'Pakistan',
    coordinates: const GlobeCoordinates(30.3753, 69.3451), // South Asia
    color: const Color(0xFF00BFA6),
    size: 12.0,
  );

  static LocationModel brazil = LocationModel(
    id: 'brazil',
    name: 'Brazil',
    coordinates: const GlobeCoordinates(-14.2350, -51.9253), // South America
    color: const Color(0xFFFF6B6B),
    size: 10.0,
  );

  static LocationModel australia = LocationModel(
    id: 'australia',
    name: 'Australia',
    coordinates: const GlobeCoordinates(-25.2744, 133.7751), // Oceania
    color: const Color(0xFF4ECDC4),
    size: 10.0,
  );

  static List<LocationModel> get defaultLocations => [
        pakistan,
        brazil,
        australia,
      ];
}
