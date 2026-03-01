import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: const Color(0xFF0A7A5A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Módulo de categorías habilitado por permisos',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
