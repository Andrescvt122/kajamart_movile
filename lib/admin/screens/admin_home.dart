import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/models/auth_session.dart';
import '../../auth/presentation/providers/auth_notifier.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../categories/presentation/pages/categories_page.dart';
import '../clients/presentation/pages/clients_list_page.dart';
import '../purchases/presentation/pages/purchases_list_page.dart';
import '../sales/presentation/pages/sales_list_page.dart';
import 'product_list.dart';
import 'provider_list.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.session});

  final AuthSession session;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  late final List<_MenuModule> _modules;

  @override
  void initState() {
    super.initState();
    _modules = _buildModules(widget.session);
  }

  @override
  Widget build(BuildContext context) {
    if (_modules.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFE4EFE8),
        appBar: AppBar(
          title: const Text('Kajamart móvil'),
          backgroundColor: const Color(0xFF0A7A5A),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => context.read<AuthNotifier>().logout(),
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: const Center(
          child: Text('Tu rol no tiene permisos para módulos móviles.'),
        ),
      );
    }

    final safeIndex = _selectedIndex >= _modules.length ? 0 : _selectedIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      appBar: AppBar(
        title: Text(_modules[safeIndex].label),
        backgroundColor: const Color(0xFF0A7A5A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Mi perfil',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => context.read<AuthNotifier>().logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _modules[safeIndex].builder(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF0A7A5A),
          unselectedItemColor: const Color(0xFF809487),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: _modules
              .map(
                (m) => BottomNavigationBarItem(
                  icon: Icon(m.icon),
                  activeIcon: Icon(m.activeIcon),
                  label: m.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<_MenuModule> _buildModules(AuthSession session) {
    final modules = <_MenuModule>[];

    if (session.hasPermission('ver productos')) {
      modules.add(
        _MenuModule(
          label: 'Productos',
          icon: Icons.inventory_2_outlined,
          activeIcon: Icons.inventory_2,
          builder: () => const ProductListScreen(),
        ),
      );
    }

    if (session.hasPermission('ver proveedores')) {
      modules.add(
        _MenuModule(
          label: 'Proveedores',
          icon: Icons.storefront_outlined,
          activeIcon: Icons.storefront,
          builder: () => const ProviderListScreen(),
        ),
      );
    }

    if (session.hasPermission('ver ventas')) {
      modules.add(
        _MenuModule(
          label: 'Ventas',
          icon: Icons.point_of_sale_outlined,
          activeIcon: Icons.point_of_sale,
          builder: createSalesProviderWidget,
        ),
      );
    }

    if (session.hasPermission('ver compras')) {
      modules.add(
        _MenuModule(
          label: 'Compras',
          icon: Icons.shopping_bag_outlined,
          activeIcon: Icons.shopping_bag,
          builder: createPurchasesProviderWidget,
        ),
      );
    }

    if (session.hasPermission('ver clientes')) {
      modules.add(
        _MenuModule(
          label: 'Clientes',
          icon: Icons.people_alt_outlined,
          activeIcon: Icons.people_alt,
          builder: createClientsProviderWidget,
        ),
      );
    }

    if (session.hasPermission('ver categorias')) {
      modules.add(
        _MenuModule(
          label: 'Categorías',
          icon: Icons.category_outlined,
          activeIcon: Icons.category,
          builder: () => const CategoriesPage(),
        ),
      );
    }

    return modules;
  }
}

class _MenuModule {
  const _MenuModule({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget Function() builder;
}
