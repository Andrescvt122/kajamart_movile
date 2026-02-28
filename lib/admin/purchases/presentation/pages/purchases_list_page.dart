import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/purchases_remote_data_source.dart';
import '../../data/repositories/purchases_repository_impl.dart';
import '../providers/purchases_notifier.dart';
import '../widgets/purchase_card.dart';
import 'purchase_detail_page.dart';

/// Página principal de Compras (también exporta un widget embebible)
class PurchasesListPage extends StatelessWidget {
  const PurchasesListPage({super.key});

  static PurchasesRepositoryImpl createPurchasesRepository() {
    const String baseUrl = 'http://localhost:3000/kajamart/api';
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
      child: const _PurchasesListView(),
    );
  }
}

class _PurchasesListView extends StatefulWidget {
  const _PurchasesListView();

  @override
  State<_PurchasesListView> createState() => _PurchasesListViewState();
}

class _PurchasesListViewState extends State<_PurchasesListView> {
  late TextEditingController _searchController;

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
    return Consumer<PurchasesNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFE4EFE8),
          body: SafeArea(
            child: PurchasesListEmbedBody(searchController: _searchController),
          ),
        );
      },
    );
  }
}

class PurchasesListEmbedBody extends StatelessWidget {
  final TextEditingController searchController;
  final bool showSearchAndFilters;

  const PurchasesListEmbedBody({
    super.key,
    required this.searchController,
    this.showSearchAndFilters = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchasesNotifier>(
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
            if (showSearchAndFilters) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar compras...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF9AA8A2),
                    ),
                    hintStyle: const TextStyle(color: Color(0xFF95A39D)),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (v) => notifier.filterByQuery(v),
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
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final labels = ['Todos', 'Completadas', 'Anuladas'];
                    final label = labels[index];
                    final isSelected =
                        (index == 0 &&
                            notifier.filteredPurchases == notifier.purchases) ||
                        (index == 1 &&
                            notifier.filteredPurchases.any(
                              (p) => p.estadoCompra.toLowerCase().contains(
                                'complet',
                              ),
                            )) ||
                        (index == 2 &&
                            notifier.filteredPurchases.any(
                              (p) => p.estadoCompra.toLowerCase().contains(
                                'anulad',
                              ),
                            ));
                    return ChoiceChip(
                      label: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: false,
                      selectedColor: const Color(0xFF00C853),
                      backgroundColor: const Color(0xFFE8F5E9),
                      onSelected: (_) => notifier.setStateFilter(label),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
            ],
            Expanded(child: _PurchasesContent()),
          ],
        );
      },
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
        return Center(child: Text('Error: ${notifier.errorMessage}'));
      case PurchasesStatus.loaded:
        if (notifier.filteredPurchases.isEmpty) {
          return Center(child: Text('No se encontraron compras'));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
          itemCount: notifier.filteredPurchases.length,
          itemBuilder: (context, index) {
            final p = notifier.filteredPurchases[index];
            return PurchaseCard(
              purchase: p,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PurchaseDetailPage(purchase: p),
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

/// Crea un ChangeNotifierProvider listo para insertar en AdminHome
Widget createPurchasesProviderWidget() {
  return ChangeNotifierProvider(
    create: (_) => PurchasesNotifier(
      repository: PurchasesRepositoryImpl(
        remote: PurchasesRemoteDataSource(
          baseUrl: 'http://localhost:3000/kajamart/api',
        ),
      ),
    )..loadPurchases(),
    child: const _PurchasesEmbedWrapper(),
  );
}

class _PurchasesEmbedWrapper extends StatefulWidget {
  const _PurchasesEmbedWrapper();

  @override
  State<_PurchasesEmbedWrapper> createState() => _PurchasesEmbedWrapperState();
}

class _PurchasesEmbedWrapperState extends State<_PurchasesEmbedWrapper> {
  late TextEditingController _searchController;

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
    // Scaffold styled like Products/Customers
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      body: SafeArea(
        child: _EmbeddedPurchasesScreen(searchController: _searchController),
      ),
    );
  }
}

class _EmbeddedPurchasesScreen extends StatefulWidget {
  final TextEditingController searchController;
  const _EmbeddedPurchasesScreen({required this.searchController});

  @override
  State<_EmbeddedPurchasesScreen> createState() =>
      _EmbeddedPurchasesScreenState();
}

class _EmbeddedPurchasesScreenState extends State<_EmbeddedPurchasesScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Completadas', 'Anuladas'];

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<PurchasesNotifier>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: widget.searchController,
            onChanged: (v) => notifier.filterByQuery(v),
            decoration: InputDecoration(
              hintText: 'Buscar compras...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA8A2)),
              hintStyle: const TextStyle(color: Color(0xFF95A39D)),
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
                  notifier.setStateFilter(filter);
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: PurchasesListEmbedBody(
            searchController: widget.searchController,
            showSearchAndFilters: false,
          ),
        ),
      ],
    );
  }
}
