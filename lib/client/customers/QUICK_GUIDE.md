# 🎯 Guía Rápida Visual - Módulo de Clientes

## 📍 Ubicación del Módulo en tu Proyecto

```
Tu Proyecto Kajamart
│
├─📁 lib/
│  ├─ main.dart .................. ⭐ PUNTO DE ENTRADA (ya integrado)
│  │
│  ├─📁 admin/
│  │  ├─ screens/
│  │  ├─ pages/
│  │  └─ ... (módulo admin)
│  │
│  ├─📁 client/
│  │  ├─📁 customers/ ........... ⭐ TU MÓDULO NUEVO
│  │  │  ├─ README.md ........... Documentación principal
│  │  │  ├─ EXAMPLES.md ......... Ejemplos de uso
│  │  │  ├─ TROUBLESHOOTING.md .. Solución de problemas
│  │  │  ├─ ARCHITECTURE.md ..... Diagramas de arquitectura
│  │  │  │
│  │  │  ├─📁 data/ ............. CAPA DE DATOS
│  │  │  ├─📁 domain/ ........... CAPA DE DOMINIO
│  │  │  ├─📁 presentation/ ..... CAPA DE PRESENTACIÓN
│  │  │  ├─📁 constants/ ........ CONSTANTES
│  │  │  └─📁 utils/ ............ UTILIDADES
│  │  │
│  │  ├─ screens/
│  │  │  └─ home_screen.dart (puedes agregar botón aquí)
│  │  │
│  │  └─ pages/
│  │     ├─ login_page.dart
│  │     └─ ...
│  │
│  └─ ... (otros módulos)
│
└─📁 assets/
   └─ images/
```

---

## 🚀 Inicio Rápido (5 pasos)

### Paso 1: Ejecuta la App
```bash
flutter run
```

### Paso 2: Navega a Clientes
```
Toca el botón que diga "Clientes" o navega a /clientes
```

### Paso 3: Verás la Lista
```
┌──────────────────────────┐
│ Clientes                 │
├──────────────────────────┤
│ 🔍 Buscar cliente...     │
├──────────────────────────┤
│ ┌────────────────────┐   │
│ │ M María González   │   │
│ │   DNI: 12345678    │   │
│ │   ☎ +51 987654321  │   │
│ │   ✉ maria@...      │   │
│ └────────────────────┘   │
└──────────────────────────┘
```

### Paso 4: Busca o Haz Clic
```
Escribe "maria" en la búsqueda → Se filtra en tiempo real
O haz clic en una tarjeta → Ve al detalle
```

### Paso 5: ¡Listo! 🎉
```
Ya está funcionando con datos de prueba
```

---

## 🔄 Flujo de Uso - Diagrama

```
┌─────────────────────────────────────────────────────────────┐
│ USUARIO                                                      │
└────────────────┬────────────────────────────────────────────┘
                 │
    ┌────────────┴────────────┐
    │ Abre la app             │
    │ Navega a /clientes      │
    └────────────┬────────────┘
                 │
                 ▼
    ┌──────────────────────────────────┐
    │ CustomersListPage CARGA          │
    │ (notifier.loadCustomers())       │
    │                                  │
    │ Estado: LOADING 🔄               │
    │ Muestra: CircularProgressIndicator
    └────────────┬────────────────────┘
                 │
        ┌────────┴────────┐
        │ ¿Éxito?         │
        ▼                 ▼
    SÍ                    NO
    │                     │
    ▼                     ▼
┌──────────────────┐  ┌──────────────────────┐
│ Estado: LOADED   │  │ Estado: ERROR        │
│ Muestra: LISTA   │  │ Muestra: Mensaje +   │
│ 6 clientes       │  │ Botón "Reintentar"   │
└────────┬─────────┘  └──────────┬───────────┘
         │                       │
         ├─────────────┬─────────┤
         │             │         │
    (Usuario interactúa)         │
         │             │         │ (toca Reintentar)
         ▼             ▼         ▼
    ┌─────────┐  ┌──────────┐   └─→ (vuelve a LOADING)
    │ Escribe │  │ Toca un  │
    │ en      │  │ cliente  │
    │ Busca   │  │          │
    └────┬────┘  └────┬─────┘
         │            │
         ▼            ▼
    Filtra en      Navega a
    memoria        CustomerDetailPage
    │              │
    │ Muestra      │ Muestra TODOS
    │ resultados   │ los datos
    │              │
    ▼              ▼
 ┌────────────┐   ┌──────────────────┐
 │ LISTA      │   │ DETALLE          │
 │ FILTRADA   │   │ ─────────────    │
 │            │   │ Nombre: María    │
 │ María      │   │ DNI: 12345678    │
 │ González   │   │ Email: ...       │
 │            │   │ Teléfono: ...    │
 │ (0/4       │   │                  │
 │  resultados)   │ [Botón Atrás]    │
 └────────────┘   └──────────────────┘
```

---

## 🎨 Pantallas Visuales

### Pantalla 1: Lista con Búsqueda

