import 'package:flutter/material.dart';
import '../packages/auth_package/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  String? _token;
  String? _error;
  bool _isLoading = false;

  AuthProvider({required this.authService});

  String? get token => _token;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final jwt = await authService.signInWithEmailPassword(email, password);
      _token = jwt;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
