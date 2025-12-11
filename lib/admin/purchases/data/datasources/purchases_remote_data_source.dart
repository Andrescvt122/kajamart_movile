import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/purchase_model.dart';

/// Remote data source for purchases.
class PurchasesRemoteDataSource {
  final String baseUrl;
  final String purchasesEndpoint;
  final http.Client httpClient;
  final Map<String, String>? defaultHeaders;

  PurchasesRemoteDataSource({
    required this.baseUrl,
    this.purchasesEndpoint = '/purchase',
    http.Client? httpClient,
    this.defaultHeaders,
  }) : httpClient = httpClient ?? http.Client();

  Future<List<PurchaseModel>> fetchPurchases({bool useMockData = false}) async {
    if (useMockData || baseUrl.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 600));
      return mockPurchases;
    }

    try {
      final uri = Uri.parse('$baseUrl$purchasesEndpoint');
      debugPrint('🔵 [Compras] GET $uri');

      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (defaultHeaders != null) headers.addAll(defaultHeaders!);

      final response = await httpClient
          .get(uri, headers: headers)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Timeout >15s'),
          );

      debugPrint('🟢 [Compras] status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        // API returns { "purchase": [ ... ] }
        final items = data['purchase'] as List<dynamic>? ?? [];
        final purchases = items
            .map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('🟢 [Compras] loaded: ${purchases.length}');
        return purchases;
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado (401)');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint no encontrado (404): $purchasesEndpoint');
      } else if (response.statusCode == 500) {
        throw Exception('Error en servidor (500)');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } on http.ClientException catch (e) {
      debugPrint('🔴 [Compras] ClientException: ${e.message}');
      if (kIsWeb) {
        debugPrint('⚠️ [Compras] Web fallback to mock');
        await Future.delayed(const Duration(milliseconds: 300));
        return mockPurchases;
      }
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      debugPrint('🔴 [Compras] unexpected: ${e.toString()}');
      if (kIsWeb && e.toString().contains('CORS')) {
        debugPrint('⚠️ [Compras] Web CORS fallback');
        await Future.delayed(const Duration(milliseconds: 300));
        return mockPurchases;
      }
      throw Exception('Error: ${e.toString()}');
    }
  }
}
