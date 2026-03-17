import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';
import '../datasources/customers_remote_data_source.dart';

/// Implementación concreta del repositorio de clientes.
/// Actúa como intermediario entre la capa de presentación y las fuentes de datos.
/// Encapsula la lógica de dónde obtener los datos (remoto, local, caché, etc).
class CustomersRepositoryImpl implements CustomersRepository {
  /// Fuente de datos remota inyectada.
  final CustomersRemoteDataSource remoteDataSource;

  /// Bandera para usar datos de prueba en lugar de API real.
  /// Útil para desarrollo y testing.
  final bool useMockData;

  const CustomersRepositoryImpl({
    required this.remoteDataSource,
    this.useMockData = true,
  });

  /// Obtiene la lista de clientes.
  ///
  /// Delega al datasource remoto, que decidirá si usar datos de prueba o API real.
  @override
  Future<List<Customer>> getCustomers() {
    return remoteDataSource.fetchCustomers(useMockData: useMockData);
  }
}
