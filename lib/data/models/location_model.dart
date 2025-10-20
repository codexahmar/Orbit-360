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

  // Predefined Locations
  static LocationModel london = LocationModel(
    id: 'london',
    name: 'London',
    description: 'Capital of the United Kingdom',
    coordinates: const GlobeCoordinates(51.5072, -0.1276),
    color: const Color(0xFFFF6B6B),
    size: 10.0,
  );

  static LocationModel newYork = LocationModel(
    id: 'new_york',
    name: 'New York',
    description: 'The Big Apple',
    coordinates: const GlobeCoordinates(40.7128, -74.0060),
    color: const Color(0xFF4ECDC4),
    size: 10.0,
  );

  static LocationModel tokyo = LocationModel(
    id: 'tokyo',
    name: 'Tokyo',
    description: 'Capital of Japan',
    coordinates: const GlobeCoordinates(35.6895, 139.6917),
    color: const Color(0xFF95E1D3),
    size: 10.0,
  );

  static LocationModel paris = LocationModel(
    id: 'paris',
    name: 'Paris',
    description: 'City of Light',
    coordinates: const GlobeCoordinates(48.8566, 2.3522),
    color: const Color(0xFFFFA07A),
    size: 10.0,
  );

  static LocationModel sydney = LocationModel(
    id: 'sydney',
    name: 'Sydney',
    description: 'Harbor City',
    coordinates: const GlobeCoordinates(-33.8688, 151.2093),
    color: const Color(0xFFFFD93D),
    size: 10.0,
  );

  static LocationModel dubai = LocationModel(
    id: 'dubai',
    name: 'Dubai',
    description: 'City of Gold',
    coordinates: const GlobeCoordinates(25.2048, 55.2708),
    color: const Color(0xFFBC8CF2),
    size: 10.0,
  );

  static LocationModel center = LocationModel(
    id: 'center',
    name: 'Equator Prime',
    description: 'The center point',
    coordinates: const GlobeCoordinates(0, 0),
    color: const Color(0xFFF38BA8),
    size: 12.0,
  );

  static List<LocationModel> get defaultLocations => [
    london,
    newYork,
    tokyo,
    paris,
    sydney,
    dubai,
    center,
  ];
}