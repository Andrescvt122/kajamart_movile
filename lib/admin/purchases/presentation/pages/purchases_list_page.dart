import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/purchases_remote_data_source.dart';
import '../../data/repositories/purchases_repository_impl.dart';
import '../providers/purchases_notifier.dart';
import '../widgets/purchase_card.dart';
import 'purchase_detail_page.dart';

class PurchasesListPage extends StatelessWidget {
  const PurchasesListPage({super.key});

  static PurchasesRepositoryImpl createPurchasesRepository() {
    const String baseUrl = 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api';
    return PurchasesRepositoryImpl(
      remote: PurchasesRemoteDataSource(baseUrl: baseUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PurchasesNotifier(repository: createPurchasesRepository())
            ..loadPurchases(),
      child: const _PurchasesModuleScaffold(),
    );
  }
}

class _PurchasesModuleScaffold extends StatefulWidget {
  const _PurchasesModuleScaffold();

  @override
  State<_PurchasesModuleScaffold> createState() =>
      _PurchasesModuleScaffoldState();
}

class _PurchasesModuleScaffoldState extends State<_PurchasesModuleScaffold> {
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
        child: Consumer<PurchasesNotifier>(
          builder: (context, notifier, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
                  child: Text(
                    'Compras',
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
                    'Listado de compras',
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
                      hintText: 'Buscar compras...',
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
                const Expanded(child: _PurchasesContent()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PurchasesNotifier>().loadPurchases(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _PurchasesContent extends StatelessWidget {
  const _PurchasesContent();

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<PurchasesNotifier>(context);

    switch (notifier.status) {
      case PurchasesStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF00C853)),
        );
      case PurchasesStatus.error:
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
      case PurchasesStatus.loaded:
        if (notifier.filteredPurchases.isEmpty) {
          return const Center(child: Text('No se encontraron compras'));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
          itemCount: notifier.filteredPurchases.length,
          itemBuilder: (context, index) {
            final purchase = notifier.filteredPurchases[index];
            return PurchaseCard(
              purchase: purchase,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PurchaseDetailPage(purchase: purchase),
                ),
              ),
            );
          },
        );
      case PurchasesStatus.initial:
        return const SizedBox.shrink();
    }
  }
}

Widget createPurchasesProviderWidget() {
  return ChangeNotifierProvider(
    create: (_) => PurchasesNotifier(
      repository: PurchasesRepositoryImpl(
        remote: PurchasesRemoteDataSource(
          baseUrl: 'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api',
        ),
      ),
    )..loadPurchases(),
    child: const _PurchasesModuleScaffold(),
  );
}
