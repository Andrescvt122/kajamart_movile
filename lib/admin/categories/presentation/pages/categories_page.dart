import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/categories_remote_data_source.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../providers/categories_notifier.dart';
import '../widgets/category_card.dart';
import 'category_detail_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static CategoriesRepositoryImpl createCategoriesRepository() {
    const String baseUrl = 'http://localhost:3000/kajamart/api';
    return CategoriesRepositoryImpl(
      remote: CategoriesRemoteDataSource(baseUrl: baseUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CategoriesNotifier(repository: createCategoriesRepository())
            ..loadCategories(),
      child: const _CategoriesModuleScaffold(),
    );
  }
}

class _CategoriesModuleScaffold extends StatefulWidget {
  const _CategoriesModuleScaffold();

  @override
  State<_CategoriesModuleScaffold> createState() =>
      _CategoriesModuleScaffoldState();
}

class _CategoriesModuleScaffoldState extends State<_CategoriesModuleScaffold> {
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
      backgroundColor: const Color(0xFFE4EFE8),
      body: SafeArea(
        child: Consumer<CategoriesNotifier>(
          builder: (context, notifier, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
                  child: Text(
                    'Categorias',
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
                    'Listado de categorias',
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
                      hintText: 'Buscar categorias...',
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
                const Divider(height: 1),
                const Expanded(child: _CategoriesContent()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CategoriesNotifier>().loadCategories(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CategoriesNotifier>();

    switch (notifier.status) {
      case CategoriesStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF00C853)),
        );
      case CategoriesStatus.error:
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
      case CategoriesStatus.loaded:
        if (notifier.filteredCategories.isEmpty) {
          return const Center(child: Text('No se encontraron categorias'));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
          itemCount: notifier.filteredCategories.length,
          itemBuilder: (context, index) {
            final category = notifier.filteredCategories[index];
            return CategoryCard(
              category: category,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryDetailPage(category: category),
                ),
              ),
            );
          },
        );
      case CategoriesStatus.initial:
        return const SizedBox.shrink();
    }
  }
}
