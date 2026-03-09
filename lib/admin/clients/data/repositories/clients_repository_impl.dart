import '../datasources/clients_remote_data_source.dart';
import '../models/client_model.dart';

class ClientsRepositoryImpl {
  final ClientsRemoteDataSource remote;

  ClientsRepositoryImpl({required this.remote});

  Future<List<AdminClientModel>> getClients({bool useMock = false}) async {
    return remote.fetchClients(useMockData: useMock);
  }
}
