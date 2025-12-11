/// Ejemplo de cómo integrar el módulo de clientes en tu aplicación.
///
/// Este archivo muestra diferentes formas de usar el módulo en tu app.
///
/// NO necesitas copiar este código a tu proyecto. Es solo referencia.
/// El módulo ya está integrado en main.dart

// ============================================================
// EJEMPLO 1: Navegar al módulo desde un botón
// ============================================================

/*
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Forma 1: Usando rutas nombradas (RECOMENDADO)
        Navigator.pushNamed(context, '/clientes');
        
        // O Forma 2: Usando MaterialPageRoute
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const CustomersListPage()),
        // );
      },
      child: const Text('Ver Clientes'),
    );
  }
}
*/

// ============================================================
// EJEMPLO 2: Usar el repositorio directamente
// ============================================================

/*
import 'package:kajamart_movile/client/customers/data/datasources/customers_remote_data_source.dart';
import 'package:kajamart_movile/client/customers/data/repositories/customers_repository_impl.dart';
import 'package:kajamart_movile/client/customers/domain/repositories/customers_repository.dart';

Future<void> fetchCustomersDirectly() async {
  final repository = CustomersRepositoryImpl(
    remoteDataSource: CustomersRemoteDataSource(
      baseUrl: 'https://api.tu-dominio.com',
    ),
    useMockData: false,
  );

  try {
    final customers = await repository.getCustomers();
    print('Clientes obtenidos: ${customers.length}');
  } catch (e) {
    print('Error: $e');
  }
}
*/

// ============================================================
// EJEMPLO 3: Usar el Notifier directamente
// ============================================================

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kajamart_movile/client/customers/presentation/providers/customers_notifier.dart';

class CustomersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersNotifier>(
      builder: (context, notifier, _) {
        if (notifier.status == CustomersStatus.loading) {
          return const CircularProgressIndicator();
        }
        
        if (notifier.status == CustomersStatus.error) {
          return Text('Error: ${notifier.errorMessage}');
        }
        
        return ListView.builder(
          itemCount: notifier.filteredCustomers.length,
          itemBuilder: (context, index) {
            final customer = notifier.filteredCustomers[index];
            return ListTile(
              title: Text(customer.nombre),
              subtitle: Text(customer.email),
            );
          },
        );
      },
    );
  }
}
*/

// ============================================================
// EJEMPLO 4: Usar funciones de utilidad para formateo
// ============================================================

/*
import 'package:kajamart_movile/client/customers/utils/formatting_utils.dart';

void main() {
  // Formatear teléfono
  final phone = formatPhoneNumber('51987654321');
  print(phone); // +51 987 654 321

  // Formatear documento
  final doc = formatDocumentNumber('12345678', 'DNI');
  print(doc); // 12 345 678

  // Obtener iniciales
  final initials = getInitials('Juan Pérez');
  print(initials); // J

  // Validar email
  final isValid = isValidEmail('juan@example.com');
  print(isValid); // true

  // Truncar texto
  final truncated = truncateText('Juan Pérez García', 10);
  print(truncated); // Juan Pérez...
}
*/

// ============================================================
// EJEMPLO 5: Manejar excepciones personalizadas
// ============================================================

/*
import 'package:kajamart_movile/client/customers/utils/exceptions.dart';

Future<void> loadCustomersWithErrorHandling() async {
  try {
    // Intenta cargar clientes...
    // ...
  } on NetworkException catch (e) {
    print('Error de red: ${e.message}');
    // Muestra mensaje al usuario
  } on UnauthorizedException catch (e) {
    print('No autorizado: ${e.message}');
    // Redirige a login
  } on ServerException catch (e) {
    print('Error del servidor: ${e.message}');
    // Muestra mensaje genérico
  } on CustomersException catch (e) {
    print('Error de clientes: ${e.message}');
    // Maneja otros errores del módulo
  } catch (e) {
    print('Error inesperado: $e');
    // Maneja errores inesperados
  }
}
*/

// ============================================================
// EJEMPLO 6: Configurar diferentes URLs por ambiente
// ============================================================

/*
// En un archivo de configuración (config.dart)

const String environmentType = 'production'; // 'development', 'staging', 'production'

String getApiBaseUrl() {
  switch (environmentType) {
    case 'development':
      return 'http://localhost:8000';
    case 'staging':
      return 'https://staging-api.kajamart.com';
    case 'production':
      return 'https://api.kajamart.com';
    default:
      return 'https://api.kajamart.com';
  }
}

// Usar en el módulo:
// const String baseUrl = getApiBaseUrl();
*/

