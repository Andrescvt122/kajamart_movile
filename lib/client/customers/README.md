# Módulo de Clientes - Documentación Completa

## 📋 Descripción General

El módulo de **Clientes** es un componente de lectura pura que permite visualizar, buscar y filtrar los clientes registrados en tu sistema Kajamart.

### Características
- ✅ Listado de clientes con tarjetas visualmente atractivas
- 🔍 Búsqueda y filtrado en tiempo real por nombre o documento
- 📄 Vista de detalle con toda la información del cliente
- ⚡ Carga asincrónica con indicadores de progreso
- 🛡️ Manejo robusto de errores
- 📦 Datos de prueba (mock data) para desarrollo
- 🔌 Fácil integración con API REST real

---

## 🏗️ Arquitectura - Clean Architecture

```
lib/client/customers/
│
├── data/
│   ├── datasources/
│   │   └── customers_remote_data_source.dart    # Llamadas HTTP y datos
│   ├── models/
│   │   └── customer_model.dart                  # Serialización JSON
│   └── repositories/
│       └── customers_repository_impl.dart       # Implementación concreta
│
├── domain/
│   ├── entities/
│   │   └── customer.dart                        # Entidad de negocio
│   └── repositories/
│       └── customers_repository.dart            # Contrato (interfaz)
│
└── presentation/
    ├── pages/
    │   ├── customers_list_page.dart             # Pantalla principal
    │   └── customer_detail_page.dart            # Detalle del cliente
    ├── providers/
    │   └── customers_notifier.dart              # Gestión de estado (Provider)
    └── widgets/
        └── customer_card.dart                   # Tarjeta de cliente
```

### Explicación de las Capas

#### 🗂️ **Data (Capa de Datos)**
Responsable de obtener y transformar datos.

- **`customers_remote_data_source.dart`**
  - Maneja peticiones HTTP a la API
  - Convierte JSON en objetos Dart
  - Proporciona datos de prueba (mock data)

- **`customer_model.dart`**
  - Extiende la entidad `Customer`
  - Métodos `fromJson()` para deserialización
  - Método `toJson()` para serialización

- **`customers_repository_impl.dart`**
  - Implementa la interfaz `CustomersRepository`
  - Delega al datasource remoto
  - Punto central para lógica de datos

#### 🎯 **Domain (Capa de Dominio)**
Contiene la lógica de negocio pura, independiente de la tecnología.

- **`customer.dart`**
  - Entidad que representa un cliente
  - Campos: id, nombre, tipoDocumento, numeroDocumento, email, telefono

- **`customers_repository.dart`**
  - Interfaz que define qué métodos debe tener un repositorio
  - Permite múltiples implementaciones (local, remota, etc.)

#### 🎨 **Presentation (Capa de Presentación)**
Interfaz de usuario e interacción con el usuario.

- **`customers_list_page.dart`**
  - Página principal del módulo
  - Configura el Provider/ChangeNotifier
  - Muestra lista de clientes con búsqueda

- **`customer_detail_page.dart`**
  - Muestra información completa de un cliente
  - Diseño mejorado con gradientes y secciones

- **`customer_card.dart`**
  - Widget reutilizable para mostrar cliente
  - Tarjeta visual con información resumida

- **`customers_notifier.dart`**
  - Gestión de estado usando Provider (ChangeNotifier)
  - Maneja carga, filtrado y errores

---

## 🔌 Gestión de Estado: ¿Por qué Provider?

Se eligió **Provider (ChangeNotifier)** por las siguientes razones:

| Aspecto | Provider | Bloc | Riverpod |
|--------|----------|------|----------|
| **Complejidad** | ⭐ Baja | ⭐⭐⭐ Alta | ⭐⭐ Media |
| **Curva de aprendizaje** | ⭐ Fácil | ⭐⭐⭐ Difícil | ⭐⭐ Media |
| **Boilerplate** | ⭐ Mínimo | ⭐⭐⭐ Mucho | ⭐⭐ Moderado |
| **Ideal para** | CRUD simple | Lógica compleja | Funcional |

