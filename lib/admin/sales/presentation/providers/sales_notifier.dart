import 'package:flutter/material.dart';

import '../../data/models/sale_model.dart';
import '../../data/repositories/sales_repository_impl.dart';

enum SalesStatus { initial, loading, loaded, error }

class SalesNotifier extends ChangeNotifier {
  final SalesRepositoryImpl repository;

  SalesStatus status = SalesStatus.initial;
  List<SaleModel> sales = [];
  List<SaleModel> filteredSales = [];
  String errorMessage = '';

  String _lastQuery = '';
  String _stateFilter = 'Todos';

  SalesNotifier({required this.repository});

  Future<void> loadSales() async {
    status = SalesStatus.loading;
    notifyListeners();
    try {
      sales = await repository.getSales(useMock: false);
      filteredSales = sales;
      status = SalesStatus.loaded;
    } catch (e) {
      status = SalesStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void filterByQuery(String q) {
    _lastQuery = q.trim();
    _applyFilters();
  }

  void setStateFilter(String state) {
    _stateFilter = state;
    _applyFilters();
  }

  void _applyFilters() {
    final q = _lastQuery.toLowerCase();
    List<SaleModel> list = sales;

    if (_stateFilter == 'Completadas') {
      list = list
          .where((s) => s.estadoVenta.toLowerCase().contains('complet'))
          .toList();
    } else if (_stateFilter == 'Anuladas') {
      list = list
          .where((s) => s.estadoVenta.toLowerCase().contains('anulad'))
          .toList();
    }

    if (q.isNotEmpty) {
      list = list.where((s) {
        final cliente = s.cliente?.nombre.toLowerCase() ?? '';
        final id = s.id.toLowerCase();
        return cliente.contains(q) || id.contains(q);
      }).toList();
    }

    filteredSales = list;
    notifyListeners();
  }
}
