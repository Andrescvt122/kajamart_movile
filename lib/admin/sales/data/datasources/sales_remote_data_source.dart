import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/sale_model.dart';

const List<SaleModel> _mockSales = [];

class SalesRemoteDataSource {
  final String baseUrl;
  final String salesEndpoint;
  final http.Client httpClient;
  final Map<String, String>? defaultHeaders;

  SalesRemoteDataSource({
    required this.baseUrl,
    this.salesEndpoint = '/sales',
    http.Client? httpClient,
    this.defaultHeaders,
  }) : httpClient = httpClient ?? http.Client();

  Future<List<SaleModel>> fetchSales({bool useMockData = false}) async {
    if (useMockData || baseUrl.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockSales;
    }

    try {
      final uri = Uri.parse('$baseUrl$salesEndpoint');
      debugPrint('🔵 [Ventas] GET $uri');

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

      debugPrint('🟢 [Ventas] status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // the server may return an array directly
        final items = data is List
            ? data
            : (data is Map && data['sales'] != null
                  ? data['sales'] as List<dynamic>
                  : []);
        final list = (items as List).map((e) {
          final map = e is Map<String, dynamic>
              ? e
              : Map<String, dynamic>.from(e as Map);
          return SaleModel.fromJson(map);
        }).toList();
        debugPrint('🟢 [Ventas] loaded: ${list.length}');
        return list;
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado (401)');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('🔴 [Ventas] error: ${e.toString()}');
      if (kIsWeb && e.toString().contains('CORS')) {
        debugPrint('⚠️ [Ventas] Web CORS fallback to mock');
        await Future.delayed(const Duration(milliseconds: 300));
        return _mockSales;
      }
      throw Exception('Error: ${e.toString()}');
    }
  }
}
