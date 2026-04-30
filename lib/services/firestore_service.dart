import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/guardian_model.dart';
import '../models/incident_model.dart';
import '../models/safety_zone_model.dart';

/// Real Cloud Firestore service.
/// Falls back to mock data when Firestore collections are empty.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Operations ---

  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return UserModel(
        id: doc.id,
        fullName: data['fullName'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'],
        locationTrackingEnabled: data['locationTrackingEnabled'] ?? false,
        safetyPreferences: data['safetyPreferences'] as Map<String, dynamic>?,
      );
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.id).update(user.toMap());
  }

  // --- Guardian Operations ---

  Future<void> addGuardian(GuardianModel guardian) async {
    await _db.collection('guardians').doc(guardian.id).set({
      'name': guardian.name,
      'phone': guardian.phone,
      'relation': guardian.relation,
      'isActive': guardian.isActive,
    });
  }

  Future<void> updateGuardian(GuardianModel guardian) async {
    await _db.collection('guardians').doc(guardian.id).update({
      'name': guardian.name,
      'phone': guardian.phone,
      'relation': guardian.relation,
      'isActive': guardian.isActive,
    });
  }

  Future<void> removeGuardian(String id) async {
    await _db.collection('guardians').doc(id).delete();
  }

  Future<List<GuardianModel>> getGuardians() async {
    final snapshot = await _db.collection('guardians').get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return GuardianModel(
          id: doc.id,
          name: data['name'] ?? '',
          phone: data['phone'] ?? '',
          relation: data['relation'] ?? '',
          isActive: data['isActive'] ?? false,
        );
      }).toList();
    }

    return [];
  }

  // --- Incident Operations ---

  Future<void> submitIncident(IncidentModel incident) async {
    await _db.collection('incidents').doc(incident.id).set({
      'type': incident.type.name,
      'description': incident.description,
      'latitude': incident.latitude,
      'longitude': incident.longitude,
      'timestamp': Timestamp.fromDate(incident.timestamp),
    });
  }

  Future<List<IncidentModel>> getIncidents() async {
    final snapshot = await _db.collection('incidents').get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return IncidentModel(
          id: doc.id,
          type: IncidentType.values.firstWhere(
            (t) => t.name == data['type'],
            orElse: () => IncidentType.other,
          ),
          description: data['description'] ?? '',
          latitude: (data['latitude'] as num).toDouble(),
          longitude: (data['longitude'] as num).toDouble(),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    }

    // Fallback mock data
    return [
      IncidentModel(
          id: 'inc1', type: IncidentType.poorLighting,
          description: 'Street lights not working on Oak Avenue',
          latitude: 6.9271, longitude: 79.8612,
          timestamp: DateTime.now().subtract(const Duration(hours: 2))),
      IncidentModel(
          id: 'inc2', type: IncidentType.harassment,
          description: 'Cat-calling reported near Market Square',
          latitude: 6.9340, longitude: 79.8500,
          timestamp: DateTime.now().subtract(const Duration(hours: 5))),
      IncidentModel(
          id: 'inc3', type: IncidentType.suspiciousActivity,
          description: 'Suspicious person loitering near bus stop',
          latitude: 6.9200, longitude: 79.8700,
          timestamp: DateTime.now().subtract(const Duration(days: 1))),
      IncidentModel(
          id: 'inc4', type: IncidentType.theft,
          description: 'Phone snatching reported',
          latitude: 6.9150, longitude: 79.8550,
          timestamp: DateTime.now().subtract(const Duration(days: 2))),
    ];
  }

  // --- Safety Zone Operations ---

  Future<List<SafetyZoneModel>> getSafetyZones() async {
    final snapshot = await _db.collection('safety_zones').get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return SafetyZoneModel(
          latitude: (data['latitude'] as num).toDouble(),
          longitude: (data['longitude'] as num).toDouble(),
          radiusMeters: (data['radiusMeters'] as num).toDouble(),
          level: ZoneLevel.values.firstWhere(
            (z) => z.name == data['level'],
            orElse: () => ZoneLevel.moderate,
          ),
        );
      }).toList();
    }

    // Fallback mock data
    return [
      SafetyZoneModel(latitude: 6.9271, longitude: 79.8612,
          radiusMeters: 500, level: ZoneLevel.safe),
      SafetyZoneModel(latitude: 6.9200, longitude: 79.8500,
          radiusMeters: 400, level: ZoneLevel.safe),
      SafetyZoneModel(latitude: 6.9340, longitude: 79.8500,
          radiusMeters: 300, level: ZoneLevel.moderate),
      SafetyZoneModel(latitude: 6.9150, longitude: 79.8700,
          radiusMeters: 350, level: ZoneLevel.risky),
      SafetyZoneModel(latitude: 6.9100, longitude: 79.8400,
          radiusMeters: 450, level: ZoneLevel.safe),
      SafetyZoneModel(latitude: 6.9380, longitude: 79.8650,
          radiusMeters: 250, level: ZoneLevel.moderate),
      SafetyZoneModel(latitude: 6.9050, longitude: 79.8550,
          radiusMeters: 300, level: ZoneLevel.risky),
    ];
  }
}
