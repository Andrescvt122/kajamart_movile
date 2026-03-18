# 🔧 Debugging - Clientes no se cargan

## Paso 1: Verifica que el backend está corriendo

```powershell
# En una terminal, ve a la carpeta del backend:
cd tu-carpeta-backend
npm start

# Deberías ver algo como:
# Server running on port 3000
```

## Paso 2: Prueba la URL en Postman o curl

```powershell
# En PowerShell, prueba:
curl -v https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients

# Deberías ver:
# - Status: 200
# - Body: Array JSON de clientes
```

Si obtienes error:
- **Error de conexión**: El backend no está corriendo
- **404**: La URL o endpoint está mal
- **Vacío o null**: Tu BD no tiene datos

---

## Paso 3: Revisa los logs de Flutter

Cuando ejecutas `flutter run`, en la consola busca mensajes azules (logs) como:

```
🔵 [Clientes] Intentando GET a: https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients
```

Y después deberías ver:

```
🟢 [Clientes] Response status: 200
🟢 [Clientes] Clientes parseados: 1
```

Si ves un error rojo:
```
🔴 [Clientes] Error de conexión: ...
```

---

## Paso 4: Soluciones Rápidas

| Síntoma | Causa | Solución |
|---------|-------|----------|
| `Timeout: El servidor tardó demasiado` | Backend lento | Reinicia backend, cambia timeout a 30 segundos |
| `Error de conexión` | Backend no corre | `npm start` en tu carpeta backend |
| `Endpoint no encontrado (404)` | URL incorrecta | Verifica `/clients` vs `/clientes` |
| `No autorizado (401)` | Falta token | Agrega Bearer token en headers |
| `Error inesperado` | JSON mal formado | Verifica que backend retorna array válido |
| Lista vacía pero sin error | BD sin datos | Inserta clientes en base de datos |

---

## Paso 5: Logs Esperados (Orden Correcto)

```
1. 🔵 [Clientes] Intentando GET a: https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients
2. 🟢 [Clientes] Response status: 200
3. 🟢 [Clientes] Response body: [{"id_cliente": 0, ...}, ...]
4. 🟢 [Clientes] Clientes parseados: 1
```

Si falta alguno, hay un problema en ese paso.

---

## Paso 6: Cambiar a Mock Data (Para Testear)

Si quieres verificar que la app funciona sin el backend:

**Abre:** `lib/client/customers/presentation/pages/customers_list_page.dart`

**Cambia:**
```dart
useMockData: false,  // cambiar a true
```

Ejecuta `flutter run` — si ahora ves clientes, el problema es la conexión al backend.

---

## Paso 7: Timeout Personalizado

Si tu backend es lento, aumenta el timeout:

**Abre:** `lib/client/customers/data/datasources/customers_remote_data_source.dart`

**Busca:**
```dart
.timeout(
  const Duration(seconds: 10),  // cambiar a 30, 60, etc.
```

---

## 🆘 Si Nada Funciona

1. Backend corriendo: `npm start` ✅
2. URL correcta: `https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients` ✅
3. Curl devuelve datos: `curl https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients` ✅
4. Logs en Flutter muestran GET: `🔵 [Clientes]...` ✅

Si todos los pasos pasan pero aún no funciona, comparte:
- Logs exactos de Flutter (desde `flutter run`)
- Respuesta de curl
- Código de `_buildRepository()` en `customers_list_page.dart`

