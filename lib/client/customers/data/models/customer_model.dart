import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.nombre,
    required super.tipoDocumento,
    required super.numeroDocumento,
    required super.email,
    required super.telefono,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      tipoDocumento: json['tipoDocumento'] ?? '',
      numeroDocumento: json['numeroDocumento'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipoDocumento': tipoDocumento,
      'numeroDocumento': numeroDocumento,
      'email': email,
      'telefono': telefono,
    };
  }
}
