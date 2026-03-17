# Guía de Troubleshooting - Módulo de Clientes

## 🔴 Problemas Comunes y Soluciones

### 1. "No se encontraron clientes" - Pero debería haber clientes

**Causa posible:** 
- El backend retorna una lista vacía
- Hay un problema con la URL o endpoint

**Solución:**

a) **Verifica la URL base:**
```dart
// En customers_list_page.dart
const String baseUrl = 'https://api.tu-dominio.com';

// Asegúrate de que:
// - NO tenga "/" al final
// - Sea HTTP o HTTPS
// - El dominio sea correcto
```

b) **Verifica el endpoint:**
```dart
// En CustomersRemoteDataSource
customersEndpoint = '/clientes';

// Prueba la URL completa en Postman o tu navegador:
// https://api.tu-dominio.com/clientes
```

c) **Usa datos de prueba temporalmente:**
```dart
// En customers_list_page.dart
return CustomersRepositoryImpl(
  remoteDataSource: CustomersRemoteDataSource(baseUrl: baseUrl),
  useMockData: true,  // ← Cambia a true para probar
);
```

d) **Verifica los logs:**
```dart
// En CustomersNotifier
Future<void> loadCustomers() async {
  // ...
  try {
    customers = await repository.getCustomers();
    print('✅ Clientes cargados: ${customers.length}');
  } catch (e) {
    print('❌ Error: $e');  // Aquí verás el error detallado
  }
}
```

---

### 2. Error 401 "No autorizado"

**Causa:**
- La API requiere autenticación
- El token es inválido o expiró

**Solución:**

a) **Agrega autenticación al cliente HTTP:**

```dart
import 'package:http/http.dart' as http;

class AuthenticatedHttpClient extends http.BaseClient {
  final String token;

  AuthenticatedHttpClient(this.token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer $token';
    return super.send(request);
  }
}

// En customers_list_page.dart:
final authHttpClient = AuthenticatedHttpClient(userToken);
return CustomersRepositoryImpl(
  remoteDataSource: CustomersRemoteDataSource(
    baseUrl: baseUrl,
    httpClient: authHttpClient,
  ),
  useMockData: false,
);
```

b) **Verifica que el token sea válido:**
```dart
// Si tienes un servicio de autenticación
final token = await authService.getValidToken();
if (token == null) {
  Navigator.pushNamed(context, '/login');
  return;
}
```

---

### 3. Error 404 "Not Found"

**Causa:**
- El endpoint no existe en el servidor
- La ruta es incorrecta

**Solución:**

a) **Verifica el endpoint con el backend:**
```dart
// Preunta a tu equipo backend:
// - ¿Cuál es la ruta exacta para obtener clientes?
// - ¿Es /clientes o /api/clientes o algo más?

// Ajusta en CustomersRemoteDataSource:
const CustomersRemoteDataSource({
  required this.baseUrl,
  this.customersEndpoint = '/api/v1/customers',  // ← Cambia aquí
});
```

b) **Prueba la URL en Postman:**
```
GET https://api.tu-dominio.com/api/v1/customers

Headers:
  Authorization: Bearer TU_TOKEN
  Content-Type: application/json
```

---

### 4. Error 500 "Internal Server Error"

**Causa:**
- Error en el servidor
- Problema en la base de datos del backend
- Consulta SQL malformada

**Solución:**

a) **Contacta al equipo backend:**
- Pídeles que revisen los logs del servidor
- Verifica si otros endpoints funcionan

b) **Mientras tanto, usa datos de prueba:**
```dart
useMockData: true,  // Para continuar desarrollando
```

c) **Implementa reintentos automáticos:**
```dart
Future<List<Customer>> _getCustomersWithRetry() async {
  int retries = 3;
  while (retries > 0) {
    try {
      return await repository.getCustomers();
    } catch (e) {
      retries--;
      if (retries == 0) rethrow;
      await Future.delayed(const Duration(seconds: 2));
    }
  }
  return [];
}
```

---

### 5. "Error de conexión" / "Timeout"

**Causa:**
- No hay internet
- El servidor está caído
- La red es muy lenta

**Solución:**

