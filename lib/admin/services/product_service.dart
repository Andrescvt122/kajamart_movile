// lib/admin/services/product_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/batch.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api';

  bool isLoading = false;
  String? error;

  List<Product> _products = [];
  List<Product> get products => _products;

  ProductService() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final uri = Uri.parse('$_baseUrl/products/all');
      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        error = 'Error ${resp.statusCode} al obtener productos';
        _products = [];
        return;
      }

      final dynamic decoded = jsonDecode(resp.body);
      final List<dynamic> data = decoded is List<dynamic>
          ? decoded
          : (decoded is Map<String, dynamic> && decoded['data'] is List)
          ? decoded['data'] as List<dynamic>
          : <dynamic>[];

      if (data.isEmpty && decoded is! List<dynamic>) {
        error = 'Formato de respuesta invalido al obtener productos';
        _products = [];
        return;
      }

      _products = data.map<Product>((item) {
        final p = item as Map<String, dynamic>;

        final int stockActual = (p['stock_actual'] ?? 0) as int;
        final int stockMinimo = (p['stock_minimo'] ?? 0) as int;
        final int stockMaximo = (p['stock_maximo'] ?? 0) as int;
        final double precioVenta =
            (p['precio_venta'] as num?)?.toDouble() ?? 0.0;
        final double costoUnitario =
            (p['costo_unitario'] as num?)?.toDouble() ?? 0.0;

        final String imageUrl = (p['url_imagen'] ?? '') as String;
        final String categoria = (p['categoria'] ?? 'Sin categoría') as String;

        // ⚠️ Como el backend aún no devuelve lotes, generamos
        // un solo lote con todo el stock del producto.
        final List<Batch> batches = [
          Batch(
            idDetalle: 'L${p['id_producto']}',
            barcode: 'COD-${p['id_producto']}',
            expiryDate: DateTime.now().add(const Duration(days: 365)),
            quantity: stockActual,
            consumedStock: 0,
            price: precioVenta,
          ),
        ];

        return Product(
          id: p['id_producto'].toString(),
          name: p['nombre']?.toString() ?? '',
          category: categoria,
          imageUrl: imageUrl.isNotEmpty
              ? imageUrl
              : 'https://via.placeholder.com/150',
          currentStock: stockActual,
          minStock: stockMinimo,
          maxStock: stockMaximo,
          price: precioVenta,
          status: (p['estado'] == true) ? 'activo' : 'inactivo',
          purchasePrice: costoUnitario,
          salePrice: precioVenta,
          markupPercent: null,
          ivaPercent: (p['iva_detalle']?['valor_impuesto'] as num?)?.toDouble(),
          batches: batches,
        );
      }).toList();
    } catch (e) {
      error = 'Error al conectar con el servidor: $e';
      _products = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
