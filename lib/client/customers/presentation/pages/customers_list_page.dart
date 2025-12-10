import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/customers_remote_data_source.dart';
import '../../data/repositories/customers_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';
import '../providers/customers_notifier.dart';
import '../widgets/customer_card.dart';
import 'customer_detail_page.dart';

class CustomersListPage extends StatelessWidget {
  const CustomersListPage({super.key});

  CustomersRepository _buildRepository() {
    const String baseUrl = 'https://api.tu-dominio.com';
    return CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSource(baseUrl: baseUrl),
      useMockData: true, // Cambia a false cuando tengas tu API lista.
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomersNotifier(repository: _buildRepository())
        ..loadCustomers(),
      child: const _CustomersListView(),
    );
  }
}

class _CustomersListView extends StatefulWidget {
  const _CustomersListView();

  @override
  State<_CustomersListView> createState() => _CustomersListViewState();
}

class _CustomersListViewState extends State<_CustomersListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Clientes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.home_outlined),
                onPressed: () => Navigator.pushNamed(context, '/home'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o documento...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: notifier.filterByQuery,
                ),
                const SizedBox(height: 12),
                Expanded(child: _buildContent(notifier)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(CustomersNotifier notifier) {
    switch (notifier.status) {
      case CustomersStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case CustomersStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notifier.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: notifier.loadCustomers,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      case CustomersStatus.loaded:
        if (notifier.filteredCustomers.isEmpty) {
          return const Center(child: Text('No se encontraron clientes.'));
        }
        return ListView.builder(
          itemCount: notifier.filteredCustomers.length,
          itemBuilder: (context, index) {
            final customer = notifier.filteredCustomers[index];
            return CustomerCard(
              customer: customer,
              onTap: () => _goToDetail(context, customer),
            );
          },
        );
      case CustomersStatus.initial:
      default:
        return const SizedBox.shrink();
    }
  }

  void _goToDetail(BuildContext context, Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerDetailPage(customer: customer),
      ),
    );
  }
}
