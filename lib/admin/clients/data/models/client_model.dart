/// Modelo de cliente para el módulo de administración.
class AdminClientModel {
  final int id;
  final String nombre;
  final String tipoDocumento;
  final String numeroDocumento;
  final String correo;
  final String telefono;
  final String estado;

  AdminClientModel({
    required this.id,
    required this.nombre,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.correo,
    required this.telefono,
    required this.estado,
  });

  factory AdminClientModel.fromJson(Map<String, dynamic> json) {
    return AdminClientModel(
      id: int.tryParse(json['id_cliente']?.toString() ?? '') ?? 0,
      nombre: json['nombre_cliente']?.toString() ?? '',
      tipoDocumento: json['tipo_docume']?.toString() ?? '',
      numeroDocumento: json['numero_doc']?.toString() ?? '',
      correo: json['correo_cliente']?.toString() ?? '',
      telefono: json['telefono_cliente']?.toString() ?? '',
      estado: json['estado_cliente']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_cliente': id,
        'nombre_cliente': nombre,
        'tipo_docume': tipoDocumento,
        'numero_doc': numeroDocumento,
        'correo_cliente': correo,
        'telefono_cliente': telefono,
        'estado_cliente': estado,
      };
}
