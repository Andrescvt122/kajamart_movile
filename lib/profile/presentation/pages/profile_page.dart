import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = context.read<AuthNotifier>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFF0A7A5A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('No se pudo cargar el perfil: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? {};
          final acceso = data['acceso'] as Map<String, dynamic>? ?? {};
          final rol = acceso['roles'] as Map<String, dynamic>? ?? {};

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _tile('Nombre', '${data['nombre'] ?? ''} ${data['apellido'] ?? ''}'.trim()),
              _tile('Correo', acceso['email']?.toString() ?? '-'),
              _tile('Documento', data['documento']?.toString() ?? '-'),
              _tile('Teléfono', data['telefono']?.toString() ?? '-'),
              _tile('Rol', rol['rol_nombre']?.toString().trim() ?? '-'),
            ],
          );
        },
      ),
    );
  }

  Widget _tile(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value.isEmpty ? '-' : value),
      ),
    );
  }
}
