import 'package:flutter/material.dart';

import '../../data/models/client_model.dart';
import '../../data/repositories/clients_repository_impl.dart';

enum ClientsStatus { initial, loading, loaded, error }

class ClientsNotifier extends ChangeNotifier {
  final ClientsRepositoryImpl repository;

  ClientsStatus status = ClientsStatus.initial;
  List<AdminClientModel> clients = [];
  List<AdminClientModel> filteredClients = [];
  String errorMessage = '';
  String _searchQuery = '';

  ClientsNotifier({required this.repository});

  Future<void> loadClients() async {
    status = ClientsStatus.loading;
    notifyListeners();
    try {
      clients = await repository.getClients(useMock: false);
      filteredClients = clients;
      status = ClientsStatus.loaded;
    } catch (e) {
      status = ClientsStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void filterByQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      filteredClients = clients;
    } else {
      filteredClients = clients.where((c) {
        return c.nombre.toLowerCase().contains(_searchQuery) ||
            c.numeroDocumento.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }
}
