import 'package:flutter/material.dart';

import '../../data/models/client_model.dart';

class ClientDetailPage extends StatelessWidget {
  final AdminClientModel client;

  const ClientDetailPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del cliente'),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Documento', value: '${client.tipoDocumento} ${client.numeroDocumento}'),
                  _InfoRow(label: 'Correo', value: client.correo.isNotEmpty ? client.correo : '-'),
                  _InfoRow(label: 'Teléfono', value: client.telefono.isNotEmpty ? client.telefono : '-'),
                  _InfoRow(label: 'Estado', value: client.estado.isNotEmpty ? client.estado : '-'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
