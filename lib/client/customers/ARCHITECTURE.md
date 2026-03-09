# 📁 Estructura Visual del Módulo de Clientes

## Diagrama de Carpetas

```
kajamart_movile/
│
└─ lib/
   │
   ├─ main.dart (✅ YA INTEGRADO - Ruta '/clientes')
   │
   └─ client/
      │
      ├─ customers/ ⭐ MÓDULO NUEVO
      │  │
      │  ├─ 📄 00_START_HERE.md ................... ⭐ EMPIEZA AQUÍ
      │  ├─ 📄 README.md ......................... Documentación principal
      │  ├─ 📄 EXAMPLES.md ....................... 10+ ejemplos de uso
      │  ├─ 📄 TROUBLESHOOTING.md ................ Solución de problemas
      │  ├─ 📄 CHANGELOG.md ...................... Historial de cambios
      │  ├─ 📄 config.example.dart ............... Configuración por ambiente
      │  │
      │  ├─ constants/
      │  │  └─ 📄 constants.dart ................. Constantes centralizadas
      │  │
      │  ├─ data/ (Capa de Datos)
      │  │  ├─ datasources/
      │  │  │  └─ 📄 customers_remote_data_source.dart
      │  │  │     └─ Responsabilidades:
      │  │  │        • Llamadas HTTP a la API
      │  │  │        • Deserialización de JSON
      │  │  │        • Datos de prueba (mock data)
      │  │  │        • Manejo básico de errores HTTP
      │  │  │
      │  │  ├─ models/
      │  │  │  └─ 📄 customer_model.dart
      │  │  │     └─ Responsabilidades:
      │  │  │        • Extiende entidad Customer
      │  │  │        • Método fromJson() para deserialización
      │  │  │        • Método toJson() para serialización
      │  │  │
      │  │  └─ repositories/
      │  │     └─ 📄 customers_repository_impl.dart
      │  │        └─ Responsabilidades:
      │  │           • Implementa CustomersRepository
      │  │           • Delega al datasource remoto
      │  │           • Punto central de datos
      │  │
      │  ├─ domain/ (Capa de Dominio - Lógica de Negocio)
      │  │  ├─ entities/
      │  │  │  └─ 📄 customer.dart
      │  │  │     └─ Responsabilidades:
      │  │  │        • Define la entidad Cliente
      │  │  │        • Campos: id, nombre, tipo doc, número doc, email, teléfono
      │  │  │        • Sin lógica de persistencia
      │  │  │
      │  │  └─ repositories/
      │  │     └─ 📄 customers_repository.dart
      │  │        └─ Responsabilidades:
      │  │           • Interfaz/contrato para repositorio
      │  │           • Define métodos que debe tener cualquier repositorio
      │  │
      │  ├─ presentation/ (Capa de Presentación - UI)
      │  │  ├─ pages/
      │  │  │  ├─ 📄 customers_list_page.dart
      │  │  │  │  └─ Responsabilidades:
      │  │  │  │     • Pantalla principal del módulo
      │  │  │  │     • Configura el Provider/ChangeNotifier
      │  │  │  │     • Muestra lista con búsqueda
      │  │  │  │     • Maneja navegación al detalle
      │  │  │  │
      │  │  │  └─ 📄 customer_detail_page.dart
      │  │  │     └─ Responsabilidades:
      │  │  │        • Pantalla de detalle del cliente
      │  │  │        • Muestra toda la información
      │  │  │        • Solo lectura (no edita)
      │  │  │        • Scroll automático
      │  │  │
      │  │  ├─ providers/
      │  │  │  └─ 📄 customers_notifier.dart
      │  │  │     └─ Responsabilidades:
      │  │  │        • Gestión de estado (ChangeNotifier)
      │  │  │        • Métodos: loadCustomers(), filterByQuery()
      │  │  │        • Estados: inicial, cargando, cargado, error
      │  │  │
      │  │  └─ widgets/
      │  │     └─ 📄 customer_card.dart
      │  │        └─ Responsabilidades:
      │  │           • Tarjeta visual reutilizable
      │  │           • Muestra información resumida
      │  │           • Avatar con inicial
      │  │           • Navegable al detalle
      │  │
      │  └─ utils/ (Utilidades)
      │     ├─ 📄 formatting_utils.dart
      │     │  └─ Funciones de utilidad:
      │     │     • formatPhoneNumber()
      │     │     • formatEmail()
      │     │     • formatDocumentNumber()
      │     │     • getInitials()
      │     │     • isValidEmail()
      │     │     • isValidPhone()
      │     │     • isValidName()
      │     │     • truncateText()
      │     │     • capitalizeWords()
      │     │     • Y más...
      │     │
      │     └─ 📄 exceptions.dart
      │        └─ Excepciones personalizadas:
      │           • CustomersException (base)
      │           • NetworkException
      │           • UnauthorizedException
      │           • NotFoundException
      │           • ServerException
      │           • JsonException
      │           • DataValidationException
      │           • UnknownException
      │           • ExceptionHandler (utilidad)
      │
      ├─ pages/
      │  ├─ login_page.dart
      │  ├─ recover_password.dart
      │  └─ check_email_page.dart
      │
      └─ screens/
         └─ home_screen.dart

   ├─ admin/
   │  ├─ constants/
   │  ├─ data/
   │  ├─ models/
   │  ├─ pages/
   │  ├─ screens/
   │  └─ services/
   │
   └─ (otros módulos...)
```