Para un módulo de **lectura pura**, Provider es la mejor opción:
- Código limpio y directo
- Menos archivos que generar
- Eficiencia en desarrollo
- Fácil de testear

---

## 🚀 Configuración de la API Real

### Paso 1: Cambiar la URL Base

Abre `lib/client/customers/presentation/pages/customers_list_page.dart`:

```dart
CustomersRepository _buildRepository() {
  // CAMBIA ESTO por tu URL real
  const String baseUrl = 'https://tu-api-real.com';
  
  return CustomersRepositoryImpl(
    remoteDataSource: CustomersRemoteDataSource(baseUrl: baseUrl),
    useMockData: false,  // ← Cambia a false para usar API real
  );
}
```

### Paso 2: Configurar el Endpoint

Ajusta el endpoint si tu API no usa `/clientes`:

```dart
CustomersRemoteDataSource(
  baseUrl: baseUrl,
  customersEndpoint: '/api/v1/customers',  // ← Tu endpoint
)
```

### Paso 3: Formato de Respuesta Esperado

Tu API debe retornar un JSON así:

```json
[
  {
    "id": "1",
    "nombre": "Juan Pérez",
    "tipoDocumento": "DNI",
    "numeroDocumento": "12345678",
    "email": "juan@example.com",
    "telefono": "+51 987654321"
  },
  {
    "id": "2",
    "nombre": "María González",
    "tipoDocumento": "DNI",
    "numeroDocumento": "87654321",
    "email": "maria@example.com",
    "telefono": "+51 912345678"
  }
]
```

Si tus campos tienen otros nombres, edita `CustomerModel.fromJson()`:

```dart
factory CustomerModel.fromJson(Map<String, dynamic> json) {
  return CustomerModel(
    id: json['client_id'].toString(),  // ← Ajusta los nombres
    nombre: json['full_name'] ?? '',
    tipoDocumento: json['doc_type'] ?? '',
    numeroDocumento: json['doc_number'] ?? '',
    email: json['email_address'] ?? '',
    telefono: json['phone_number'] ?? '',
  );
}
```

---

## 📱 Pantallas del Módulo

### 1️⃣ Lista de Clientes (`customers_list_page.dart`)

**Vista:**
```
┌─────────────────────────────┐
│     Clientes                │
│  ┌──────────────────────┐   │
│  │ 🔍 Buscar cliente... │   │
│  └──────────────────────┘   │
│  5 clientes                 │
│  ┌────────────────────────┐ │
│  │ María González López   │ │
│  │ DNI: 12345678         │ │
│  │ ☎ +51 987654321      │ │
│  │ ✉ maria@example.com   │ │
│  └────────────────────────┘ │
│  ┌────────────────────────┐ │
│  │ Juan Pérez Rodríguez  │ │
│  │ DNI: 87654321        │ │
│  │ ☎ +51 912345678      │ │
│  │ ✉ juan@example.com    │ │
│  └────────────────────────┘ │
└─────────────────────────────┘
```

**Funcionalidades:**
- Buscar por nombre o número de documento (en tiempo real)
- Ver información resumida de cada cliente
- Hacer clic para ir al detalle
- Botón de reintentar si hay error
- Indicador de carga

### 2️⃣ Detalle de Cliente (`customer_detail_page.dart`)

