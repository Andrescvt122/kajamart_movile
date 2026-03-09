import 'package:flutter/material.dart';

import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';

/// Estados posibles del módulo de clientes.
/// - initial: Estado inicial, antes de cargar datos.
/// - loading: Se está cargando la lista de clientes.
/// - loaded: Los datos se cargaron exitosamente.
/// - error: Ocurrió un error durante la carga.
enum CustomersStatus { initial, loading, loaded, error }

/// Notificador que gestiona el estado de la lista de clientes.
/// Maneja la carga, filtrado y errores usando ChangeNotifier (Provider pattern).
///
/// Por qué se usa ChangeNotifier (Provider):
/// - Es simple y eficiente para estados moderados.
/// - Se integra bien con Flutter sin dependencias externas complejas.
/// - Ideal para CRUD de lectura simple.
/// - Menos boilerplate que Bloc pero más control que setState.
class CustomersNotifier extends ChangeNotifier {
  /// Repositorio inyectado para obtener datos.
  final CustomersRepository repository;

  /// Estado actual del módulo.
  CustomersStatus status = CustomersStatus.initial;

  /// Lista completa de clientes obtenida del repositorio.
  List<Customer> customers = [];

  /// Lista de clientes después de aplicar filtros.
  List<Customer> filteredCustomers = [];

  /// Mensaje de error cuando status es 'error'.
  String errorMessage = '';

  CustomersNotifier({required this.repository});

  /// Carga la lista de clientes desde el repositorio.
  /// Actualiza el estado durante el proceso.
  Future<void> loadCustomers() async {
    status = CustomersStatus.loading;
    notifyListeners();

    try {
      customers = await repository.getCustomers();
      filteredCustomers = customers;
      status = CustomersStatus.loaded;
      errorMessage = '';
    } catch (e) {
      status = CustomersStatus.error;
      errorMessage = 'No se pudieron cargar los clientes. ${e.toString()}';
    }

    notifyListeners();
  }

  /// Filtra la lista de clientes por nombre o número de documento.
  /// Si la consulta está vacía, muestra todos los clientes.
  String _lastQuery = '';
  String _statusFilter = 'Todos';

  void filterByQuery(String query) {
    _lastQuery = query.trim();
    _applyFilters();
  }

  /// Cambia el filtro de estado (Todos, Activos, Inactivos) y reaplica filtros.
  void setStatusFilter(String status) {
    _statusFilter = status;
    _applyFilters();
  }

  void _applyFilters() {
    final normalizedQuery = _lastQuery.toLowerCase();

    List<Customer> list = customers;

    // Filtrar por estado
    if (_statusFilter == 'Activos') {
      list = list.where((c) => c.estado == true).toList();
    } else if (_statusFilter == 'Inactivos') {
      list = list.where((c) => c.estado == false).toList();
    }

    // Filtrar por query
    if (normalizedQuery.isNotEmpty) {
      list = list.where((customer) {
        final nombre = customer.nombre.toLowerCase();
        final documento = customer.numeroDocumento.toLowerCase();
        return nombre.contains(normalizedQuery) ||
            documento.contains(normalizedQuery);
      }).toList();
    }

    filteredCustomers = list;
    notifyListeners();
  }
}