## 🔄 Flujo de Datos (Arquitectura)

```
┌─────────────────────────────────────────────────────────────────┐
│                         USUARIO (UI)                             │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                    (interactúa con la UI)
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│          PRESENTATION LAYER (customers_list_page)               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  CustomersListPage (StatelessWidget)                     │   │
│  │  └─ Configura ChangeNotifierProvider                     │   │
│  │     └─ CustomersNotifier (ChangeNotifier)               │   │
│  │                                                          │   │
│  │  _CustomersListView (StatefulWidget)                     │   │
│  │  └─ Consumer<CustomersNotifier>                          │   │
│  │     ├─ Muestra lista de clientes                        │   │
│  │     ├─ Barra de búsqueda                                │   │
│  │     ├─ Indicadores de estado                            │   │
│  │     └─ CustomerCard (widget reutilizable)               │   │
│  │                                                          │   │
│  │  CustomerDetailPage                                      │   │
│  │  └─ Muestra detalle del cliente seleccionado             │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
             (notifier.loadCustomers(),
              notifier.filterByQuery())
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│             STATE MANAGEMENT (customers_notifier)                │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  CustomersNotifier (ChangeNotifier)                      │   │
│  │  ├─ status: CustomersStatus                             │   │
│  │  ├─ customers: List<Customer>                           │   │
│  │  ├─ filteredCustomers: List<Customer>                   │   │
│  │  ├─ errorMessage: String                                │   │
│  │  │                                                       │   │
│  │  ├─ loadCustomers() async                               │   │
│  │  │  └─ Carga clientes del repositorio                   │   │
│  │  │                                                       │   │
│  │  └─ filterByQuery(String query)                         │   │
│  │     └─ Filtra clientes por nombre/documento             │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                    (repository.getCustomers())
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│              DOMAIN LAYER (Lógica de Negocio)                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  CustomersRepository (Interfaz/Contrato)                │   │
│  │  └─ getCustomers(): Future<List<Customer>>              │   │
│  │                                                          │   │
│  │  Customer (Entidad)                                      │   │
│  │  ├─ id                                                  │   │
│  │  ├─ nombre                                              │   │
│  │  ├─ tipoDocumento                                       │   │
│  │  ├─ numeroDocumento                                     │   │
│  │  ├─ email                                               │   │
│  │  └─ telefono                                            │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                  (remoteDataSource.fetchCustomers())
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│               DATA LAYER (Fuente de Datos)                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  CustomersRepositoryImpl (Implementación)                │   │
│  │  └─ Delega al datasource remoto                         │   │
│  │                                                          │   │
│  │  CustomersRemoteDataSource                              │   │
│  │  ├─ fetchCustomers(useMockData): Future<List<...>>      │   │
│  │  │                                                       │   │
│  │  ├─ Si useMockData = true                               │   │
│  │  │  └─ Retorna datos de prueba (_mockCustomers)         │   │
│  │  │                                                       │   │
│  │  └─ Si useMockData = false                              │   │
│  │     ├─ GET $baseUrl$customersEndpoint                  │   │
│  │     ├─ Parsea JSON                                      │   │
│  │     └─ Retorna List<CustomerModel>                      │   │
│  │                                                          │   │
│  │  CustomerModel (Modelo)                                 │   │
│  │  ├─ Extiende Customer                                   │   │
│  │  ├─ fromJson(Map) - Deserialización                     │   │
│  │  └─ toJson() - Serialización                            │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                  (HTTP GET request a la API)
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                     API REST (Backend)                           │
│                                                                  │
│  GET https://api.tu-dominio.com/clientes                         │
│                                                                  │
│  Response:                                                       │
│  [                                                               │
│    {                                                             │
│      "id": "1",                                                  │
│      "nombre": "María González",                                 │
│      "tipoDocumento": "DNI",                                     │
│      "numeroDocumento": "12345678",                              │
│      "email": "maria@example.com",                               │
│      "telefono": "+51 987654321"                                │
│    },                                                            │
│    { ... mas clientes ... }                                      │
│  ]                                                               │
└─────────────────────────────────────────────────────────────────┘
```

