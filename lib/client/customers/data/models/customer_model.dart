import '../../domain/entities/customer.dart';

/// Modelo de datos para Cliente.
/// Extiende la entidad Customer y añade métodos de serialización/deserialización JSON.
/// Se usa para mapear datos de la API REST hacia la entidad de dominio.
class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.nombre,
    required super.tipoDocumento,
    required super.numeroDocumento,
    required super.email,
    required super.telefono,
    super.estado = true,
  });

  /// Construye un CustomerModel a partir de un JSON.
  /// Utilizado para deserializar respuestas de la API.
  ///
  /// Mapea los campos del backend (snake_case con prefijo) a los campos de la app.
  /// Ejemplo de JSON del backend:
  /// ```json
  /// {
  ///   "id_cliente": 1,
  ///   "nombre_cliente": "Juan Pérez",
  ///   "tipo_docume": "DNI",
  ///   "numero_doc": "12345678",
  ///   "correo_cliente": "juan@example.com",
  ///   "telefono_cliente": "+51 987654321",
  ///   "estado_cliente": true
  /// }
  /// ```
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: (json['id_cliente'] ?? json['id']).toString(),
      nombre: json['nombre_cliente'] ?? json['nombre'] ?? '',
      tipoDocumento: json['tipo_docume'] ?? json['tipoDocumento'] ?? '',
      numeroDocumento: json['numero_doc'] ?? json['numeroDocumento'] ?? '',
      email: json['correo_cliente'] ?? json['email'] ?? '',
      telefono: json['telefono_cliente'] ?? json['telefono'] ?? '',
      estado: (json['estado_cliente'] is bool)
          ? json['estado_cliente'] as bool
          : (json['estado_cliente'] == 1 || json['estado_cliente'] == '1'),
    );
  }

  /// Convierte el modelo a un mapa JSON.
  /// Utilizado para serializar datos si es necesario enviarlos a la API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipoDocumento': tipoDocumento,
      'numeroDocumento': numeroDocumento,
      'email': email,
      'telefono': telefono,
      'estado': estado,
    };
  }
}
