import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isProfileSetupComplete = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isProfileSetupComplete => _isProfileSetupComplete;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authUser = await _authService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      
      final firestoreService = FirestoreService();
      await firestoreService.saveUser(authUser);
      
      _user = authUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authUser = await _authService.signIn(email: email, password: password);
      
      final firestoreService = FirestoreService();
      final firestoreUser = await firestoreService.getUser(authUser.id);
      
      if (firestoreUser != null) {
        _user = firestoreUser;
      } else {
        await firestoreService.saveUser(authUser);
        _user = authUser;
      }
      
      _isProfileSetupComplete = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _isProfileSetupComplete = false;
    notifyListeners();
  }

  Future<void> updateUser(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final firestoreService = FirestoreService();
      await firestoreService.updateUser(updatedUser);
      _user = updatedUser;
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void completeProfileSetup() {
    _isProfileSetupComplete = true;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
