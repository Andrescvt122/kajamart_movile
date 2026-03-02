import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/categories_repository_impl.dart';

enum CategoriesStatus { initial, loading, loaded, error }

class CategoriesNotifier extends ChangeNotifier {
  final CategoriesRepositoryImpl repository;

  CategoriesStatus status = CategoriesStatus.initial;
  List<CategoryModel> categories = [];
  List<CategoryModel> filteredCategories = [];
  String errorMessage = '';
  String _lastQuery = '';

  CategoriesNotifier({required this.repository});

  Future<void> loadCategories() async {
    status = CategoriesStatus.loading;
    notifyListeners();

    try {
      categories = await repository.getCategories(useMock: false);
      filteredCategories = categories;
      status = CategoriesStatus.loaded;
    } catch (e) {
      status = CategoriesStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  void filterByQuery(String query) {
    _lastQuery = query.trim().toLowerCase();
    if (_lastQuery.isEmpty) {
      filteredCategories = categories;
      notifyListeners();
      return;
    }

    filteredCategories = categories.where((category) {
      final categoryName = category.nombreCategoria.toLowerCase();
      final productNames = category.productos
          .map((product) => product.nombre.toLowerCase())
          .join(' ');
      return categoryName.contains(_lastQuery) || productNames.contains(_lastQuery);
    }).toList();

    notifyListeners();
  }
}
