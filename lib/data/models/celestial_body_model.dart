import 'package:flutter/material.dart';

class CelestialBodyModel {
  final String id;
  final String name;
  final String texturePath;
  final String description;
  final Color? glowColor;
  final double? glowIntensity;
  final IconData icon;

  CelestialBodyModel({
    required this.id,
    required this.name,
    required this.texturePath,
    required this.description,
    this.glowColor,
    this.glowIntensity,
    required this.icon,
  });

  bool get hasGlow => glowColor != null && glowIntensity != null;

  static final List<CelestialBodyModel> allBodies = [
    CelestialBodyModel(
      id: 'earth',
      name: 'Earth',
      texturePath: 'assets/2k_earth-day.jpg',
      description: 'Our beautiful home planet',
      icon: Icons.public,
    ),
    CelestialBodyModel(
      id: 'sun',
      name: 'Sun',
      texturePath: 'assets/2k_sun.jpg',
      description: 'The star at the center of our solar system',
      glowColor: Colors.orangeAccent,
      glowIntensity: 25.0,
      icon: Icons.wb_sunny,
    ),
    CelestialBodyModel(
      id: 'moon',
      name: 'Moon',
      texturePath: 'assets/2k_moon.jpg',
      description: "Earth's only natural satellite",
      icon: Icons.nightlight_round,
    ),
    CelestialBodyModel(
      id: 'mars',
      name: 'Mars',
      texturePath: 'assets/2k_mars.jpg',
      description: 'The Red Planet',
      glowColor: Colors.deepOrangeAccent,
      glowIntensity: 15.0,
      icon: Icons.circle,
    ),
    CelestialBodyModel(
      id: 'jupiter',
      name: 'Jupiter',
      texturePath: 'assets/2k_jupiter.jpg',
      description: 'The largest planet in our solar system',
      icon: Icons.circle_outlined,
    ),
    CelestialBodyModel(
      id: 'saturn',
      name: 'Saturn',
      texturePath: 'assets/2k_saturn.jpg',
      description: 'The ringed planet',
      icon: Icons.album,
    ),
    CelestialBodyModel(
      id: 'venus',
      name: 'Venus',
      texturePath: 'assets/2k_venus_surface.jpg',
      description: 'The hottest planet',
      glowColor: Colors.amber,
      glowIntensity: 18.0,
      icon: Icons.brightness_5,
    ),
    CelestialBodyModel(
      id: 'mercury',
      name: 'Mercury',
      texturePath: 'assets/2k_mercury.jpg',
      description: 'The smallest planet',
      icon: Icons.circle,
    ),
    CelestialBodyModel(
      id: 'uranus',
      name: 'Uranus',
      texturePath: 'assets/2k_uranus.jpg',
      description: 'The ice giant',
      icon: Icons.blur_circular,
    ),
    CelestialBodyModel(
      id: 'neptune',
      name: 'Neptune',
      texturePath: 'assets/2k_neptune.jpg',
      description: 'The windiest planet',
      icon: Icons.water,
    ),
  ];
}