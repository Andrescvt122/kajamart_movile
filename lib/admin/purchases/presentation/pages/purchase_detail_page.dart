import 'package:flutter/material.dart';

import '../../data/models/purchase_model.dart';

class PurchaseDetailPage extends StatelessWidget {
  final PurchaseModel purchase;
  static const Color _primaryGreen = Color(0xFF0A7A5A);

  const PurchaseDetailPage({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final isCompleted = purchase.estadoCompra.toLowerCase().contains('complet');
    final supplierName = purchase.proveedor?.nombre ?? 'Proveedor';
    final dateLabel = purchase.fechaCompra.toLocal().toString().split(' ').first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Compra'),
        backgroundColor: _primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplierName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Factura: #${purchase.id}'),
                          const SizedBox(height: 6),
                          Text('Fecha: $dateLabel'),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subtotal',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          '\$${purchase.subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color.fromRGBO(0, 200, 83, 0.12)
                                : const Color.fromRGBO(158, 158, 158, 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            purchase.estadoCompra,
                            style: TextStyle(
                              color: isCompleted ? _primaryGreen : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Productos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (purchase.detalleCompra.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Esta compra no tiene productos para mostrar.'),
                ),
              )
            else
              ...purchase.detalleCompra.map(_buildLineItem),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _summaryRow('Subtotal', purchase.subtotal),
                    const SizedBox(height: 8),
                    _summaryRow('Impuestos', purchase.totalImpuestos),
                    const Divider(height: 20),
                    _summaryRow('Total', purchase.total, isStrong: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(PurchaseDetailModel detail) {
    final cantidad = detail.cantidad ?? 0;
    final precio = detail.precioUnitario ?? 0.0;
    final subtotal = detail.subtotal ?? (precio * cantidad);
    final productName =
        detail.nombreProducto ?? 'Producto #${detail.idProducto ?? '-'}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _chip('Cant: $cantidad'),
                _chip('P/U: \$${precio.toStringAsFixed(0)}'),
                _chip('Subtotal: \$${subtotal.toStringAsFixed(0)}'),
                if (detail.idDetalleProducto != null)
                  _chip('Detalle: ${detail.idDetalleProducto}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double amount, {bool isStrong = false}) {
    final style = TextStyle(
      fontWeight: isStrong ? FontWeight.bold : FontWeight.w500,
      fontSize: isStrong ? 16 : 14,
      color: isStrong ? _primaryGreen : null,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${amount.toStringAsFixed(0)}', style: style),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
