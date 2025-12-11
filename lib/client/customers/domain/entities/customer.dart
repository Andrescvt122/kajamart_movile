/// Entidad que representa un Cliente.
/// Esta es una clase del dominio, independiente de cualquier fuente de datos específica.
/// Contiene solo los datos de negocio sin lógica de persistencia.
class Customer {
  /// Identificador único del cliente.
  final String id;

  /// Nombre completo del cliente.
  final String nombre;

  /// Tipo de documento (DNI, Pasaporte, RUC, etc).
  final String tipoDocumento;

  /// Número de documento del cliente.
  final String numeroDocumento;

  /// Correo electrónico del cliente.
  final String email;

  /// Número telefónico del cliente.
  final String telefono;

  /// Estado del cliente. true = activo, false = inactivo.
  final bool estado;

  const Customer({
    required this.id,
    required this.nombre,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.email,
    required this.telefono,
    this.estado = true,
  });

  @override
  String toString() =>
      'Customer(id: $id, nombre: $nombre, email: $email, telefono: $telefono, estado: $estado)';
}
