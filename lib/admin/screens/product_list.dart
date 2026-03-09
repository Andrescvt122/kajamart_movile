import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductService _productService;

  String _selectedFilter = 'Todos';
  String _searchQuery = '';

  List<String> get filters => ['Todos', 'Activos', 'Inactivos', 'Stock bajo'];

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _productService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _productService.removeListener(_onServiceChanged);
    super.dispose();
  }

  List<Product> get filteredProducts {
    List<Product> list;
    final products = _productService.products;

    switch (_selectedFilter) {
      case 'Activos':
        list = products.where((p) => p.status.toLowerCase() == 'activo').toList();
        break;
      case 'Inactivos':
        list = products.where((p) => p.status.toLowerCase() != 'activo').toList();
        break;
      case 'Stock bajo':
        list = products.where((p) => p.currentStock <= p.minStock).toList();
        break;
      default:
        list = products;
    }

    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.category.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _productService.isLoading;
    final error = _productService.error;

    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
              child: Text(
                'Productos',
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
                'Listado de productos',
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
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  hintStyle: const TextStyle(color: Color(0xFF95A39D)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA8A2)),
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
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = filter == _selectedFilter;
                  return ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppConstants.textDarkColor,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0A7A5A),
                    backgroundColor: const Color(0xFFDDECE4),
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          error,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  if (filteredProducts.isEmpty) {
                    return const Center(child: Text('No hay productos para mostrar'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
                    itemCount: filteredProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final p = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/batches',
                          arguments: p,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFC6E8D5)),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                ),
                                child: Image.network(
                                  p.imageUrl,
                                  width: 92,
                                  height: 92,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 92,
                                    height: 92,
                                    color: AppConstants.secondaryColor,
                                    child: Icon(
                                      Icons.image,
                                      color: AppConstants.textLightColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF121B17),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        p.category,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppConstants.textLightColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Stock: ${p.currentStock} • \$${p.price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p.status.toLowerCase() == 'activo'
                                        ? const Color(0xFFDDF3E6)
                                        : const Color(0xFFEDEDED),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    p.status,
                                    style: TextStyle(
                                      color: p.status.toLowerCase() == 'activo'
                                          ? const Color(0xFF1A7F4D)
                                          : const Color(0xFF69756F),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _productService.fetchProducts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
