import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';

class RouteProvider extends ChangeNotifier {
  List<RouteModel> _routes = [];
  RouteModel? _selectedRoute;
  bool _isLoading = false;
  String _pickupLocation = '';
  String _destination = '';
  bool _isNavigating = false;

  List<RouteModel> get routes => _routes;
  RouteModel? get selectedRoute => _selectedRoute;
  bool get isLoading => _isLoading;
  String get pickupLocation => _pickupLocation;
  String get destination => _destination;
  bool get isNavigating => _isNavigating;

  void setPickupLocation(String location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDestination(String dest) {
    _destination = dest;
    notifyListeners();
  }

  Future<void> searchRoutes() async {
    if (_pickupLocation.isEmpty || _destination.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Generate mock routes
    _routes = [
      RouteModel(
        id: 'r1',
        name: 'Via Main Road & Hospital Junction',
        safetyLevel: SafetyLevel.safest,
        distanceKm: 5.8,
        durationMinutes: 22,
        lightingScore: 5,
        crowdScore: 4,
        incidentCount: 0,
        points: [
          const LatLng(6.9271, 79.8612),
          const LatLng(6.9290, 79.8580),
          const LatLng(6.9310, 79.8550),
          const LatLng(6.9330, 79.8520),
          const LatLng(6.9350, 79.8500),
          const LatLng(6.9370, 79.8480),
          const LatLng(6.9390, 79.8460),
        ],
      ),
      RouteModel(
        id: 'r2',
        name: 'Via City Center & Park Road',
        safetyLevel: SafetyLevel.balanced,
        distanceKm: 4.5,
        durationMinutes: 18,
        lightingScore: 3,
        crowdScore: 3,
        incidentCount: 2,
        points: [
          const LatLng(6.9271, 79.8612),
          const LatLng(6.9260, 79.8590),
          const LatLng(6.9250, 79.8560),
          const LatLng(6.9280, 79.8530),
          const LatLng(6.9320, 79.8500),
          const LatLng(6.9360, 79.8475),
          const LatLng(6.9390, 79.8460),
        ],
      ),
      RouteModel(
        id: 'r3',
        name: 'Via Shortcut Lane',
        safetyLevel: SafetyLevel.fastest,
        distanceKm: 3.2,
        durationMinutes: 12,
        lightingScore: 2,
        crowdScore: 1,
        incidentCount: 5,
        points: [
          const LatLng(6.9271, 79.8612),
          const LatLng(6.9280, 79.8570),
          const LatLng(6.9310, 79.8530),
          const LatLng(6.9350, 79.8490),
          const LatLng(6.9390, 79.8460),
        ],
      ),
    ];

    _selectedRoute = _routes.first;
    _isLoading = false;
    notifyListeners();
  }

  void selectRoute(RouteModel route) {
    _selectedRoute = route;
    notifyListeners();
  }

  void startNavigation() {
    _isNavigating = true;
    notifyListeners();
  }

  void stopNavigation() {
    _isNavigating = false;
    notifyListeners();
  }

  void clearRoutes() {
    _routes = [];
    _selectedRoute = null;
    _pickupLocation = '';
    _destination = '';
    _isNavigating = false;
    notifyListeners();
  }
}