// ============================================================
// EJEMPLO 7: Implementar autenticación
// ============================================================

/*
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticatedHttpClient extends http.BaseClient {
  final String _token;

  AuthenticatedHttpClient(this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer $_token';
    return super.send(request);
  }
}

// Usar en el datasource:
// final httpClient = AuthenticatedHttpClient(userToken);
// final dataSource = CustomersRemoteDataSource(
//   baseUrl: baseUrl,
//   httpClient: httpClient,
// );
*/

// ============================================================
// EJEMPLO 8: Agregar caché de datos
// ============================================================

/*
// En una versión mejorada de CustomersRepositoryImpl
class CachedCustomersRepository implements CustomersRepository {
  final CustomersRemoteDataSource remoteDataSource;
  List<Customer>? _cache;
  DateTime? _lastCacheTime;
  final Duration cacheExpiration = const Duration(minutes: 5);

  @override
  Future<List<Customer>> getCustomers() async {
    // Retorna del caché si aún es válido
    if (_cache != null && _lastCacheTime != null) {
      final now = DateTime.now();
      if (now.difference(_lastCacheTime!).inMilliseconds < cacheExpiration.inMilliseconds) {
        return _cache!;
      }
    }

    // Si no, obtiene del servidor y actualiza caché
    final customers = await remoteDataSource.fetchCustomers();
    _cache = customers;
    _lastCacheTime = DateTime.now();
    return customers;
  }

  void clearCache() {
    _cache = null;
    _lastCacheTime = null;
  }
}
*/

// ============================================================
// EJEMPLO 9: Unit Tests para el módulo
// ============================================================

/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kajamart_movile/client/customers/domain/repositories/customers_repository.dart';
import 'package:kajamart_movile/client/customers/presentation/providers/customers_notifier.dart';

class MockRepository extends Mock implements CustomersRepository {}

void main() {
  group('CustomersNotifier', () {
    test('loadCustomers updates status to loaded on success', () async {
      final repository = MockRepository();
      final notifier = CustomersNotifier(repository: repository);

      when(repository.getCustomers()).thenAnswer((_) async => [
        // Clientes de prueba
      ]);

      await notifier.loadCustomers();

      expect(notifier.status, CustomersStatus.loaded);
    });

    test('filterByQuery filters customers correctly', () {
      final notifier = CustomersNotifier(repository: MockRepository());
      notifier.customers = [
        // Clientes de prueba
      ];

      notifier.filterByQuery('Juan');

      // Verifica que solo contiene clientes que coinciden
    });
  });
}
*/

// ============================================================
// EJEMPLO 10: Integración con otras pantallas
// ============================================================

/*
// En el AdminHomeScreen o donde necesites mostrar clientes
import 'package:kajamart_movile/client/customers/presentation/pages/customers_list_page.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Otros widgets...
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomersListPage()),
              );
            },
            child: const Text('Gestionar Clientes'),
          ),
        ],
      ),
    );
  }
}
*/

// ============================================================
// NOTAS IMPORTANTES
// ============================================================

/*
1. **Rutas**: El módulo está registrado en main.dart con la ruta '/clientes'
   
2. **Dependencias**: Solo necesitas:
   - flutter (framework)
   - provider (gestión de estado)
   - http (llamadas API)
   
3. **Configuración API**:
   - Cambia baseUrl en customers_list_page.dart
   - Ajusta customer_model.dart si los campos JSON son diferentes
   - Cambia useMockData a false cuando tengas API lista
   
4. **Errores**: El módulo maneja automáticamente:
   - Errores de conexión
   - Errores de servidor
   - Errores de JSON
   - Timeouts
   
5. **Testing**: Puedes mockear el repositorio para tests
   
6. **Performance**: 
   - Los datos se cargan una sola vez al entrar a la pantalla
   - El filtrado es en memoria (rápido)
   - Considera agregar paginación si hay muchos clientes
   
7. **Seguridad**:
   - Usa HTTPS en producción
   - Implementa autenticación en el cliente HTTP
   - Valida datos en el servidor
   - No guardes tokens en SharedPreferences sin encriptación

*/
