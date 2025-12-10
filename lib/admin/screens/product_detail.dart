// lib/admin/screens/product_detail.dart
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../models/batch.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.textDarkColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppConstants.textLightColor),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Parámetros inválidos para detalle')),
      );
    }

    final Product product = args['product'] as Product;
    final Batch batch = args['batch'] as Batch;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.secondaryColor,
        elevation: 0,
        title: Text(
          'Detalle - ${product.name}',
          style: TextStyle(
            color: AppConstants.textDarkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image,
                    size: 80,
                    color: AppConstants.textLightColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Info general
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('Producto ID', product.id),
                    _row('Nombre', product.name),
                    _row('Categoría', product.category),
                    _row('Código de barras', batch.barcode),
                  ],
                ),
              ),
            ),

            // Precios
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row(
                      'Precio Compra',
                      product.purchasePrice != null
                          ? '\$${product.purchasePrice!.toStringAsFixed(0)}'
                          : '—',
                    ),
                    _row(
                      'Precio Venta',
                      product.salePrice != null
                          ? '\$${product.salePrice!.toStringAsFixed(0)}'
                          : '—',
                    ),
                    _row(
                      'Precio lote',
                      '\$${batch.price.toStringAsFixed(0)}',
                    ),
                    _row(
                      'IVA',
                      product.ivaPercent != null
                          ? '${product.ivaPercent}%'
                          : '—',
                    ),
                  ],
                ),
              ),
            ),

            // Stock / lote
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row(
                      'Fecha de vencimiento',
                      _formatDate(batch.expiryDate),
                    ),
                    _row('Cantidad en lote', batch.quantity.toString()),
                    _row('Consumido', batch.consumedStock.toString()),
                    _row('Stock total producto',
                        product.currentStock.toString()),
                    _row('Stock mín', product.minStock.toString()),
                    _row('Stock máx', product.maxStock.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