**Vista:**
```
┌─────────────────────────────┐
│ < Detalle del Cliente       │
├─────────────────────────────┤
│  ┌──────────────────────┐   │
│  │ M │ María González   │   │
│  │   │ ID: 1            │   │
│  └──────────────────────┘   │
│                             │
│  ┌──────────────────────┐   │
│  │ Información Personal │   │
│  │ ─────────────────── │   │
│  │ Nombre Completo     │   │
│  │ María González López│   │
│  │ Tipo de Documento   │   │
│  │ DNI                 │   │
│  │ Número de Documento │   │
│  │ 12345678            │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ Información Contacto│   │
│  │ ─────────────────── │   │
│  │ ✉ maria@example.com │   │
│  │ ☎ +51 987654321    │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ Opciones            │   │
│  │ [☎ Llamar] [✉ Email]│   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

**Funcionalidades:**
- Mostrar todos los datos del cliente
- Avatar con inicial del nombre
- Secciones organizadas
- Botones de llamada y email (placeholders)
- Scroll automático si hay mucho contenido

---

## 🔄 Flujo de Datos

```
┌─────────────────────────────────────────────────────────┐
│                    USUARIO                              │
└─────────────────────────────────────────────────────────┘
                          ↑↓
┌─────────────────────────────────────────────────────────┐
│          CustomersListPage (Presentación)               │
│  - Muestra UI                                           │
│  - Maneja interacción del usuario                       │
└─────────────────────────────────────────────────────────┘
                          ↑↓
┌─────────────────────────────────────────────────────────┐
│      CustomersNotifier (Gestión de Estado)              │
│  - Carga datos                                          │
│  - Filtra búsquedas                                     │
│  - Notifica cambios                                     │
└─────────────────────────────────────────────────────────┘
                          ↑↓
┌─────────────────────────────────────────────────────────┐
│    CustomersRepository (Abstracción - Dominio)          │
│  - Define interfaz                                      │
└─────────────────────────────────────────────────────────┘
                          ↑↓
┌─────────────────────────────────────────────────────────┐
│  CustomersRepositoryImpl (Implementación - Datos)        │
│  - Delega a datasource                                  │
└─────────────────────────────────────────────────────────┘
                          ↑↓
┌─────────────────────────────────────────────────────────┐
│  CustomersRemoteDataSource (Datos Remotos)              │
│  - Llamadas HTTP o mock data                            │
│  - Deserialización JSON                                 │
└─────────────────────────────────────────────────────────┘
                          ↑↓
┌─────────────────────────────────────────────────────────┐
│              API REST / Base de Datos                    │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 Datos de Prueba (Mock Data)

Por defecto, el módulo usa datos de prueba. Están definidos en:

📄 `lib/client/customers/data/datasources/customers_remote_data_source.dart`

```dart
const List<CustomerModel> _mockCustomers = [
  CustomerModel(
    id: '1',
    nombre: 'María González López',
    tipoDocumento: 'DNI',
    numeroDocumento: '12345678',
    email: 'maria.gonzalez@example.com',
    telefono: '+51 987654321',
  ),
  // Más clientes...
];
```

**Para cambiar los datos de prueba:**
1. Abre el archivo anterior
2. Modifica la lista `_mockCustomers`
3. Agrega o elimina clientes según necesites

---

## 🔌 Integración en main.dart

El módulo ya está registrado en `main.dart`:

```dart
routes: {
  '/clientes': (context) => const CustomersListPage(),
  // ... otras rutas
}
```

**Para navegar al módulo:**

```dart
// Desde cualquier parte de la app
Navigator.pushNamed(context, '/clientes');

// O con Navigator.push (mantiene historial)
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const CustomersListPage()),
);
```

---

## 🐛 Manejo de Errores

El módulo maneja automáticamente:

### Errores de Conexión
- Sin internet → muestra mensaje
- Timeout → muestra mensaje
- Server no disponible → muestra mensaje

### Errores de Datos
- JSON inválido → intenta procesar con valores por defecto
- Campos faltantes → usa valores vacíos

### Estados de Error
- Mensaje claro del error
- Botón "Reintentar"
- Log en consola (para debug)

---

## 🔍 Búsqueda y Filtrado

**Características:**
- Búsqueda en tiempo real (sin necesidad de presionar Enter)
- Búsqueda por nombre completo
- Búsqueda por número de documento
- Case-insensitive (mayúsculas/minúsculas)
- Búsqueda parcial (escribe "juan" para "Juan Pérez")

