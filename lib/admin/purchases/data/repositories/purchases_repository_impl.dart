import '../datasources/purchases_remote_data_source.dart';
import '../models/purchase_model.dart';

/// Repositorio de compras: capa que une data source con la UI/negocio.
class PurchasesRepositoryImpl {
  final PurchasesRemoteDataSource remote;

  PurchasesRepositoryImpl({required this.remote});

  Future<List<PurchaseModel>> getPurchases({bool useMock = false}) async {
    return remote.fetchPurchases(useMockData: useMock);
  }

  Future<PurchaseModel?> getById(String id, {bool useMock = false}) async {
    final list = await getPurchases(useMock: useMock);
    try {
      return list.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
