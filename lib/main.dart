import 'package:flutter/material.dart';
import 'admin/screens/admin_home.dart';
import 'admin/screens/provider_detail.dart';
import 'admin/screens/product_batches.dart';
import 'admin/models/provider.dart';
import 'admin/models/product.dart';

void main() {
  runApp(const KajamartApp());
}

class KajamartApp extends StatelessWidget {
  const KajamartApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00C853);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kajamart',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      // Usamos `home` en vez de `initialRoute` para asegurar una única raíz Navigator
      home: const AdminHomeScreen(),
      routes: {
        // Ruta de login temporal que apunta a la pantalla principal mientras se implementa
        '/login': (context) => const AdminHomeScreen(),
        '/admin-home': (context) => const AdminHomeScreen(),
        '/provider-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args != null && args is Provider) {
            return ProviderDetailScreen(provider: args);
          }
          return const ProviderDetailScreen();
        },
        '/batches': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args != null && args is Product) {
            return ProductBatchesScreen();
          }
          return const ProductBatchesScreen();
        },
      },
    );
  }
}
