import '../datasources/sales_remote_data_source.dart';
import '../models/sale_model.dart';

class SalesRepositoryImpl {
  final SalesRemoteDataSource remote;

  SalesRepositoryImpl({required this.remote});

  Future<List<SaleModel>> getSales({bool useMock = false}) async {
    return remote.fetchSales(useMockData: useMock);
  }

  Future<SaleModel?> getById(String id, {bool useMock = false}) async {
    final list = await getSales(useMock: useMock);
    try {
      return list.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
