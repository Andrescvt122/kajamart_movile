import 'package:flutter/material.dart';

import '../../models/auth_session.dart';
import '../../services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;

  AuthSession? _session;
  bool _isLoading = false;
  String? _errorMessage;

  AuthSession? get session => _session;
  bool get isAuthenticated => _session != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _session = await _service.restoreSession();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _session = await _service.login(email: email, password: password);
      return true;
    } catch (_) {
      _session = null;
      _errorMessage = 'Correo o contraseñas incorrectas';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _session = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final current = _session;
    if (current == null) {
      throw Exception('No hay sesión activa');
    }

    return _service.getUserById(userId: current.userId, token: current.token);
  }
}