**Cómo funciona:**

```dart
void filterByQuery(String query) {
  final normalizedQuery = query.trim().toLowerCase();

  if (normalizedQuery.isEmpty) {
    filteredCustomers = customers;  // Muestra todos
  } else {
    filteredCustomers = customers.where((customer) {
      final nombre = customer.nombre.toLowerCase();
      final documento = customer.numeroDocumento.toLowerCase();
      return nombre.contains(normalizedQuery) ||
             documento.contains(normalizedQuery);
    }).toList();
  }

  notifyListeners();
}
```

---

## 📦 Dependencias

El módulo usa:
- **flutter**: Framework base
- **provider**: Gestión de estado (ya en `pubspec.yaml`)
- **http**: Cliente HTTP para API REST (ya en `pubspec.yaml`)

No hay dependencias adicionales necesarias.

---

## ✅ Checklist de Implementación

### Para usar con datos de prueba:
- [x] Código ya está listo
- [x] Datos de prueba incluidos
- [x] Solo ejecuta la app

### Para conectar con API real:
- [ ] Obtén la URL de tu backend
- [ ] Obtén el endpoint para clientes
- [ ] Modifica `baseUrl` en `customers_list_page.dart`
- [ ] Cambia `useMockData: false`
- [ ] Ajusta `customer_model.dart` si los campos JSON son diferentes
- [ ] Prueba la conexión
- [ ] Verifica en DevTools → Network

---

## 🧑‍💻 Ejemplos de Uso

### Navegar al listado de clientes
```dart
ElevatedButton(
  onPressed: () => Navigator.pushNamed(context, '/clientes'),
  child: const Text('Ver Clientes'),
);
```

### Agregar búsqueda desde otro módulo
```dart
// El módulo ya tiene búsqueda integrada
// No necesitas hacer nada extra
```

### Personalizar los colores
Los colores primarios están en `main.dart`:
```dart
const Color primaryColor = Color(0xFF00C853);  // Verde Kajamart
```

Actualiza este color en `theme.dart` si deseas cambiar la paleta.

---

## 📚 Estructura de Ficheros Completa

```
lib/client/customers/
├── README.md (Este archivo)
├── data/
│   ├── datasources/
│   │   └── customers_remote_data_source.dart
│   ├── models/
│   │   └── customer_model.dart
│   └── repositories/
│       └── customers_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── customer.dart
│   └── repositories/
│       └── customers_repository.dart
└── presentation/
    ├── pages/
    │   ├── customers_list_page.dart
    │   └── customer_detail_page.dart
    ├── providers/
    │   └── customers_notifier.dart
    └── widgets/
        └── customer_card.dart
```

---

## 🎓 Próximos Pasos

1. **Conectar API real**
   - Cambia baseUrl
   - Cambia useMockData a false
   - Ajusta campos JSON si es necesario

2. **Agregar más campos**
   - Añade campos a `Customer`
   - Actualiza `CustomerModel.fromJson()`
   - Actualiza UI en `customer_card.dart` y `customer_detail_page.dart`

3. **Agregar funcionalidades** (si se necesitan después)
   - Filtros avanzados
   - Ordenamiento
   - Paginación
   - Descargar como PDF
   - Etc.

---

## ❓ Preguntas Frecuentes

**P: ¿Puedo editar/eliminar clientes?**
R: No, este módulo es solo lectura. Si necesitas CRUD completo, contacta al equipo.

**P: ¿Los datos se sincronizan automáticamente?**
R: No. El usuario debe presionar "Recargar" o entrar nuevamente a la pantalla.

**P: ¿Funciona sin internet?**
R: Solo con datos de prueba (mock data). La API real requiere conexión.

**P: ¿Cómo agrego autenticación?**
R: Modifica `CustomersRemoteDataSource.fetchCustomers()` para agregar headers de autenticación.

---

**Última actualización:** Diciembre 2025
**Autor:** Sistema Kajamart
**Estado:** ✅ Producción

