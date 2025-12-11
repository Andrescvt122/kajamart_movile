import 'package:flutter/material.dart';

import '../../data/models/client_model.dart';

class ClientCard extends StatelessWidget {
  final AdminClientModel client;
  final VoidCallback onTap;

  const ClientCard({super.key, required this.client, required this.onTap});

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
              CircleAvatar(
                backgroundColor: const Color(0xFFE8F5E9),
                child: Text(
                  client.nombre.isNotEmpty ? client.nombre[0].toUpperCase() : '?',
                  style: const TextStyle(color: Color(0xFF00C853)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Documento: ${client.tipoDocumento} ${client.numeroDocumento}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: client.estado.toLowerCase().contains('activo')
                          ? const Color.fromRGBO(0, 200, 83, 0.12)
                          : const Color.fromRGBO(158, 158, 158, 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      client.estado,
                      style: TextStyle(
                        color: client.estado.toLowerCase().contains('activo')
                            ? Colors.green
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