```
╔════════════════════════════════════════╗
║         Clientes            [🏠]       ║  ← AppBar
╠════════════════════════════════════════╣
║ ┌──────────────────────────────────┐   ║
║ │🔍 Buscar por nombre... [🅇]      │   ║  ← TextField
║ └──────────────────────────────────┘   ║
║ 6 clientes  [🔄 Recargar]               ║  ← Info
╠════════════════════════════════════════╣
║                                        ║
║ ┌──────────────────────────────────┐   ║
║ │[M] María González López        > │   ║  ← CustomerCard
║ │    DNI: 12345678               │ │   ║
║ │    ☎ +51 987654321             │ │   ║
║ │    ✉ maria.gonzalez@...        │ │   ║
║ └──────────────────────────────────┘   ║
║                                        ║
║ ┌──────────────────────────────────┐   ║
║ │[J] Juan Pérez Rodríguez        > │   ║
║ │    DNI: 87654321               │ │   ║
║ │    ☎ +51 912345678             │ │   ║
║ │    ✉ juan.perez@...            │ │   ║
║ └──────────────────────────────────┘   ║
║                                        ║
║ ┌──────────────────────────────────┐   ║
║ │[L] Lucía Fernández García      > │   ║
║ │    Pasaporte: X1234567         │ │   ║
║ │    ☎ +34 612345678             │ │   ║
║ │    ✉ lucia.fernandez@...       │ │   ║
║ └──────────────────────────────────┘   ║
║                                        ║
║ ... (más clientes)                     ║
║                                        ║
╚════════════════════════════════════════╝
```

### Pantalla 2: Detalle del Cliente

```
╔════════════════════════════════════════╗
║ < Detalle del Cliente                  ║  ← AppBar
╠════════════════════════════════════════╣
║                                        ║
║  ┌──────────────────────────────────┐  ║
║  │ ┌────┐  María González López      │  ║
║  │ │ M  │  ID: 1                     │  ║
║  │ └────┘                            │  ║
║  └──────────────────────────────────┘  ║
║                                        ║
║  ┌──────────────────────────────────┐  ║
║  │ 📋 Información Personal           │  ║
║  │ ──────────────────────────────  │  ║
║  │ Nombre Completo                 │  ║
║  │ María González López            │  ║
║  │                                 │  ║
║  │ Tipo de Documento               │  ║
║  │ DNI                             │  ║
║  │                                 │  ║
║  │ Número de Documento             │  ║
║  │ 12345678                        │  ║
║  └──────────────────────────────────┘  ║
║                                        ║
║  ┌──────────────────────────────────┐  ║
║  │ 📞 Información de Contacto       │  ║
║  │ ──────────────────────────────  │  ║
║  │ [✉] Correo Electrónico          │  ║
║  │     maria.gonzalez@example.com  │  ║
║  │                                 │  ║
║  │ [☎] Teléfono                    │  ║
║  │     +51 987654321               │  ║
║  └──────────────────────────────────┘  ║
║                                        ║
║  ┌──────────────────────────────────┐  ║
║  │ ⚙️  Opciones                     │  ║
║  │ ──────────────────────────────  │  ║
║  │ [☎ Llamar]      [✉ Email]       │  ║
║  └──────────────────────────────────┘  ║
║                                        ║
╚════════════════════════════════════════╝
```

---

## 📝 Estados Visuales

### Estado 1: Cargando
```
╔════════════════════════════════════════╗
║         Clientes                       ║
╠════════════════════════════════════════╣
║                                        ║
║                                        ║
║           ⏳ Cargando clientes...       ║
║                                        ║
║              (animación)                ║
║                                        ║
║                                        ║
╚════════════════════════════════════════╝
```

### Estado 2: Cargado (Éxito)
```
╔════════════════════════════════════════╗
║         Clientes                       ║
╠════════════════════════════════════════╣
║ 6 clientes                             ║
║                                        ║
║ ┌──────────────────────────────────┐   ║
║ │ Cliente 1 ...                    │   ║
║ └──────────────────────────────────┘   ║
║ ┌──────────────────────────────────┐   ║
║ │ Cliente 2 ...                    │   ║
║ └──────────────────────────────────┘   ║
║                                        ║
╚════════════════════════════════════════╝
```

### Estado 3: Error
```
╔════════════════════════════════════════╗
║         Clientes                       ║
╠════════════════════════════════════════╣
║                                        ║
║                                        ║
║      ❌ Error al cargar clientes       ║
║                                        ║
║   Error de conexión. Verifica tu       ║
║        conexión a internet.            ║
║                                        ║
║           [🔄 Reintentar]               ║
║                                        ║
║                                        ║
╚════════════════════════════════════════╝
```

### Estado 4: Sin Resultados
```
╔════════════════════════════════════════╗
║         Clientes                       ║
╠════════════════════════════════════════╣
║ 👤 Buscar por nombre... [🅇]           ║
║                                        ║
║                                        ║
║      👥 No se encontraron clientes     ║
║                                        ║
║   Intenta con otros términos de        ║
║         búsqueda                       ║
║                                        ║
║                                        ║
╚════════════════════════════════════════╝
```