a) **Aumenta el timeout:**
```dart
// En CustomersRemoteDataSource
Future<List<CustomerModel>> fetchCustomers({bool useMockData = true}) async {
  final uri = Uri.parse('$baseUrl$customersEndpoint');
  
  final response = await httpClient.get(uri)
      .timeout(const Duration(seconds: 60));  // Aumenta de 30 a 60
  
  // ...
}
```

b) **Implementa detección de conectividad:**
```dart
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> loadCustomers() async {
  final connectivity = await Connectivity().checkConnectivity();
  
  if (connectivity == ConnectivityResult.none) {
    errorMessage = 'No hay conexión a internet';
    notifyListeners();
    return;
  }
  
  // Continúa con la carga...
}
```

c) **Agregar paquete en pubspec.yaml:**
```yaml
dependencies:
  connectivity_plus: ^4.0.0
```

---

### 6. Los datos no coinciden con el modelo

**Causa:**
- El JSON del servidor tiene campos diferentes
- Cambió la estructura de la API

**Solución:**

a) **Verifica la respuesta JSON:**
```dart
// En CustomersRemoteDataSource, imprime la respuesta:
final List<dynamic> data = json.decode(response.body);
print('JSON recibido: $data');  // Verás la estructura actual
```

b) **Ajusta CustomerModel.fromJson():**
```dart
factory CustomerModel.fromJson(Map<String, dynamic> json) {
  return CustomerModel(
    id: json['id'].toString(),
    nombre: json['nombreCliente'] ?? '',  // ← Cambió el nombre del campo
    tipoDocumento: json['tipo_doc'] ?? '',  // ← Cambió este también
    numeroDocumento: json['numero_doc'] ?? '',
    email: json['correo'] ?? '',  // ← Aquí era correo, no email
    telefono: json['celular'] ?? '',  // ← Y aquí celular, no telefono
  );
}
```

c) **Usa null coalescing para seguridad:**
```dart
factory CustomerModel.fromJson(Map<String, dynamic> json) {
  return CustomerModel(
    id: (json['id'] ?? json['client_id'] ?? '').toString(),
    nombre: json['nombre'] ?? json['full_name'] ?? '',
    // ... así maneja múltiples variaciones
  );
}
```

---

### 7. Búsqueda no funciona

**Causa:**
- La lógica de filtrado tiene un error
- Los datos de prueba no coinciden

**Solución:**

a) **Verifica la función filterByQuery:**
```dart
void filterByQuery(String query) {
  print('Buscando: "$query"');  // Debug
  print('Total de clientes: ${customers.length}');
  
  final normalizedQuery = query.trim().toLowerCase();
  
  if (normalizedQuery.isEmpty) {
    filteredCustomers = customers;
  } else {
    filteredCustomers = customers.where((customer) {
      final nombre = customer.nombre.toLowerCase();
      final documento = customer.numeroDocumento.toLowerCase();
      
      final match = nombre.contains(normalizedQuery) ||
                    documento.contains(normalizedQuery);
      
      if (match) print('✓ Encontrado: ${customer.nombre}');
      
      return match;
    }).toList();
  }
  
  print('Resultados: ${filteredCustomers.length}');  // Debug
  notifyListeners();
}
```

b) **Agrega búsqueda en email también:**
```dart
filteredCustomers = customers.where((customer) {
  final nombre = customer.nombre.toLowerCase();
  final documento = customer.numeroDocumento.toLowerCase();
  final email = customer.email.toLowerCase();  // ← Aquí
  
  return nombre.contains(normalizedQuery) ||
         documento.contains(normalizedQuery) ||
         email.contains(normalizedQuery);
}).toList();
```

---

### 8. "Invalid constant value" en datasource

**Error en la consola:**
```
Invalid constant value at constructor initialization
```

**Causa:**
- El constructor está marcado como `const` pero tiene lógica no constante

**Solución:**

```dart
// INCORRECTO:
class CustomersRemoteDataSource {
  const CustomersRemoteDataSource({
    // ...
  }) : httpClient = httpClient ?? http.Client();  // ❌ No puede ser const
}

// CORRECTO:
class CustomersRemoteDataSource {
  CustomersRemoteDataSource({  // ← Quita el const
    // ...
  }) : httpClient = httpClient ?? http.Client();
}
```

