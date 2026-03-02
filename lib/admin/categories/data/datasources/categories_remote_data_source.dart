import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';

class CategoriesRemoteDataSource {
  final String baseUrl;
  final String categoriesEndpoint;
  final http.Client httpClient;
  final Map<String, String>? defaultHeaders;

  CategoriesRemoteDataSource({
    required this.baseUrl,
    this.categoriesEndpoint = '/categories',
    http.Client? httpClient,
    this.defaultHeaders,
  }) : httpClient = httpClient ?? http.Client();

  Future<List<CategoryModel>> fetchCategories({bool useMockData = false}) async {
    if (useMockData || baseUrl.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 400));
      return mockCategories;
    }

    try {
      final uri = Uri.parse('$baseUrl$categoriesEndpoint');
      debugPrint('[Categorias] GET $uri');

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

      debugPrint('[Categorias] status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = _extractItems(data);
        final categories = items.map(CategoryModel.fromJson).toList();
        debugPrint('[Categorias] loaded: ${categories.length}');
        return categories;
      }

      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } on http.ClientException catch (e) {
      debugPrint('[Categorias] ClientException: ${e.message}');
      if (kIsWeb) {
        debugPrint('[Categorias] Web fallback to mock');
        await Future.delayed(const Duration(milliseconds: 200));
        return mockCategories;
      }
      throw Exception('Error de conexion: ${e.message}');
    } catch (e) {
      debugPrint('[Categorias] error: $e');
      if (kIsWeb && e.toString().contains('CORS')) {
        debugPrint('[Categorias] Web CORS fallback');
        await Future.delayed(const Duration(milliseconds: 200));
        return mockCategories;
      }
      throw Exception('Error: $e');
    }
  }

  List<Map<String, dynamic>> _extractItems(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final candidates = [
        map['categories'],
        map['category'],
        map['data'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }
    }

    return const <Map<String, dynamic>>[];
  }
}

const List<CategoryModel> _mockCategories = [];

List<CategoryModel> get mockCategories => _mockCategories;
