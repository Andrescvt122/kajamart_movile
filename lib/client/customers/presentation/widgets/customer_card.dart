import 'package:flutter/material.dart';

import '../../domain/entities/customer.dart';

/// Widget que representa una tarjeta visual de un cliente.
/// Muestra información resumida y es navegable hacia el detalle.
class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer, required this.onTap});

  final Customer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del cliente con icono
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        customer.nombre.isNotEmpty
                            ? customer.nombre[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 20,
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
                          customer.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${customer.tipoDocumento}: ${customer.numeroDocumento}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Estado del cliente (activo/inactivo) y chevron
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: customer.estado
                              ? Colors.green.withOpacity(0.12)
                              : Colors.grey.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          customer.estado ? 'Activo' : 'Inactivo',
                          style: TextStyle(
                            color: customer.estado ? Colors.green : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300], height: 1),
              const SizedBox(height: 12),
              // Información de contacto en dos columnas
              Row(
                children: [
                  Expanded(
                    child: _ContactInfo(
                      icon: Icons.phone_outlined,
                      label: 'Teléfono',
                      value: customer.telefono,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ContactInfo(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: customer.email,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget auxiliar para mostrar información de contacto.
class _ContactInfo extends StatelessWidget {
  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF00C853)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
