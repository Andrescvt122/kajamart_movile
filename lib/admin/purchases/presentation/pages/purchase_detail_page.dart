import 'package:flutter/material.dart';
import '../../data/models/purchase_model.dart';

class PurchaseDetailPage extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseDetailPage({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Compra'),
        backgroundColor: const Color(0xFF00C853),
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
                            purchase.proveedor?.nombre ?? 'Proveedor',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Fecha: ${purchase.fechaCompra.toLocal().toString().split(' ').first}',
                          ),
                          const SizedBox(height: 6),
                          Text('ID: ${purchase.id}'),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${purchase.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C853),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                purchase.estadoCompra.toLowerCase().contains(
                                  'complet',
                                )
                                ? const Color.fromRGBO(0, 200, 83, 0.12)
                                : const Color.fromRGBO(158, 158, 158, 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            purchase.estadoCompra,
                            style: TextStyle(
                              color:
                                  purchase.estadoCompra.toLowerCase().contains(
                                    'complet',
                                  )
                                  ? Colors.green
                                  : Colors.grey,
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
              'Líneas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...purchase.detalleCompra.map((d) => _buildLineItem(d)),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${purchase.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF00C853),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(PurchaseDetailModel d) {
    final precio = d.precio ?? 0.0;
    final cantidad = d.cantidad ?? 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Producto: ${d.idProducto ?? '-'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text('Cantidad: $cantidad'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${precio.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C853),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Subtotal: \$${(precio * cantidad).toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
