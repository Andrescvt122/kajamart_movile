import 'package:flutter/material.dart';
import 'product_list.dart';
import 'provider_list.dart';
import '../sales/presentation/pages/sales_list_page.dart';
import '../purchases/presentation/pages/purchases_list_page.dart';
import '../clients/presentation/pages/clients_list_page.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      body: _buildScreenContent(),
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
          currentIndex: _selectedIndex,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Proveedores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale_outlined),
              activeIcon: Icon(Icons.point_of_sale),
              label: 'Ventas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Compras',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt),
              label: 'Clientes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildProductsScreen();
      case 1:
        return _buildProvidersScreen();
      case 2:
        return _buildSalesScreen();
      case 3:
        return _buildPurchasesScreen();
      case 4:
        return _buildClientsScreen();
      case 5:
        return _buildMyProfileScreen();
      default:
        return _buildProductsScreen();
    }
  }

  Widget _buildProvidersScreen() {
    return const ProviderListScreen();
  }

  Widget _buildProductsScreen() {
    return const ProductListScreen();
  }

  Widget _buildSalesScreen() {
    return createSalesProviderWidget();
  }

  Widget _buildPurchasesScreen() {
    return createPurchasesProviderWidget();
  }

  Widget _buildClientsScreen() {
    return createClientsProviderWidget();
  }

  Widget _buildMyProfileScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: const Center(child: Text('Pantalla de perfil en construcción')),
    );
  }
}
