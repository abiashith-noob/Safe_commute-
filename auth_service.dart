import '../models/user_model.dart';
import 'api_service.dart';

/// Authentication service that communicates with the backend API.
class AuthService {
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post('/auth/signup', body: {
      'fullName': fullName,
      'email': email,
      'password': password,
    });

    if (response['success'] == true) {
      final data = response['data'];
      ApiService.setToken(data['token']);
      _currentUser = UserModel.fromMap(data['user']);
      _isAuthenticated = true;
      return _currentUser!;
    } else {
      throw Exception(response['message'] ?? 'Sign up failed');
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post('/auth/signin', body: {
      'email': email,
      'password': password,
    });

    if (response['success'] == true) {
      final data = response['data'];
      ApiService.setToken(data['token']);
      _currentUser = UserModel.fromMap(data['user']);
      _isAuthenticated = true;
      return _currentUser!;
    } else {
      throw Exception(response['message'] ?? 'Sign in failed');
    }
  }

  Future<void> signOut() async {
    await ApiService.post('/auth/signout');
    ApiService.clearToken();
    _currentUser = null;
    _isAuthenticated = false;
  }

  Future<void> resetPassword(String email) async {
    await ApiService.post('/auth/reset-password', body: {'email': email});
  }
}