---

### 9. Los clientes no se actualizan después de cambios en el backend

**Causa:**
- Los datos se cargan una sola vez
- No hay forma de refrescar

**Solución:**

a) **Implementa un botón de recarga:**
```dart
// Ya está en customers_list_page.dart:
if (notifier.filteredCustomers.isNotEmpty)
  TextButton.icon(
    icon: const Icon(Icons.refresh, size: 16),
    label: const Text('Recargar'),
    onPressed: notifier.loadCustomers,  // ← Llama esto
  );
```

b) **Agrega un RefreshIndicator:**
```dart
return RefreshIndicator(
  onRefresh: notifier.loadCustomers,
  child: ListView.builder(
    // ...
  ),
);
```

c) **Carga automática cada X segundos:**
```dart
@override
void initState() {
  super.initState();
  // Recarga cada 2 minutos
  Timer.periodic(const Duration(minutes: 2), (_) {
    notifier.loadCustomers();
  });
}
```

---

### 10. El avatar muestra "?" para todos

**Causa:**
- Los nombres están vacíos o nulos

**Solución:**

a) **Verifica que los nombres se cargan:**
```dart
print('Cliente: ${customer.nombre}');  // ¿Está vacío?
```

b) **En CustomerModel.fromJson():**
```dart
nombre: json['nombre']?.toString().trim() ?? 'Sin nombre',
```

c) **En customer_card.dart:**
```dart
customer.nombre.isNotEmpty
    ? customer.nombre[0].toUpperCase()
    : 'S',  // 'S' de "Sin nombre"
```

---

## 🔧 Herramientas de Debug

### 1. **Imprime logs detallados:**
```dart
// En customers_notifier.dart
Future<void> loadCustomers() async {
  print('🟡 Estado: LOADING');
  status = CustomersStatus.loading;
  notifyListeners();

  try {
    print('📡 Obteniendo clientes...');
    customers = await repository.getCustomers();
    print('✅ ${customers.length} clientes obtenidos');
    
    for (var customer in customers) {
      print('  - ${customer.nombre} (${customer.email})');
    }
    
    filteredCustomers = customers;
    status = CustomersStatus.loaded;
  } catch (e) {
    print('❌ ERROR: $e');
    status = CustomersStatus.error;
    errorMessage = e.toString();
  }

  notifyListeners();
}
```

### 2. **Prueba en Postman:**
```
GET https://api.tu-dominio.com/clientes

Headers:
  Authorization: Bearer YOUR_TOKEN
  Content-Type: application/json

Response:
```

### 3. **Usa DevTools de Flutter:**
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 4. **Revisa los logs del servidor:**
```bash
# Dependiendo de tu backend
tail -f /var/log/app.log
docker logs container-name
heroku logs --tail
```

---

## 📋 Checklist de Verificación

Antes de reportar un error, verifica:

- [ ] ¿La URL base es correcta? (sin "/" al final)
- [ ] ¿El endpoint es correcto?
- [ ] ¿Hay autenticación requerida?
- [ ] ¿El token no está expirado?
- [ ] ¿Hay conexión a internet?
- [ ] ¿El servidor está disponible?
- [ ] ¿El JSON coincide con CustomerModel?
- [ ] ¿useMockData está en el valor correcto?
- [ ] ¿Los campos JSON tienen los nombres esperados?
- [ ] ¿Hay logs de error en la consola?

---

## 🆘 ¿Aún no funciona?

Si después de intentar estas soluciones aún tienes problemas:

1. **Recopila información:**
   - Captura de pantalla del error
   - Logs completos de la consola
   - Versión de Flutter (`flutter --version`)
   - URL del servidor (sin datos sensibles)

2. **Revisa el código:**
   - Busca `print()` en la consola
   - Verifica el estado en DevTools

3. **Contacta al equipo:**
   - Proporciona toda la información recopilada
   - Explica qué intentaste
   - Describe el comportamiento esperado vs actual

---

**Última actualización:** Diciembre 2025

