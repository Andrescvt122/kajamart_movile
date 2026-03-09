import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_session.dart';

class AuthService {
  static const String _tokenKey = 'kajamart_token';

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );

    final dynamic body = jsonDecode(response.body);

    if (response.statusCode >= 400 || body is! Map<String, dynamic>) {
      throw Exception('Correo o contraseñas incorrectas');
    }

    final token = body['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('No se recibió token de autenticación');
    }

    final payload = _parseJwtPayload(token);
    final int roleId = _parseInt(payload['rol_id']);
    final int userId = _parseInt(payload['uid']);

    if (roleId <= 0 || userId <= 0) {
      throw Exception('Token inválido: faltan rol_id o uid');
    }

    final roleJson = await _getRoleById(roleId);
    final permissions = _extractPermissions(roleJson);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    return AuthSession(
      token: token,
      userId: userId,
      roleId: roleId,
      email: body['user']?['email']?.toString() ?? email,
      userName: body['user']?['usuarios']?['nombre']?.toString(),
      permissions: permissions,
    );
  }

  Future<AuthSession?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final payload = _parseJwtPayload(token);
      final int roleId = _parseInt(payload['rol_id']);
      final int userId = _parseInt(payload['uid']);

      if (roleId <= 0 || userId <= 0) {
        await logout();
        return null;
      }

      final roleJson = await _getRoleById(roleId);
      final permissions = _extractPermissions(roleJson);

      return AuthSession(
        token: token,
        userId: userId,
        roleId: roleId,
        email: '',
        userName: payload['nombre']?.toString(),
        permissions: permissions,
      );
    } catch (_) {
      await logout();
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserById({
    required int userId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('${_baseUrl}/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 400) {
      throw Exception('No se pudo cargar el perfil');
    }

    final dynamic body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Respuesta inválida al consultar perfil');
    }
    return body;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, dynamic>> _getRoleById(int roleId) async {
    final response = await http.get(
      Uri.parse('${_baseUrl}/roles/$roleId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 400) {
      throw Exception('No se pudo validar el rol');
    }

    final dynamic body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Respuesta inválida al consultar rol');
    }

    return body;
  }

  Set<String> _extractPermissions(Map<String, dynamic> roleJson) {
    final permisosRaw = roleJson['rol_permisos'];
    if (permisosRaw is! List) {
      return {};
    }

    return permisosRaw
        .map((item) => item['permisos']?['permiso_nombre']?.toString() ?? '')
        .where((name) => name.trim().isNotEmpty)
        .map((name) => name.toLowerCase().trim())
        .toSet();
  }

  Map<String, dynamic> _parseJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('JWT inválido');
    }

    final payload = base64Url.normalize(parts[1]);
    final payloadString = utf8.decode(base64Url.decode(payload));
    final dynamic payloadJson = jsonDecode(payloadString);

    if (payloadJson is! Map<String, dynamic>) {
      throw Exception('Payload inválido');
    }

    return payloadJson;
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value.trim()) ?? 0;
    return 0;
  }

  String get _baseUrl {
    const apiPath = '/kajamart/api';

    if (kIsWeb) {
      return 'http://localhost:3000$apiPath';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000$apiPath';
    }

    return 'http://localhost:3000$apiPath';
  }
}
