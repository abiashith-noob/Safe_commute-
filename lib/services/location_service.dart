import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

/// Real location service using geolocator and geocoding.
class LocationService {
  LatLng? _currentLocation;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  LatLng? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;

  Future<void> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<LatLng> getCurrentLocation() async {
    await requestPermissions();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentLocation = LatLng(position.latitude, position.longitude);
    return _currentLocation!;
  }

  void startTracking(Function(LatLng) onLocationUpdated) async {
    await requestPermissions();
    _isTracking = true;
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      onLocationUpdated(_currentLocation!);
    });
  }

  void stopTracking() {
    _isTracking = false;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  void updateLocation(LatLng location) {
    _currentLocation = location;
  }

  Future<String> getAddressFromLocation(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}';
      }
    } catch (e) {
      return 'Unknown Location';
    }
    return 'Unknown Location';
  }

  String getSafetyLevelForLocation(LatLng location) {
    // We would ideally call an AI backend or use our Firestore data.
    // For now, return a placeholder based on location bounds just like before.
    if (location.latitude > 6.925 && location.longitude > 79.855) {
      return 'Safe';
    } else if (location.latitude > 6.920) {
      return 'Moderate';
    }
    return 'Risky';
  }
}
