import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/sales_remote_data_source.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../providers/sales_notifier.dart';
import '../widgets/sale_card.dart';
import 'sale_detail_page.dart';

class SalesListPage extends StatelessWidget {
  const SalesListPage({super.key});

  static SalesRepositoryImpl createSalesRepository() {
    const String baseUrl = 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api';
    return SalesRepositoryImpl(remote: SalesRemoteDataSource(baseUrl: baseUrl));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          SalesNotifier(repository: createSalesRepository())..loadSales(),
      child: const _SalesModuleScaffold(),
    );
  }
}

class _SalesModuleScaffold extends StatefulWidget {
  const _SalesModuleScaffold();

  @override
  State<_SalesModuleScaffold> createState() => _SalesModuleScaffoldState();
}

class _SalesModuleScaffoldState extends State<_SalesModuleScaffold> {
  late final TextEditingController _searchController;
  String _selectedFilter = 'Todos';

  final List<String> _filters = const ['Todos', 'Completadas', 'Anuladas'];

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
      backgroundColor: const Color(0xFFE4EFE8),
      body: SafeArea(
        child: Consumer<SalesNotifier>(
          builder: (context, notifier, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
                  child: Text(
                    'Ventas',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0E6E54),
                      height: 0.95,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 0, 18, 14),
                  child: Text(
                    'Listado de ventas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF677A70),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                  child: TextField(
                    controller: _searchController,
                    onChanged: notifier.filterByQuery,
                    decoration: InputDecoration(
                      hintText: 'Buscar ventas...',
                      hintStyle: const TextStyle(color: Color(0xFF95A39D)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9AA8A2),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF0F2F1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Color(0xFF0A7A5A)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return ChoiceChip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0A7A5A),
                        backgroundColor: const Color(0xFFDDECE4),
                        onSelected: (_) {
                          setState(() => _selectedFilter = filter);
                          notifier.setStateFilter(filter);
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                const Expanded(child: _SalesContent()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SalesNotifier>().loadSales(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _SalesContent extends StatelessWidget {
  const _SalesContent();

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<SalesNotifier>(context);

    switch (notifier.status) {
      case SalesStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF00C853)),
        );
      case SalesStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error: ${notifier.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      case SalesStatus.loaded:
        if (notifier.filteredSales.isEmpty) {
          return const Center(child: Text('No se encontraron ventas'));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
          itemCount: notifier.filteredSales.length,
          itemBuilder: (context, index) {
            final sale = notifier.filteredSales[index];
            return SaleCard(
              sale: sale,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SaleDetailPage(sale: sale)),
              ),
            );
          },
        );
      case SalesStatus.initial:
        return const SizedBox.shrink();
    }
  }
}

Widget createSalesProviderWidget() {
  return ChangeNotifierProvider(
    create: (_) => SalesNotifier(
      repository: SalesRepositoryImpl(
        remote: SalesRemoteDataSource(
          baseUrl: 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api',
        ),
      ),
    )..loadSales(),
    child: const _SalesModuleScaffold(),
  );
}
