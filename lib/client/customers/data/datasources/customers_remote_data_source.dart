import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/customer_model.dart';

class CustomersRemoteDataSource {
  /// URL base del backend, por ejemplo: `https://api.tu-dominio.com`.
  final String baseUrl;

  /// Endpoint específico para la lista de clientes. Por defecto: `/clientes`.
  final String customersEndpoint;

  /// Cliente HTTP inyectable para facilitar pruebas o mocking.
  final http.Client httpClient;

  const CustomersRemoteDataSource({
    required this.baseUrl,
    this.customersEndpoint = '/clientes',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Si [useMockData] es verdadero o [baseUrl] está vacío, retorna datos de prueba.
  /// De lo contrario, realiza la llamada HTTP real.
  Future<List<CustomerModel>> fetchCustomers({bool useMockData = true}) async {
    if (useMockData || baseUrl.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 800));
      return _mockCustomers;
    }

    final uri = Uri.parse('$baseUrl$customersEndpoint');
    final response = await httpClient.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((item) => CustomerModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Error al obtener clientes: código ${response.statusCode}',
    );
  }
}

/// Datos de ejemplo para usar mientras conectas tu API real.
const List<CustomerModel> _mockCustomers = [
  CustomerModel(
    id: '1',
    nombre: 'María González',
    tipoDocumento: 'DNI',
    numeroDocumento: '12345678',
    email: 'maria.gonzalez@example.com',
    telefono: '+51 987654321',
  ),
  CustomerModel(
    id: '2',
    nombre: 'Juan Pérez',
    tipoDocumento: 'DNI',
    numeroDocumento: '87654321',
    email: 'juan.perez@example.com',
    telefono: '+51 912345678',
  ),
  CustomerModel(
    id: '3',
    nombre: 'Lucía Fernández',
    tipoDocumento: 'Pasaporte',
    numeroDocumento: 'X1234567',
    email: 'lucia.fernandez@example.com',
    telefono: '+34 612345678',
  ),
];
