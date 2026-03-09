import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/customer_model.dart';

/// Fuente de datos remota para clientes.
/// Maneja la comunicación con la API REST y la deserialización de datos.
/// Compatible con mobile (Android/iOS) y web (Flutter Web).
///
/// IMPORTANTE: Cómo configurar la URL real del backend:
/// 1. En main.dart o en CustomersListPage, cambiar:
///    const String baseUrl = 'https://tu-api-real.com';
/// 2. También cambiar useMockData a false en CustomersListPage:
///    useMockData: false,
class CustomersRemoteDataSource {
  /// URL base del backend (ej: https://api.kajamart.com)
  /// Asegúrate de incluir http:// o https://
  /// NO incluyas slash al final
  final String baseUrl;

  /// Endpoint específico para la lista de clientes (ej: /api/clientes, /v1/customers)
  /// Por defecto: /clients
  /// La URL final será: baseUrl + customersEndpoint
  final String customersEndpoint;

  /// Cliente HTTP inyectable para facilitar pruebas unitarias y mocking.
  final http.Client httpClient;

  /// Headers por defecto que se enviarán en cada petición.
  /// Útil para Authorization: Bearer <token> u otros headers globales.
  final Map<String, String>? defaultHeaders;

  CustomersRemoteDataSource({
    required this.baseUrl,
    this.customersEndpoint = '/clients',
    http.Client? httpClient,
    this.defaultHeaders,
  }) : httpClient = httpClient ?? http.Client();

  /// Obtiene la lista de clientes.
  ///
  /// [useMockData]: Si es true, retorna datos de prueba sin hacer llamada HTTP.
  ///                Si es false, hace la llamada real a la API.
  ///
  /// Datos de prueba se usan cuando:
  /// - useMockData = true
  /// - baseUrl está vacío
  ///
  /// Ejemplo de integración con API real:
  /// ```
  /// Future<List<CustomerModel>> fetchCustomers({bool useMockData = false}) async {
  ///   if (useMockData || baseUrl.isEmpty) {
  ///     return _mockCustomers;
  ///   }
  ///
  ///   try {
  ///     final uri = Uri.parse('$baseUrl$customersEndpoint');
  ///     final response = await httpClient.get(uri);
  ///
  ///     if (response.statusCode == 200) {
  ///       // Procesa la respuesta...
  ///     }
  ///   } catch (e) {
  ///     // Maneja errores de conexión...
  ///   }
  /// }
  /// ```
  Future<List<CustomerModel>> fetchCustomers({bool useMockData = true}) async {
    if (useMockData || baseUrl.isEmpty) {
      // Simula un pequeño delay como si fuera una llamada real
      await Future.delayed(const Duration(milliseconds: 800));
      return _mockCustomers;
    }

    try {
      final uri = Uri.parse('$baseUrl$customersEndpoint');
      print('🔵 [Clientes] Intentando GET a: $uri');

      // Construir headers
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // Agregar headers personalizados si existen
      if (defaultHeaders != null) {
        headers.addAll(defaultHeaders!);
      }

      print('🔵 [Clientes] Headers: $headers');

      final response = await httpClient
          .get(uri, headers: headers)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception(
              'Timeout: El servidor tardó demasiado en responder (>15s)',
            ),
          );

      print('🟢 [Clientes] Response status: ${response.statusCode}');
      print(
        '🟢 [Clientes] Response body (primeros 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        print('🟢 [Clientes] Clientes parseados: ${data.length}');

        final customers = data
            .map((item) => CustomerModel.fromJson(item as Map<String, dynamic>))
            .toList();

        print('🟢 [Clientes] ✅ SUCCESS: ${customers.length} clientes cargados');
        return customers;
      } else if (response.statusCode == 401) {
        throw Exception(
          '❌ No autorizado (401). Verifica tus credenciales o token.',
        );
      } else if (response.statusCode == 404) {
        throw Exception('❌ Endpoint no encontrado (404): $customersEndpoint');
      } else if (response.statusCode == 500) {
        throw Exception('❌ Error en servidor (500). Revisa logs del backend.');
      } else {
        throw Exception(
          '❌ Error HTTP ${response.statusCode}. Body: ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      print('🔴 [Clientes] Error de conexión: ${e.message}');

      // Si estamos en web y hay error de CORS, usar mock data como fallback
      if (kIsWeb) {
        print('⚠️ [Clientes] En web: usando mock data por error de conexión');
        await Future.delayed(const Duration(milliseconds: 500));
        return _mockCustomers;
      }

      throw Exception(
        '❌ No se pudo conectar al servidor.\n'
        'Detalles: ${e.message}\n'
        'Verifica que:\n'
        '1. El backend está corriendo en $baseUrl\n'
        '2. Tienes conexión a internet\n'
        '3. El firewall permite conexiones',
      );
    } catch (e) {
      print('🔴 [Clientes] Error inesperado: ${e.toString()}');

      // Si estamos en web y hay cualquier error, usar mock data como fallback
      if (kIsWeb && e.toString().contains('XHR') ||
          e.toString().contains('CORS')) {
        print('⚠️ [Clientes] En web: usando mock data por error de CORS/red');
        await Future.delayed(const Duration(milliseconds: 500));
        return _mockCustomers;
      }

      throw Exception('❌ Error: ${e.toString()}');
    }
  }
}

/// ============================================
/// DATOS DE PRUEBA (MOCK DATA)
/// ============================================
/// Estos datos se usan cuando useMockData = true.
/// Actualiza estos clientes para simular tus datos reales.
const List<CustomerModel> _mockCustomers = [
  CustomerModel(
    id: '1',
    nombre: 'María González López',
    tipoDocumento: 'DNI',
    numeroDocumento: '12345678',
    email: 'maria.gonzalez@example.com',
    telefono: '+51 987654321',
  ),
  CustomerModel(
    id: '2',
    nombre: 'Juan Pérez Rodríguez',
    tipoDocumento: 'DNI',
    numeroDocumento: '87654321',
    email: 'juan.perez@example.com',
    telefono: '+51 912345678',
  ),
  CustomerModel(
    id: '3',
    nombre: 'Lucía Fernández García',
    tipoDocumento: 'Pasaporte',
    numeroDocumento: 'X1234567',
    email: 'lucia.fernandez@example.com',
    telefono: '+34 612345678',
  ),
  CustomerModel(
    id: '4',
    nombre: 'Carlos Martínez Sánchez',
    tipoDocumento: 'DNI',
    numeroDocumento: '45678901',
    email: 'carlos.martinez@example.com',
    telefono: '+51 998765432',
  ),
  CustomerModel(
    id: '5',
    nombre: 'Ana Silva Torres',
    tipoDocumento: 'RUC',
    numeroDocumento: '20123456789',
    email: 'ana.silva@example.com',
    telefono: '+51 975555555',
  ),
  CustomerModel(
    id: '6',
    nombre: 'Roberto Díaz Campos',
    tipoDocumento: 'DNI',
    numeroDocumento: '56789012',
    email: 'roberto.diaz@example.com',
    telefono: '+51 989999999',
  ),
];
