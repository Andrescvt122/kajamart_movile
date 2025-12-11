/// Modelo de dato para una Compra (mapea la respuesta del backend).
class PurchaseModel {
  final String id;
  final DateTime fechaCompra;
  final String idProveedor;
  final double total;
  final String estadoCompra;
  final List<PurchaseDetailModel> detalleCompra;
  final SupplierModel? proveedor;

  PurchaseModel({
    required this.id,
    required this.fechaCompra,
    required this.idProveedor,
    required this.total,
    required this.estadoCompra,
    required this.detalleCompra,
    this.proveedor,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    // Fecha: puede venir como ISO string
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['fecha_compra'].toString());
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return PurchaseModel(
      id: json['id_compra']?.toString() ?? '',
      fechaCompra: parsedDate,
      idProveedor: json['id_proveedor']?.toString() ?? '',
      // total viene como string en la API; parsear a double
      total: (json['total'] != null)
          ? double.tryParse(json['total'].toString()) ?? 0.0
          : 0.0,
      estadoCompra: json['estado_compra']?.toString() ?? '',
      detalleCompra:
          (json['detalle_compra'] as List<dynamic>?)
              ?.map(
                (e) => PurchaseDetailModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      proveedor: json['proveedores'] != null
          ? SupplierModel.fromJson(json['proveedores'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_compra': id,
    'fecha_compra': fechaCompra.toIso8601String(),
    'id_proveedor': idProveedor,
    'total': total.toString(),
    'estado_compra': estadoCompra,
    'detalle_compra': detalleCompra.map((d) => d.toJson()).toList(),
    'proveedores': proveedor?.toJson(),
  };
}

/// Modelo para el detalle de una compra (línea de producto)
class PurchaseDetailModel {
  final String id;
  final String idCompra;
  final String? idProducto;
  final int? cantidad;
  final double? precio; // ahora como número

  PurchaseDetailModel({
    required this.id,
    required this.idCompra,
    this.idProducto,
    this.cantidad,
    this.precio,
  });

  factory PurchaseDetailModel.fromJson(Map<String, dynamic> json) {
    return PurchaseDetailModel(
      id: json['id']?.toString() ?? '',
      idCompra: json['id_compra']?.toString() ?? '',
      idProducto: json['id_producto']?.toString(),
      cantidad: json['cantidad'] is int
          ? json['cantidad'] as int
          : (json['cantidad'] != null
                ? int.tryParse(json['cantidad'].toString())
                : null),
      precio: (json['precio'] != null)
          ? double.tryParse(json['precio'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_compra': idCompra,
    'id_producto': idProducto,
    'cantidad': cantidad,
    'precio': precio?.toString(),
  };
}

class SupplierModel {
  final String idProveedor;
  final String nombre;
  final String? telefono;
  final String? direccion;
  final bool? estado;
  final String? descripcion;
  final String? nit;
  final String? maxPorcentajeDeDevolucion;
  final String? tipoPersona;
  final String? contacto;
  final String? correo;

  SupplierModel({
    required this.idProveedor,
    required this.nombre,
    this.telefono,
    this.direccion,
    this.estado,
    this.descripcion,
    this.nit,
    this.maxPorcentajeDeDevolucion,
    this.tipoPersona,
    this.contacto,
    this.correo,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      idProveedor: json['id_proveedor']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
      estado: json['estado'] is bool
          ? json['estado'] as bool
          : (json['estado']?.toString() == '1' ||
                json['estado']?.toString().toLowerCase() == 'true'),
      descripcion: json['descripcion']?.toString(),
      nit: json['nit']?.toString(),
      maxPorcentajeDeDevolucion: json['max_porcentaje_de_devolucion']
          ?.toString(),
      tipoPersona: json['tipo_persona']?.toString(),
      contacto: json['contacto']?.toString(),
      correo: json['correo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_proveedor': idProveedor,
    'nombre': nombre,
    'telefono': telefono,
    'direccion': direccion,
    'estado': estado,
    'descripcion': descripcion,
    'nit': nit,
    'max_porcentaje_de_devolucion': maxPorcentajeDeDevolucion,
    'tipo_persona': tipoPersona,
    'contacto': contacto,
    'correo': correo,
  };
}

/// Mock rápido para desarrollo cuando la API no está disponible.
const List<PurchaseModel> _mockPurchases = [];

// Export mock si needed
List<PurchaseModel> get mockPurchases => _mockPurchases;
