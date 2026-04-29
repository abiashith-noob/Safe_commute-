import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import '../models/safety_zone_model.dart';
import '../services/firestore_service.dart';

enum MapFilter { crime, poorLighting, crowdLevel }

class MapProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<SafetyZoneModel> _safetyZones = [];
  List<IncidentModel> _incidents = [];
  final Set<MapFilter> _activeFilters = {};
  bool _isLoading = false;

  List<SafetyZoneModel> get safetyZones => _safetyZones;
  List<IncidentModel> get incidents => _filteredIncidents;
  Set<MapFilter> get activeFilters => _activeFilters;
  bool get isLoading => _isLoading;

  List<IncidentModel> get _filteredIncidents {
    if (_activeFilters.isEmpty) return _incidents;

    return _incidents.where((incident) {
      if (_activeFilters.contains(MapFilter.crime) &&
          (incident.type == IncidentType.harassment ||
              incident.type == IncidentType.theft ||
              incident.type == IncidentType.stalking)) {
        return true;
      }
      if (_activeFilters.contains(MapFilter.poorLighting) &&
          incident.type == IncidentType.poorLighting) {
        return true;
      }
      if (_activeFilters.contains(MapFilter.crowdLevel) &&
          incident.type == IncidentType.suspiciousActivity) {
        return true;
      }
      return false;
    }).toList();
  }

  Future<void> loadMapData() async {
    _isLoading = true;
    notifyListeners();

    _safetyZones = await _firestoreService.getSafetyZones();
    _incidents = await _firestoreService.getIncidents();

    _isLoading = false;
    notifyListeners();
  }

  void toggleFilter(MapFilter filter) {
    if (_activeFilters.contains(filter)) {
      _activeFilters.remove(filter);
    } else {
      _activeFilters.add(filter);
    }
    notifyListeners();
  }

  void clearFilters() {
    _activeFilters.clear();
    notifyListeners();
  }
}
