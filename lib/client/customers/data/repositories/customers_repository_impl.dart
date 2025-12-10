import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';
import '../datasources/customers_remote_data_source.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  final CustomersRemoteDataSource remoteDataSource;
  final bool useMockData;

  const CustomersRepositoryImpl({
    required this.remoteDataSource,
    this.useMockData = true,
  });

  @override
  Future<List<Customer>> getCustomers() {
    return remoteDataSource.fetchCustomers(useMockData: useMockData);
  }
}
