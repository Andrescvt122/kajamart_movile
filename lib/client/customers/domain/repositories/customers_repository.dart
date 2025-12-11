import '../entities/customer.dart';

/// Contrato (interfaz) para el repositorio de clientes.
/// Define qué métodos debe implementar cualquier repositorio de clientes,
/// permitiendo múltiples implementaciones (local, remota, hibrida, etc).
abstract class CustomersRepository {
  /// Obtiene la lista de todos los clientes.
  ///
  /// Lanza excepción si la operación falla.
  /// La implementación puede obtener datos de:
  /// - API REST remota
  /// - Base de datos local
  /// - Cache en memoria
  /// - O cualquier otra fuente de datos
  Future<List<Customer>> getCustomers();
}
