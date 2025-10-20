import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/sphere_style.dart';
import '../../data/models/location_model.dart';
import '../../data/models/celestial_body_model.dart';
import '../../data/repositories/globe_repository.dart';
import '../../core/constants/app_constants.dart';

class GlobeProvider extends ChangeNotifier {
  final GlobeRepository _repository = GlobeRepository();
  late FlutterEarthGlobeController _controller;

  // State variables
  List<LocationModel> _locations = [];
  List<PointConnection> _connections = [];
  CelestialBodyModel? _selectedBody;
  GlobeCoordinates? _hoverCoordinates;
  GlobeCoordinates? _clickCoordinates;
  bool _isInitialized = false;
  bool _showConnections = true;
  bool _showLabels = true;

  // Getters
  FlutterEarthGlobeController get controller => _controller;
  List<LocationModel> get locations => _locations;
  List<PointConnection> get connections => _connections;
  CelestialBodyModel? get selectedBody => _selectedBody;
  GlobeCoordinates? get hoverCoordinates => _hoverCoordinates;
  GlobeCoordinates? get clickCoordinates => _clickCoordinates;
  bool get isInitialized => _isInitialized;
  bool get isRotating => _controller.isRotating;
  double get rotationSpeed => _controller.rotationSpeed;
  double get zoom => _controller.zoom;
  bool get showConnections => _showConnections;
  bool get showLabels => _showLabels;

  void initialize() {
    if (_isInitialized) return;

    _controller = FlutterEarthGlobeController(
      rotationSpeed: AppConstants.defaultRotationSpeed,
      zoom: AppConstants.defaultZoom,
      isRotating: true,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/2k_stars.jpg').image,
      surface: Image.asset('assets/2k_earth-day.jpg').image,
    );

    _locations = _repository.getDefaultLocations();
    _connections = _repository.getDefaultConnections(_locations);
    _selectedBody = CelestialBodyModel.allBodies.first;

    // ✅ Mark initialized immediately
    _isInitialized = true;
    notifyListeners();

    // Load points after controller finishes loading
    _controller.onLoaded = () {
      _addAllPoints();
      _addAllConnections();
    };
  }

  void _addAllPoints() {
    for (var location in _locations) {
      _controller.addPoint(location.toPoint());
    }
  }

  void _addAllConnections() {
    if (_showConnections) {
      for (var connection in _connections) {
        _controller.addPointConnection(connection);
      }
    }
  }

  // Rotation controls
  void toggleRotation() {
    if (_controller.isRotating) {
      _controller.stopRotation();
    } else {
      _controller.startRotation();
    }
    notifyListeners();
  }

  void resetRotation() {
    _controller.resetRotation();
    notifyListeners();
  }

  void setRotationSpeed(double speed) {
    _controller.rotationSpeed = speed.clamp(
      AppConstants.minRotationSpeed,
      AppConstants.maxRotationSpeed,
    );
    notifyListeners();
  }

  // Zoom controls
  void setZoom(double zoom) {
    _controller.setZoom(zoom.clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    ));
    notifyListeners();
  }

  void zoomIn() {
    final newZoom = (_controller.zoom + 0.1).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    _controller.setZoom(newZoom);
    notifyListeners();
  }

  void zoomOut() {
    final newZoom = (_controller.zoom - 0.1).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    _controller.setZoom(newZoom);
    notifyListeners();
  }

  // Location management
  void toggleLocation(LocationModel location) {
    final index = _locations.indexWhere((l) => l.id == location.id);
    if (index != -1) {
      final updatedLocation = _locations[index].copyWith(
        isVisible: !_locations[index].isVisible,
      );
      _locations[index] = updatedLocation;

      if (updatedLocation.isVisible) {
        _controller.addPoint(updatedLocation.toPoint());
      } else {
        _controller.removePoint(updatedLocation.id);
      }
      notifyListeners();
    }
  }

  void updateLocationSize(String id, double size) {
    final index = _locations.indexWhere((l) => l.id == id);
    if (index != -1) {
      final location = _locations[index];
      final updatedLocation = location.copyWith(size: size);
      _locations[index] = updatedLocation;

      if (location.isVisible) {
        _controller.updatePoint(
          id,
          style: PointStyle(color: location.color, size: size),
        );
      }
      notifyListeners();
    }
  }

  void focusOnLocation(LocationModel location) {
    _controller.focusOnCoordinates(location.coordinates, animate: true);
  }

  // Connection management
  void toggleConnections() {
    _showConnections = !_showConnections;

    if (_showConnections) {
      for (var connection in _connections) {
        _controller.addPointConnection(connection, animateDraw: true);
      }
    } else {
      for (var connection in _connections) {
        _controller.removePointConnection(connection.id);
      }
    }
    notifyListeners();
  }

  // Celestial body selection
  void selectCelestialBody(CelestialBodyModel body) {
    _selectedBody = body;
    _controller.loadSurface(Image.asset(body.texturePath).image);

    if (body.hasGlow) {
      _controller.setSphereStyle(
        SphereStyle(
          shadowColor: body.glowColor!.withOpacity(0.9),
          shadowBlurSigma: body.glowIntensity!,
        ),
      );
    } else {
      _controller.setSphereStyle(const SphereStyle());
    }
    notifyListeners();
  }

  // Coordinate tracking
  void setHoverCoordinates(GlobeCoordinates? coordinates) {
    _hoverCoordinates = coordinates;
    notifyListeners();
  }

  void setClickCoordinates(GlobeCoordinates? coordinates) {
    _clickCoordinates = coordinates;
    notifyListeners();
  }

  // Labels
  void toggleLabels() {
    _showLabels = !_showLabels;
    notifyListeners();
  }

  @override
  void dispose() {
    // Controller disposal is handled by the widget
    super.dispose();
  }
}