---

## 🔌 Cómo Conectar Tu API

### Paso 1: Encuentra estos Valores
```
✅ URL base de tu API:
   ejemplo: https://api.miempresa.com

✅ Endpoint para clientes:
   ejemplo: /clientes o /api/v1/customers

✅ (Opcional) Token de autenticación
   si tu API requiere autenticación
```

### Paso 2: Abre el Archivo
```
📁 lib/
   └─ client/
      └─ customers/
         └─ presentation/
            └─ pages/
               └─ customers_list_page.dart   ← ABRE ESTE
```

### Paso 3: Cambia Estas Líneas
```dart
CustomersRepository _buildRepository() {
  // ⬇️ LÍNEA 1: Cambia esto
  const String baseUrl = 'https://api.tu-dominio.com';
  
  return CustomersRepositoryImpl(
    remoteDataSource: CustomersRemoteDataSource(baseUrl: baseUrl),
    useMockData: false,  // ⬇️ LÍNEA 2: Cambia a false
  );
}
```

### Paso 4: (Opcional) Ajusta Endpoint
```dart
// Si tu endpoint no es /clientes, también cambia esto:
CustomersRemoteDataSource(
  baseUrl: baseUrl,
  customersEndpoint: '/api/v1/customers',  // ← Tu endpoint
)
```

### Paso 5: (Si necesario) Ajusta JSON
```dart
// En lib/client/customers/data/models/customer_model.dart
factory CustomerModel.fromJson(Map<String, dynamic> json) {
  return CustomerModel(
    id: json['id'].toString(),
    nombre: json['nombreCliente'] ?? '',  // ← Ajusta nombres si es necesario
    tipoDocumento: json['tipo_doc'] ?? '',
    numeroDocumento: json['numero_doc'] ?? '',
    email: json['email_cliente'] ?? '',
    telefono: json['telefono'] ?? '',
  );
}
```

---

## 📞 Búsqueda Visual

### Búsqueda en Tiempo Real
```
Usuario escribe:  "j"
                  ↓
              Filtra
                  ↓
Muestra:     "Juan Pérez"
             "Lucía Fernández"

Usuario escribe:  "ja"
                  ↓
              Filtra
                  ↓
Muestra:     "Juan Pérez"

Usuario escribe:  "12345"
                  ↓
              Filtra por documento
                  ↓
Muestra:     "María González" (DNI: 12345678)
```

---

## 🎯 Arquitetura Simplificada

```
           USUARIO
             │
             ▼ (interactúa)
    ┌────────────────────┐
    │  PRESENTACIÓN      │  ← Lo que ve
    │  (Pantallas)       │
    └────────┬───────────┘
             │
             ▼ (pide datos)
    ┌────────────────────┐
    │  LÓGICA DE ESTADO  │  ← Lo que controla
    │  (Notifier)        │
    └────────┬───────────┘
             │
             ▼ (pide datos)
    ┌────────────────────┐
    │  DOMINIO           │  ← Las reglas
    │  (Interfaz)        │
    └────────┬───────────┘
             │
             ▼ (obtiene datos)
    ┌────────────────────┐
    │  DATOS             │  ← De dónde vienen
    │  (API/Mock)        │
    └────────────────────┘
```

---

## 📚 Archivos de Referencia Rápida

| Archivo | Cambios Necesarios | Cuando |
|---------|-------------------|--------|
| `customers_list_page.dart` | baseUrl, useMockData | Conectar API real |
| `customer_model.dart` | Nombres de campos JSON | Si JSON es diferente |
| `constants.dart` | URLs, mensajes | Configuración global |
| `config.example.dart` | Ambiente (dev/prod) | Multi-ambiente |

---

## ✨ Características Principales

```
1. BÚSQUEDA EN TIEMPO REAL
   Escribe → Se filtra automáticamente

2. CLICK EN CLIENTE
   Toca tarjeta → Ve detalle completo

3. MANEJO DE ERRORES
   Error → Muestra mensaje → Botón reintentar

4. INDICADORES VISUALES
   Cargando 🔄 → Cargado ✅ → Error ❌

5. DATOS DE PRUEBA
   Sin API → Funciona con datos mock

6. INFORMACIÓN FORMATEADA
   Teléfonos, emails, documentos → Bonito

7. AVATARES PERSONALIZADOS
   Inicial del nombre → Fondo verde
```

---

## 🎓 Aprendiste

Durante este desarrollo implementaste:

✅ Clean Architecture (separación de capas)
✅ Gestión de estado (Provider/ChangeNotifier)
✅ Llamadas HTTP (http package)
✅ Serialización JSON
✅ Validación y formateo de datos
✅ Manejo de errores
✅ Navegación entre pantallas
✅ Widgets reutilizables
✅ Documentación profesional

**¡Felicidades! Ahora tienes un módulo production-ready 🚀**

---

**Última actualización:** 10 de Diciembre 2025
**Versión:** 1.0.0
**Estado:** ✅ Listo para Producción

