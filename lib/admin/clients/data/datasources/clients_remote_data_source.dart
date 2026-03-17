import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/client_model.dart';

class ClientsRemoteDataSource {
  final String baseUrl;
  final String clientsEndpoint;
  final http.Client httpClient;

  ClientsRemoteDataSource({
    required this.baseUrl,
    this.clientsEndpoint = '/clients',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<List<AdminClientModel>> fetchClients({
    bool useMockData = false,
  }) async {
    if (useMockData || baseUrl.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse('$baseUrl$clientsEndpoint');
      debugPrint('🔵 [Clientes] GET $uri');

      final response = await httpClient
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Timeout >15s'),
          );

      debugPrint('🟢 [Clientes] status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> list = decoded is List
            ? decoded
            : (decoded is Map<String, dynamic> && decoded['data'] is List)
            ? decoded['data'] as List<dynamic>
            : (decoded is Map<String, dynamic> && decoded['clients'] is List)
            ? decoded['clients'] as List<dynamic>
            : <dynamic>[];
        return list
            .map(
              (e) => AdminClientModel.fromJson(
                e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } on http.ClientException catch (e) {
      debugPrint('🔴 [Clientes] ClientException: ${e.message}');
      if (kIsWeb) return [];
      rethrow;
    } catch (e) {
      debugPrint('🔴 [Clientes] error: $e');
      if (kIsWeb && e.toString().contains('CORS')) return [];
      throw Exception('Error: ${e.toString()}');
    }
  }
}