## 📊 Estados de la Aplicación

```
┌──────────────┐
│   INITIAL    │  (Estado inicial, antes de cargar datos)
└──────┬───────┘
       │ (usuario abre la pantalla)
       ▼
┌──────────────┐
│   LOADING    │  (Cargando datos del servidor)
└──────┬───────┘
       │
       ├─── (error) ──────────┐
       │                       ▼
       │                   ┌──────────┐
       │                   │  ERROR   │  Muestra mensaje de error
       │                   └──────┬───┘
       │                          │ (usuario presiona Reintentar)
       │                          └─────────┐
       │                                    ▼ (vuelve a LOADING)
       │
       └─── (éxito) ──────────┐
                               ▼
                          ┌──────────┐
                          │  LOADED  │  Muestra lista de clientes
                          └──────┬───┘
                                 │
                                 ├─── (busca/filtra) ───┐
                                 │                      │ (filtra en memoria)
                                 │                      ▼
                                 │                   [Muestra resultados]
                                 │
                                 └─── (recarga) ────────┐
                                                        │ (vuelve a LOADING)
                                                        ▼
```

## 🧩 Componentes Clave

### 1. **CustomersListPage**
```
entrada principal → configura Provider → inicia carga
```

### 2. **CustomersNotifier**
```
administra estado → notifica cambios → proveedores escuchan
```

### 3. **CustomersRemoteDataSource**
```
decide: mock o API → obtiene datos → deserializa JSON
```

### 4. **CustomerCard**
```
recibe Customer → renderiza tarjeta → permite navegación
```

### 5. **CustomerDetailPage**
```
recibe Customer → muestra todos los datos → scroll automático
```

## 🔌 Puntos de Integración

```
┌─────────────────────────────────────────────────┐
│  main.dart                                       │
│  ├─ routes: { '/clientes': CustomersListPage }  │
│  └─ Tema: primaryColor = 0xFF00C853 (verde)     │
└─────────────────────────────────────────────────┘
                          │
         (usuario navega a /clientes)
                          ▼
      ┌──────────────────────────────────┐
      │  CustomersListPage               │
      │  (entrada al módulo)             │
      └──────────────────────────────────┘
```

## 📦 Dependencias Utilizadas

```
pubspec.yaml
├─ flutter (framework base)
├─ provider: ^6.1.1 (gestión de estado) ⭐
├─ http: ^1.2.1 (cliente HTTP) ⭐
└─ intl: ^0.19.0 (localización)

⭐ = Usadas por este módulo
```

## ✨ Características Destacadas

```
1. BÚSQUEDA EN TIEMPO REAL
   User escribe → notifier.filterByQuery() → UI se actualiza
   
2. MANEJO DE ERRORES
   Error → CustomersStatus.error → Muestra mensaje + botón Reintentar
   
3. MOCK DATA
   useMockData = true → datos de prueba sin API
   useMockData = false → datos de API real
   
4. CLEAN ARCHITECTURE
   Data → Domain → Presentation (separación clara)
   
5. VALIDACIÓN Y FORMATEO
   Teléfonos, emails, documentos formateados automáticamente
   
6. DOCUMENTACIÓN
   Código documentado + guías + ejemplos + troubleshooting
```

---

**Versión:** 1.0.0
**Estado:** ✅ Producción

