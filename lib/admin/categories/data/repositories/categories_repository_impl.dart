import '../datasources/categories_remote_data_source.dart';
import '../models/category_model.dart';

class CategoriesRepositoryImpl {
  final CategoriesRemoteDataSource remote;

  CategoriesRepositoryImpl({required this.remote});

  Future<List<CategoryModel>> getCategories({bool useMock = false}) async {
    return remote.fetchCategories(useMockData: useMock);
  }
}
