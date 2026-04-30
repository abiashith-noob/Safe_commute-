import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import '../services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class IncidentProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  bool _isSubmitting = false;
  bool _isSubmitted = false;
  String? _error;

  bool get isSubmitting => _isSubmitting;
  bool get isSubmitted => _isSubmitted;
  String? get error => _error;

  Future<bool> submitIncident({
    required IncidentType type,
    required String description,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final incident = IncidentModel(
        id: _uuid.v4(),
        type: type,
        description: description,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      );

      await _firestoreService.submitIncident(incident);

      _isSubmitting = false;
      _isSubmitted = true;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _isSubmitting = false;
    _isSubmitted = false;
    _error = null;
    notifyListeners();
  }
}
