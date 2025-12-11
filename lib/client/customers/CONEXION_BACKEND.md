# 🔌 Conexión al Backend - Guía Rápida

## Tu Backend Conectado

**URL:** `http://localhost:3000/kajamart/api/clients`  
**Método:** GET  
**Formato:** JSON array de objetos cliente

---

## ✅ Cambios Realizados

### 1. **Modelo Actualizado** (`customer_model.dart`)
El `CustomerModel.fromJson` ahora mapea automáticamente los campos de tu backend:

```
Backend              →  App
id_cliente           →  id
nombre_cliente       →  nombre
tipo_docume          →  tipoDocumento
numero_doc           →  numeroDocumento
correo_cliente       →  email
telefono_cliente     →  telefono
estado_cliente       →  (ignorado por ahora)
```

### 2. **Conexión Configurada** (`customers_list_page.dart`)
```dart
const String baseUrl = 'http://localhost:3000/kajamart/api';
const String customersEndpoint = '/clients';
useMockData: false;  // ← Usa datos reales del backend
```

---

## 🚀 Pasos para Probar

### 1. Asegúrate que tu backend está corriendo
```powershell
# En tu carpeta del backend Node.js:
npm start
# Deberías ver: "Server running on port 3000"
```

### 2. Inicia la app Flutter
```powershell
# Desde la raíz del proyecto Flutter:
flutter run
```

### 3. Navega a `/clientes`
- En la app, ve a la pantalla de clientes
- Deberías ver **al menos el "Cliente de Caja"** (id_cliente: 0)
- Si hay más clientes en tu BD, también aparecerán

### 4. Prueba la búsqueda
- Busca "Cliente de Caja" o "Caja"
- Busca por número de documento
- El filtrado funciona en tiempo real

---

## 🔍 Verificación

### ✅ Debe funcionar automáticamente:
- [x] GET `/clients` → obtiene lista
- [x] Mapeo de campos backend → app
- [x] Búsqueda por nombre
- [x] Búsqueda por documento
- [x] Click en cliente → detalles
- [x] Volver atrás

### ⚠️ Si algo no funciona:

**Error: "No se pueden cargar los clientes"**
```
→ Verifica que el backend está corriendo en puerto 3000
→ Prueba en curl: curl http://localhost:3000/kajamart/api/clients
```

**Error: "Error de conexión"**
```
→ En iOS Simulator: usa 10.0.2.2 en lugar de localhost
→ En Android Emulator: usa 10.0.2.2
→ En dispositivo real: usa tu IP local (ej: 192.168.x.x)
```

**La lista está vacía (solo Caja)**
```
→ Verifica que tu BD tiene clientes insertados
→ Revisa logs del backend para errores SQL
```

---

## 🔧 Cambiar URL del Backend (si es necesario)

Abre `lib/client/customers/presentation/pages/customers_list_page.dart` y modifica:

```dart
// Para desarrollo local con Android Emulator:
const String baseUrl = 'http://10.0.2.2:3000/kajamart/api';

// Para dispositivo real en la misma red:
const String baseUrl = 'http://192.168.1.100:3000/kajamart/api';  // usa tu IP

// Para producción:
const String baseUrl = 'https://api.tu-dominio.com/kajamart/api';
```

---

## 📱 Por Plataforma

### iOS Simulator
```dart
const String baseUrl = 'http://localhost:3000/kajamart/api';  // funciona directo
```

### Android Emulator
```dart
const String baseUrl = 'http://10.0.2.2:3000/kajamart/api';  // 10.0.2.2 = localhost
```

### Dispositivo Real (Android/iOS)
```dart
// Reemplaza 192.168.1.100 con tu IP local
const String baseUrl = 'http://192.168.1.100:3000/kajamart/api';
```

---

## 🔐 Con Autenticación (Opcional)

Si tu backend requiere Bearer token:

```dart
CustomersRepository _buildRepository() {
  const String baseUrl = 'http://localhost:3000/kajamart/api';
  const String bearerToken = 'TU_TOKEN_AQUI';  // obtén del login
  
  return CustomersRepositoryImpl(
    remoteDataSource: CustomersRemoteDataSource(
      baseUrl: baseUrl,
      customersEndpoint: '/clients',
      defaultHeaders: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    ),
    useMockData: false,
  );
}
```

---

## 📝 Información Técnica

### Request
```
GET http://localhost:3000/kajamart/api/clients HTTP/1.1
Accept: application/json
```

### Response (200)
```json
[
  {
    "id_cliente": 0,
    "nombre_cliente": "Cliente de Caja",
    "tipo_docume": "N/A",
    "numero_doc": "N/A",
    "correo_cliente": "caja@correo.com",
    "telefono_cliente": "N/A",
    "estado_cliente": true
  },
  {
    "id_cliente": 1,
    "nombre_cliente": "Juan Pérez",
    "tipo_docume": "DNI",
    "numero_doc": "12345678",
    "correo_cliente": "juan@example.com",
    "telefono_cliente": "+51 987654321",
    "estado_cliente": true
  }
]
```

### Errores Esperados
- **401 Unauthorized** → Token inválido o expirado
- **404 Not Found** → Endpoint `/clients` no existe
- **500 Server Error** → Error en backend (revisa logs Node.js)

---

## 🎯 Resumen Rápido

| Acción | Archivo | Línea |
|--------|---------|-------|
| Cambiar URL | `customers_list_page.dart` | 18-19 |
| Mapeo de campos | `customer_model.dart` | 27-35 |
| Ver datos mock (si necesitas) | `customers_remote_data_source.dart` | 50+ |
| Agregar headers/token | `customers_list_page.dart` | 21-25 |

---

## ✨ Siguiente Paso

Una vez que funcione la lista:
- [ ] Prueba la búsqueda
- [ ] Abre detalles de un cliente
- [ ] Verifica que todos los datos se ven bien
- [ ] Si hay problemas, revisa TROUBLESHOOTING.md

---

**Versión:** 1.0.0  
**Fecha:** 10 Diciembre 2025  
**Estado:** ✅ Conectado al Backend

