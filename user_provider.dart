import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? photoUrl,
    bool? locationTrackingEnabled,
  }) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    _user = _user!.copyWith(
      fullName: fullName,
      phone: phone,
      photoUrl: photoUrl,
      locationTrackingEnabled: locationTrackingEnabled,
    );

    await _firestoreService.saveUser(_user!);

    _isLoading = false;
    notifyListeners();
  }
}
