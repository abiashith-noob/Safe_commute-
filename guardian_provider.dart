import 'package:flutter/material.dart';
import '../models/guardian_model.dart';
import '../services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class GuardianProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  List<GuardianModel> _guardians = [];
  bool _isLoading = false;

  List<GuardianModel> get guardians => _guardians;
  List<GuardianModel> get activeGuardians =>
      _guardians.where((g) => g.isActive).toList();
  bool get isLoading => _isLoading;

  Future<void> loadGuardians() async {
    _isLoading = true;
    notifyListeners();

    _guardians = await _firestoreService.getGuardians();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGuardian({
    required String name,
    required String phone,
    required String relation,
  }) async {
    final guardian = GuardianModel(
      id: _uuid.v4(),
      name: name,
      phone: phone,
      relation: relation,
    );

    _guardians.add(guardian);
    await _firestoreService.addGuardian(guardian);
    notifyListeners();
  }

  Future<void> removeGuardian(String id) async {
    _guardians.removeWhere((g) => g.id == id);
    await _firestoreService.removeGuardian(id);
    notifyListeners();
  }

  Future<void> toggleLocationSharing(String id, bool enabled, {Duration? duration}) async {
    final index = _guardians.indexWhere((g) => g.id == id);
    if (index != -1) {
      _guardians[index] = _guardians[index].copyWith(
        isLocationSharing: enabled,
        sharingExpiresAt: enabled && duration != null
            ? DateTime.now().add(duration)
            : null,
      );
      await _firestoreService.updateGuardian(_guardians[index]);
      notifyListeners();
    }
  }

  Future<void> alertAllGuardians() async {
    // Mock: would send push notifications to all active guardians
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
