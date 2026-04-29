import '../models/user_model.dart';
import '../models/guardian_model.dart';
import '../models/incident_model.dart';
import '../models/safety_zone_model.dart';
import 'api_service.dart';

/// Service that communicates with the backend API for data operations.
/// Replaces the previous mock Firestore service.
class FirestoreService {
  // --- User Operations ---

  Future<void> saveUser(UserModel user) async {
    await ApiService.put('/users/me', body: user.toMap());
  }

  Future<UserModel?> getUser(String id) async {
    final response = await ApiService.get('/users/me');
    if (response['success'] == true) {
      return UserModel.fromMap(response['data']);
    }
    return null;
  }

  // --- Guardian Operations ---

  Future<void> addGuardian(GuardianModel guardian) async {
    await ApiService.post('/guardians', body: guardian.toMap());
  }

  Future<void> updateGuardian(GuardianModel guardian) async {
    await ApiService.put('/guardians/${guardian.id}', body: guardian.toMap());
  }

  Future<void> removeGuardian(String id) async {
    await ApiService.delete('/guardians/$id');
  }

  Future<List<GuardianModel>> getGuardians() async {
    final response = await ApiService.get('/guardians');
    if (response['success'] == true && response['data'] != null) {
      return (response['data'] as List)
          .map((g) => GuardianModel.fromMap(g))
          .toList();
    }
    return [];
  }

  // --- Incident Operations ---

  Future<void> submitIncident(IncidentModel incident) async {
    await ApiService.post('/incidents', body: incident.toMap());
  }

  Future<List<IncidentModel>> getIncidents() async {
    final response = await ApiService.get('/incidents');
    if (response['success'] == true && response['data'] != null) {
      return (response['data'] as List)
          .map((i) => IncidentModel.fromMap(i))
          .toList();
    }
    return [];
  }

  // --- Safety Zone Operations ---

  Future<List<SafetyZoneModel>> getSafetyZones() async {
    final response = await ApiService.get('/safety-zones');
    if (response['success'] == true && response['data'] != null) {
      return (response['data'] as List).map((z) {
        return SafetyZoneModel(
          latitude: (z['latitude'] ?? 0).toDouble(),
          longitude: (z['longitude'] ?? 0).toDouble(),
          radiusMeters: (z['radiusMeters'] ?? 300).toDouble(),
          level: _parseZoneLevel(z['level']),
        );
      }).toList();
    }
    return [];
  }

  ZoneLevel _parseZoneLevel(String? level) {
    switch (level) {
      case 'safe':
        return ZoneLevel.safe;
      case 'moderate':
        return ZoneLevel.moderate;
      case 'risky':
        return ZoneLevel.risky;
      default:
        return ZoneLevel.safe;
    }
  }
}
