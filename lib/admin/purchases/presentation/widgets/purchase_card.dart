import 'package:flutter/material.dart';
import '../../data/models/purchase_model.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;
  final VoidCallback onTap;

  const PurchaseCard({super.key, required this.purchase, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Leading avatar with first letter of supplier
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // Avoid deprecated withOpacity() - use Color.fromRGBO to set opacity
                  color: const Color.fromRGBO(0, 200, 83, 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    purchase.proveedor?.nombre.isNotEmpty == true
                        ? purchase.proveedor!.nombre[0].toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.proveedor?.nombre ?? 'Proveedor',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${purchase.id} • ${purchase.fechaCompra.toLocal().toString().split(" ").first}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                  const SizedBox(height: 8),
                  Text(
                    '\$${purchase.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF00C853),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
