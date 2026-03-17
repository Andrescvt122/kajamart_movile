// lib/models/product.dart
import 'batch.dart';

class Product {
  final String id; // lo manejamos como String para UI
  final String name;
  final String category;
  final String imageUrl;
  final int currentStock;
  final int minStock;
  final int maxStock;
  final double price;
  final String status;

  // Opcionales (si en tu UI los necesitas)
  final double? purchasePrice;
  final double? salePrice;
  final double? markupPercent;
  final double? ivaPercent;

  final List<Batch> batches;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.currentStock,
    required this.minStock,
    required this.maxStock,
    required this.price,
    required this.status,
    this.purchasePrice,
    this.salePrice,
    this.markupPercent,
    this.ivaPercent,
    this.batches = const [],
  });

  /// ✅ Mapea el JSON real que te devuelve Postman
  factory Product.fromJson(Map<String, dynamic> json) {
    final estado = json['estado'];
    final bool isActive =
        (estado is bool) ? estado : (estado?.toString().toLowerCase() == 'true');

    return Product(
      id: (json['id_producto'] ?? '').toString(),
      name: (json['nombre'] ?? '').toString(),
      category: (json['categoria'] ?? '').toString(), // viene directo en tu response
      imageUrl: (json['url_imagen'] ??
              'https://via.placeholder.com/150') // fallback
          .toString(),
      currentStock: _toInt(json['stock_actual']),
      minStock: _toInt(json['stock_minimo']),
      maxStock: _toInt(json['stock_maximo']),
      price: _toDouble(json['precio_venta']),
      status: isActive ? 'Activo' : 'Inactivo',

      // Opcionales
      purchasePrice: json['costo_unitario'] != null ? _toDouble(json['costo_unitario']) : null,
      salePrice: json['precio_venta'] != null ? _toDouble(json['precio_venta']) : null,
      ivaPercent: null, // en tu JSON iva viene como id o null (no porcentaje)
      markupPercent: null,

      batches: const [], // tu endpoint no manda lotes por ahora
    );
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
