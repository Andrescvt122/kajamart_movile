import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/customers_remote_data_source.dart';
import '../../data/repositories/customers_repository_impl.dart';
import '../../domain/repositories/customers_repository.dart';
import '../providers/customers_notifier.dart';
import '../widgets/customer_card.dart';
import 'customer_detail_page.dart';
import 'package:kajamart_movile/admin/constants/app_constants.dart';

/// Página principal del módulo de clientes (ruta dedicada '/clientes').
class CustomersListPage extends StatelessWidget {
  const CustomersListPage({super.key});

  CustomersRepository _buildRepository() {
    // URL del backend en Azure: https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients
    const String baseUrl = 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api';
    const String customersEndpoint = '/clients';

    // El data source maneja fallback/mocks y errores de CORS en web.
    return CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSource(
        baseUrl: baseUrl,
        customersEndpoint: customersEndpoint,
      ),
      useMockData: false,
    );
  }

  /// Helper público para reutilizar la misma configuración del repositorio
  /// desde otras pantallas (por ejemplo `AdminHomeScreen`).
  static CustomersRepository createCustomersRepository() {
    const String baseUrl = 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api';
    const String customersEndpoint = '/clients';

    return CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSource(
        baseUrl: baseUrl,
        customersEndpoint: customersEndpoint,
      ),
      useMockData: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CustomersNotifier(repository: _buildRepository())..loadCustomers(),
      child: const _CustomersListView(),
    );
  }
}

/// Vista principal de la lista de clientes con búsqueda y filtrado.
class _CustomersListView extends StatefulWidget {
  const _CustomersListView();

  @override
  State<_CustomersListView> createState() => _CustomersListViewState();
}

class _CustomersListViewState extends State<_CustomersListView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

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
          backgroundColor: const Color(0xFFFFFFFF),
          appBar: AppBar(
            backgroundColor: const Color(
              0xFFE8F5E9,
            ), // soft green like screenshot
            elevation: 0,
            title: const Text('Clientes'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Color(0xFF1F1F1F),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          body: CustomersListEmbedBody(searchController: _searchController),
        );
      },
    );
  }
}

/// Widget reutilizable que contiene SOLO el body de la lista de clientes
/// (sin Scaffold). Esto permite incrustarlo dentro de `AdminHomeScreen`.
class CustomersListEmbedBody extends StatelessWidget {
  final TextEditingController searchController;
  final bool showSearchAndFilters;

  const CustomersListEmbedBody({
    super.key,
    required this.searchController,
    this.showSearchAndFilters = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersNotifier>(
      builder: (context, notifier, _) {
        return Column(
          children: [
            if (showSearchAndFilters) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o documento...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF00C853),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              notifier.filterByQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00C853)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) => notifier.filterByQuery(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${notifier.filteredCustomers.length} ${notifier.filteredCustomers.length == 1 ? 'cliente' : 'clientes'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // No mostrar botón de recarga aquí (pide el usuario).
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(child: _EmbedContent()),
          ],
        );
      },
    );
  }
}

class _EmbedContent extends StatelessWidget {
  const _EmbedContent({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<CustomersNotifier>(context);

    switch (notifier.status) {
      case CustomersStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00C853)),
              const SizedBox(height: 12),
              Text(
                'Cargando clientes...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      case CustomersStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar clientes',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  notifier.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[400], fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: notifier.loadCustomers,
                ),
              ],
            ),
          ),
        );
      case CustomersStatus.loaded:
        if (notifier.filteredCustomers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'No se encontraron clientes',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: notifier.filteredCustomers.length,
          itemBuilder: (context, index) {
            final customer = notifier.filteredCustomers[index];
            return CustomerCard(
              customer: customer,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerDetailPage(customer: customer),
                ),
              ),
            );
          },
        );
      case CustomersStatus.initial:
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Crea un ChangeNotifierProvider listo para insertar en otras pantallas.
Widget createCustomersProviderWidget() {
  return ChangeNotifierProvider(
    create: (_) => CustomersNotifier(
      repository: CustomersListPage.createCustomersRepository(),
    )..loadCustomers(),
    child: const CustomersListEmbedWrapper(),
  );
}

/// Wrapper que mantiene el controlador de búsqueda para el embed.
class CustomersListEmbedWrapper extends StatefulWidget {
  const CustomersListEmbedWrapper({super.key});

  @override
  State<CustomersListEmbedWrapper> createState() =>
      _CustomersListEmbedWrapperState();
}

class _CustomersListEmbedWrapperState extends State<CustomersListEmbedWrapper> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5E9), // soft green
        elevation: 0,
        title: const Text('Clientes'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color(0xFF1F1F1F),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: _EmbeddedCustomersScreen(searchController: _searchController),
    );
  }
}

class _EmbeddedCustomersScreen extends StatefulWidget {
  final TextEditingController searchController;

  const _EmbeddedCustomersScreen({super.key, required this.searchController});

  @override
  State<_EmbeddedCustomersScreen> createState() =>
      _EmbeddedCustomersScreenState();
}

class _EmbeddedCustomersScreenState extends State<_EmbeddedCustomersScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Activos', 'Inactivos'];

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<CustomersNotifier>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: widget.searchController,
            onChanged: (value) => notifier.filterByQuery(value),
            decoration: InputDecoration(
              hintText: 'Buscar cliente...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00C853)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00C853)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = filter == _selectedFilter;
              return ChoiceChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF00C853),
                backgroundColor: const Color(0xFFE8F5E9),
                onSelected: (_) {
                  setState(() => _selectedFilter = filter);
                  notifier.setStatusFilter(filter);
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: CustomersListEmbedBody(
            searchController: widget.searchController,
            showSearchAndFilters: false,
          ),
        ),
      ],
    );
  }
}
