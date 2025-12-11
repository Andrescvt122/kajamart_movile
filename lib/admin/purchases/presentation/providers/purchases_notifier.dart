import 'package:flutter/material.dart';

import '../../data/models/purchase_model.dart';
import '../../data/repositories/purchases_repository_impl.dart';

enum PurchasesStatus { initial, loading, loaded, error }

class PurchasesNotifier extends ChangeNotifier {
  final PurchasesRepositoryImpl repository;

  PurchasesStatus status = PurchasesStatus.initial;
  List<PurchaseModel> purchases = [];
  List<PurchaseModel> filteredPurchases = [];
  String errorMessage = '';

  String _lastQuery = '';
  String _stateFilter = 'Todos';

  PurchasesNotifier({required this.repository});

  Future<void> loadPurchases() async {
    status = PurchasesStatus.loading;
    notifyListeners();
    try {
      purchases = await repository.getPurchases(useMock: false);
      filteredPurchases = purchases;
      status = PurchasesStatus.loaded;
    } catch (e) {
      status = PurchasesStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void filterByQuery(String query) {
    _lastQuery = query.trim();
    _applyFilters();
  }

  void setStateFilter(String state) {
    _stateFilter = state;
    _applyFilters();
  }

  void _applyFilters() {
    final q = _lastQuery.toLowerCase();
    List<PurchaseModel> list = purchases;

    if (_stateFilter == 'Completadas') {
      list = list
          .where((p) => p.estadoCompra.toLowerCase().contains('complet'))
          .toList();
    } else if (_stateFilter == 'Anuladas') {
      list = list
          .where((p) => p.estadoCompra.toLowerCase().contains('anulad'))
          .toList();
    }

    if (q.isNotEmpty) {
      list = list.where((p) {
        final proveedor = p.proveedor?.nombre.toLowerCase() ?? '';
        final id = p.id.toLowerCase();
        return proveedor.contains(q) || id.contains(q);
      }).toList();
    }

    filteredPurchases = list;
    notifyListeners();
  }
}
