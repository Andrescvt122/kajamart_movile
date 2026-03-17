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
  String _stateFilter = 'Todos';

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

  void setStateFilter(String state) {
    _stateFilter = state;
    _applyFilters();
  }

  bool _isActiveClient(AdminClientModel client) {
    final status = client.estado.trim().toLowerCase();
    if (status.contains('inactiv')) return false;
    return status.contains('activ');
  }

  void _applyFilters() {
    List<AdminClientModel> list = clients;

    if (_stateFilter == 'Activos') {
      list = list.where(_isActiveClient).toList();
    } else if (_stateFilter == 'Inactivos') {
      list = list.where((c) => !_isActiveClient(c)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = list.where((c) {
        return c.nombre.toLowerCase().contains(_searchQuery) ||
            c.numeroDocumento.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    filteredClients = list;
    notifyListeners();
  }
}
