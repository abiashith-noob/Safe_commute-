import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LatLng _currentLocation = const LatLng(6.9271, 79.8612);
  String _currentAddress = 'Colombo Fort, Colombo 01';
  String _safetyLevel = 'Safe';
  bool _isTracking = false;
  bool _isLoading = false;

  LatLng get currentLocation => _currentLocation;
  String get currentAddress => _currentAddress;
  String get safetyLevel => _safetyLevel;
  bool get isTracking => _isTracking;
  bool get isLoading => _isLoading;

  Future<void> fetchCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentLocation = await _locationService.getCurrentLocation();
      _currentAddress =
          await _locationService.getAddressFromLocation(_currentLocation);
      _safetyLevel =
          _locationService.getSafetyLevelForLocation(_currentLocation);
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleTracking(bool enabled) {
    _isTracking = enabled;
    if (enabled) {
      _locationService.startTracking((newLocation) async {
        _currentLocation = newLocation;
        _currentAddress = await _locationService.getAddressFromLocation(_currentLocation);
        _safetyLevel = _locationService.getSafetyLevelForLocation(_currentLocation);
        notifyListeners();
      });
    } else {
      _locationService.stopTracking();
    }
    notifyListeners();
  }
}

