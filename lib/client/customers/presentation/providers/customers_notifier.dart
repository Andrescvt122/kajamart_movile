import 'package:flutter/material.dart';

import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';

enum CustomersStatus { initial, loading, loaded, error }

class CustomersNotifier extends ChangeNotifier {
  CustomersNotifier({required this.repository});

  final CustomersRepository repository;
  CustomersStatus status = CustomersStatus.initial;
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  String errorMessage = '';

  Future<void> loadCustomers() async {
    status = CustomersStatus.loading;
    notifyListeners();

    try {
      customers = await repository.getCustomers();
      filteredCustomers = customers;
      status = CustomersStatus.loaded;
    } catch (e) {
      status = CustomersStatus.error;
      errorMessage = 'No se pudieron cargar los clientes. ${e.toString()}';
    }

    notifyListeners();
  }

  void filterByQuery(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      filteredCustomers = customers;
    } else {
      filteredCustomers = customers.where((customer) {
        final nombre = customer.nombre.toLowerCase();
        final documento = customer.numeroDocumento.toLowerCase();
        return nombre.contains(normalizedQuery) ||
            documento.contains(normalizedQuery);
      }).toList();
    }

    notifyListeners();
  }
}
