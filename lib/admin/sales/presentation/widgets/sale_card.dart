import 'package:flutter/material.dart';
import '../../data/models/sale_model.dart';

class SaleCard extends StatelessWidget {
  final SaleModel sale;
  final VoidCallback onTap;

  const SaleCard({super.key, required this.sale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC6E8D5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 200, 83, 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    sale.cliente?.nombre.isNotEmpty == true
                        ? sale.cliente!.nombre[0].toUpperCase()
                        : 'V',
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
                      sale.cliente?.nombre ?? 'Cliente',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${sale.id} • ${sale.fechaVenta.toLocal().toString().split(" ").first}',
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
                      color: sale.estadoVenta.toLowerCase().contains('complet')
                          ? const Color.fromRGBO(0, 200, 83, 0.12)
                          : const Color.fromRGBO(158, 158, 158, 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      sale.estadoVenta,
                      style: TextStyle(
                        color:
                            sale.estadoVenta.toLowerCase().contains('complet')
                            ? Colors.green
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${sale.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF121B17),
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
