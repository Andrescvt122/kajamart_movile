/// Archivo de configuración ejemplo para diferentes ambientes.
///
/// CÓMO USAR ESTE ARCHIVO:
/// 1. Copia este archivo y renómbralo a `config.dart` (sin el sufijo .example)
/// 2. Descomenta el ambiente que necesites
/// 3. Importa `config.dart` en tus archivos
/// 4. Usa `Config.apiBaseUrl` en lugar de URLs hardcodeadas
///
/// IMPORTANTE:
/// - NO commitees este archivo con datos sensibles
/// - Usa variables de entorno para tokens en producción
/// - Nunca expongas URLs de staging/producción en código público

// ============================================================
// OPCIÓN 1: Descomenta esto para DESARROLLO LOCAL
// ============================================================

/*
class Config {
  /// URL base del servidor de API en desarrollo local
  static const String apiBaseUrl = 'http://localhost:8000';
  
  /// Endpoint para clientes
  static const String customersEndpoint = '/clientes';
  
  /// Habilita datos de prueba
  static const bool useMockData = true;
  
  /// Timeout para requests en segundos
  static const int httpTimeout = 30;
  
  /// Log mode - imprime información de debug
  static const bool debugMode = true;
}
*/

// ============================================================
// OPCIÓN 2: Descomenta esto para STAGING
// ============================================================

/*
class Config {
  /// URL base del servidor de API en staging
  static const String apiBaseUrl = 'https://staging-api.kajamart.com';
  
  /// Endpoint para clientes
  static const String customersEndpoint = '/api/v1/clientes';
  
  /// Habilita datos de prueba
  static const bool useMockData = false;
  
  /// Timeout para requests en segundos
  static const int httpTimeout = 30;
  
  /// Log mode
  static const bool debugMode = true;
}
*/

// ============================================================
// OPCIÓN 3: Descomenta esto para PRODUCCIÓN (DEFAULT)
// ============================================================

class Config {
  /// URL base del servidor de API en producción
  static const String apiBaseUrl = 'https://api.kajamart.com';

  /// Endpoint para clientes
  static const String customersEndpoint = '/api/v1/clientes';

  /// Habilita datos de prueba
  static const bool useMockData = false;

  /// Timeout para requests en segundos
  static const int httpTimeout = 30;

  /// Log mode
  static const bool debugMode = false;

  /// ============================================================
  /// CREDENTIALS (CAMBIAR EN PRODUCCIÓN)
  /// ============================================================

  /// API Key para autenticación
  /// TODO: Obtener del servicio de secretos
  static const String apiKey = 'YOUR_API_KEY_HERE';

  /// Token JWT si es aplicable
  /// TODO: Obtenerlo en runtime desde el servicio de autenticación
  static String? jwtToken;
}

// ============================================================
// DETECCIÓN AUTOMÁTICA DE AMBIENTE
// ============================================================

/*
// Alternativa: Detectar el ambiente automáticamente

const String environment = String.fromEnvironment(
  'ENVIRONMENT',
  defaultValue: 'production',
);

class Config {
  static final String apiBaseUrl = switch (environment) {
    'development' => 'http://localhost:8000',
    'staging' => 'https://staging-api.kajamart.com',
    'production' => 'https://api.kajamart.com',
    _ => 'https://api.kajamart.com',
  };
  
  static final bool useMockData = switch (environment) {
    'development' => true,
    _ => false,
  };
  
  static final bool debugMode = switch (environment) {
    'production' => false,
    _ => true,
  };
}

// Para ejecutar con un ambiente específico:
// flutter run --dart-define=ENVIRONMENT=staging
*/

// ============================================================
// CÓMO USAR EN TU CÓDIGO
// ============================================================

/*
// En customers_list_page.dart:

import 'package:kajamart_movile/client/customers/config.dart';

CustomersRepository _buildRepository() {
  return CustomersRepositoryImpl(
    remoteDataSource: CustomersRemoteDataSource(
      baseUrl: Config.apiBaseUrl,
    ),
    useMockData: Config.useMockData,
  );
}

// En customer_detail_page.dart:

import 'package:kajamart_movile/client/customers/config.dart';

if (Config.debugMode) {
  print('🐛 Debug: Cliente = ${customer.nombre}');
}

// En un cliente HTTP con autenticación:

import 'package:kajamart_movile/client/customers/config.dart';
import 'package:http/http.dart' as http;

class AuthenticatedHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (Config.jwtToken != null) {
      request.headers['Authorization'] = 'Bearer ${Config.jwtToken}';
    }
    request.headers['X-API-Key'] = Config.apiKey;
    return super.send(request);
  }
}
*/

// ============================================================
// CONFIGURACIÓN POR PLATAFORMA
// ============================================================

/*
// Si necesitas URLs diferentes por plataforma:

import 'dart:io' show Platform;

class Config {
  static String get apiBaseUrl {
    if (Platform.isAndroid) {
      return 'https://api-android.kajamart.com';
    } else if (Platform.isIOS) {
      return 'https://api-ios.kajamart.com';
    } else {
      return 'https://api.kajamart.com';
    }
  }
}
*/

// ============================================================
// VARIABLES DE ENTORNO
// ============================================================

/*
// Para mayor seguridad, usa variables de entorno:
// Crea un archivo .env en la raíz del proyecto:

/*
API_BASE_URL=https://api.kajamart.com
API_KEY=tu-clave-secreta-aqui
ENVIRONMENT=production
*/

// Luego instala flutter_dotenv:
// flutter pub add flutter_dotenv

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get apiBaseUrl => 
    dotenv.env['API_BASE_URL'] ?? 'https://api.kajamart.com';
  
  static String get apiKey => 
    dotenv.env['API_KEY'] ?? 'DEFAULT_KEY';
  
  static String get environment => 
    dotenv.env['ENVIRONMENT'] ?? 'production';
}

// En main.dart:
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const KajamartApp());
}
*/
