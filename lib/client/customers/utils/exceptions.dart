/// Excepciones personalizadas para el módulo de clientes.
///
/// Estas excepciones permiten manejar errores específicos del módulo
/// de manera más granular en la aplicación.

/// Excepción base para todas las excepciones del módulo de clientes.
abstract class CustomersException implements Exception {
  final String message;

  CustomersException(this.message);

  @override
  String toString() => message;
}

/// Excepción lanzada cuando hay un error de conexión de red.
///
/// Se dispara cuando:
/// - No hay conexión a internet
/// - El servidor no está disponible
/// - Hay un timeout en la conexión
class NetworkException extends CustomersException {
  NetworkException([String? message])
    : super(message ?? 'Error de conexión. Verifica tu conexión a internet.');
}

/// Excepción lanzada cuando el servidor retorna un error 401 o similar.
///
/// Indica que el usuario no está autorizado o sus credenciales son inválidas.
class UnauthorizedException extends CustomersException {
  UnauthorizedException([String? message])
    : super(message ?? 'No estás autorizado. Verifica tus credenciales.');
}

/// Excepción lanzada cuando el servidor retorna un error 404.
///
/// Indica que el recurso solicitado no fue encontrado.
class NotFoundException extends CustomersException {
  NotFoundException([String? message])
    : super(message ?? 'El recurso solicitado no fue encontrado.');
}

/// Excepción lanzada cuando hay un error del servidor (5xx).
///
/// Indica un problema interno del servidor, generalmente temporal.
class ServerException extends CustomersException {
  final int? statusCode;

  ServerException({String? message, this.statusCode})
    : super(message ?? 'Error del servidor. Intenta más tarde.');
}

/// Excepción lanzada cuando la respuesta JSON es inválida.
///
/// Se dispara cuando:
/// - El JSON no se puede deserializar
/// - Faltan campos requeridos
/// - Los tipos de datos no coinciden
class JsonException extends CustomersException {
  JsonException([String? message])
    : super(message ?? 'Error al procesar la respuesta del servidor.');
}

/// Excepción lanzada cuando los datos son inválidos.
///
/// Se dispara cuando:
/// - Validación de datos falla
/// - Campos requeridos están vacíos
class DataValidationException extends CustomersException {
  DataValidationException([String? message])
    : super(message ?? 'Los datos proporcionados no son válidos.');
}

/// Excepción lanzada cuando hay un error desconocido.
///
/// Se usa como fallback para errores inesperados.
class UnknownException extends CustomersException {
  final dynamic originalError;

  UnknownException({String? message, this.originalError})
    : super(message ?? 'Error desconocido. Intenta de nuevo.');
}

/// Clase auxiliar para convertir excepciones genéricas a excepciones personalizadas.
class ExceptionHandler {
  /// Convierte una excepción genérica a una excepción personalizada del módulo.
  ///
  /// Mapea tipos de excepciones conocidas a excepciones específicas:
  /// - [SocketException] → [NetworkException]
  /// - [TimeoutException] → [NetworkException]
  /// - [FormatException] → [JsonException]
  /// - Etc.
  static CustomersException handle(dynamic error) {
    if (error is CustomersException) {
      return error;
    }

    if (error is FormatException) {
      return JsonException('Formato de datos inválido.');
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') || errorString.contains('connection')) {
      return NetworkException();
    }

    if (errorString.contains('timeout')) {
      return NetworkException(
        'La solicitud tardó demasiado. Intenta de nuevo.',
      );
    }

    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return UnauthorizedException();
    }

    if (errorString.contains('404') || errorString.contains('not found')) {
      return NotFoundException();
    }

    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('server error')) {
      return ServerException();
    }

    return UnknownException(originalError: error);
  }

  /// Retorna un mensaje de error amigable para mostrar al usuario.
  static String getUserFriendlyMessage(CustomersException exception) {
    return exception.message;
  }
}
