import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Usamos este import solo para el modelo Product
import 'package:kajamart_movile/client/screens/product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // URL de tu backend
  static const String _productsUrl =
      'http://localhost:3000/kajamart/api/products/all';

  List<Product> _products = <Product>[];
  bool _isLoading = true;
  String? _errorMessage;

  // 🔹 Estado para filtros/diseño
  String searchQuery = "";
  String sortOption = "Relevancia";
  String statusFilter = "Todos";
  bool isPriceAsc = true; // controla la dirección del orden de precio

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.parse(_productsUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final List<dynamic>? productsData = decoded is List
            ? decoded
            : (decoded is Map<String, dynamic> && decoded['data'] is List)
            ? decoded['data'] as List<dynamic>
            : null;

        if (productsData != null) {
          final List<Product> loadedProducts = productsData
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();

          setState(() {
            _products = loadedProducts;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Formato de respuesta inválido.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error ${response.statusCode}: no se pudo cargar los productos.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al conectar con el servidor: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(136, 135, 234, 129),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: "Buscar en Kajamart...",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      // En error sí retornamos directo (no tiene sentido mostrar filtros)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              const Text(
                'Ocurrió un error al cargar los productos',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchProducts,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // 🔹 Filtrar productos usando tu modelo Product
    List<Product> filteredProducts = _products.where((product) {
      final name = product.name.toLowerCase();
      final category = (product.categoryName ?? '').toLowerCase();
      final query = searchQuery.toLowerCase();

      final matchesSearch = name.contains(query) || category.contains(query);

      final statusLabel = product.statusLabel.toLowerCase();
      final matchesStatus =
          statusFilter == "Todos" || statusLabel == statusFilter.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();

    // 🔹 Ordenar
    if (sortOption.toLowerCase() == "precio") {
      filteredProducts.sort((a, b) {
        final aPrice = a.price ?? 0;
        final bPrice = b.price ?? 0;
        return isPriceAsc ? aPrice.compareTo(bPrice) : bPrice.compareTo(aPrice);
      });
    }

    // 🔹 SIEMPRE devolvemos Column con filtros + área de lista
    return Column(
      children: [
        // Barra de filtros
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          tween: Tween<double>(begin: -50, end: 0),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: Opacity(opacity: 1 - (value.abs() / 50), child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: buildChip("Relevancia", isSort: true)),
                const SizedBox(width: 6),
                Expanded(child: buildPriceChip()),
                const SizedBox(width: 6),
                Expanded(child: buildChip("Activo", isSort: false)),
                const SizedBox(width: 6),
                Expanded(child: buildChip("Inactivo", isSort: false)),
              ],
            ),
          ),
        ),

        // Lista / Grid de productos
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    'No hay productos que coincidan con los filtros.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: GridView.builder(
                    key: ValueKey(filteredProducts.length),
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.6,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOut,
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 40 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        // 👇 Sin navegación a detalles: solo el card
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Imagen
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: _buildProductImage(product),
                                ),
                              ),
                              // Info
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.priceLabel,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.statusLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: product.statusLabel == "Activo"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    if (product.categoryName != null &&
                                        product.categoryName!
                                            .trim()
                                            .isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        product.categoryName!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product) {
    final String? url = product.imageUrl;
    final bool hasImage = url != null && url.isNotEmpty;

    if (!hasImage) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: Colors.grey.shade200,
          child: const Center(child: Icon(Icons.image_not_supported)),
        );
      },
    );
  }

  // 🔹 Chips de filtros
  Widget buildChip(String label, {bool isSort = true}) {
    bool isSelected = isSort
        ? sortOption.toLowerCase() == label.toLowerCase()
        : statusFilter.toLowerCase() == label.toLowerCase();

    return FilterChip(
      label: Center(child: Text(label)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (isSort) {
            sortOption = label;
          } else {
            // Si ya estaba seleccionado, se resetea a "Todos"
            statusFilter = isSelected ? "Todos" : label;
          }
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.green.shade100,
      checkmarkColor: Colors.green,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget buildPriceChip() {
    bool isSelected = sortOption.toLowerCase() == "precio";

    return FilterChip(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text("Precio"),
          if (isSelected)
            Icon(
              isPriceAsc ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
              color: Colors.green,
            ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (isSelected) {
            // ya estaba seleccionada -> cambiar dirección
            isPriceAsc = !isPriceAsc;
          } else {
            // se selecciona por primera vez
            sortOption = "precio";
            isPriceAsc = true;
          }
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: const Color.fromARGB(255, 255, 255, 255),
      checkmarkColor: Colors.green,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
