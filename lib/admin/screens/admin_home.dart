import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
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

  final List<String> _titles = [
    'Productos',
    'Proveedores',
    'Ventas',
    'Compras',
    'Clientes',
    'Ver mi perfil',
    'Salir',
  ];

  void _handleLogout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildScreenContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 6) {
            // Logout - navegar al login
            _handleLogout();
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Proveedores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Ventas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    const screensWithOwnAppBar = {0, 1, 2, 3, 4, 5};

    if (screensWithOwnAppBar.contains(_selectedIndex)) {
      return null;
    }

    return AppBar(
      title: Text(
        _titles[_selectedIndex],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppConstants.primaryColor,
      elevation: 0,
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