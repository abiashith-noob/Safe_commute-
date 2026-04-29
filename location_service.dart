import 'package:latlong2/latlong.dart';

/// Mock location service.
/// In production, use the geolocator package for real GPS data.
class LocationService {
  // Default location: Colombo, Sri Lanka
  LatLng _currentLocation = const LatLng(6.9271, 79.8612);
  bool _isTracking = false;

  LatLng get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;

  Future<LatLng> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentLocation;
  }

  void startTracking() {
    _isTracking = true;
  }

  void stopTracking() {
    _isTracking = false;
  }

  void updateLocation(LatLng location) {
    _currentLocation = location;
  }

  /// Get a human-readable address for the current location (mock)
  Future<String> getAddressFromLocation(LatLng location) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'Colombo Fort, Colombo 01';
  }

  String getSafetyLevelForLocation(LatLng location) {
    // Mock safety assessment based on rough area
    if (location.latitude > 6.925 && location.longitude > 79.855) {
      return 'Safe';
    } else if (location.latitude > 6.920) {
      return 'Moderate';
    }
    return 'Risky';
  }
}
