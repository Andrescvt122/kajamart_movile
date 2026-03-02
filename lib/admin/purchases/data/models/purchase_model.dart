/// Purchase model mapped from backend response.
class PurchaseModel {
  final String id;
  final DateTime fechaCompra;
  final String idProveedor;
  final double subtotal;
  final double totalImpuestos;
  final double total;
  final String estadoCompra;
  final List<PurchaseDetailModel> detalleCompra;
  final SupplierModel? proveedor;

  PurchaseModel({
    required this.id,
    required this.fechaCompra,
    required this.idProveedor,
    required this.subtotal,
    required this.totalImpuestos,
    required this.total,
    required this.estadoCompra,
    required this.detalleCompra,
    this.proveedor,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['fecha_compra'].toString());
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return PurchaseModel(
      id: json['id_compra']?.toString() ?? json['id']?.toString() ?? '',
      fechaCompra: parsedDate,
      idProveedor: json['id_proveedor']?.toString() ?? '',
      subtotal: _toDouble(json['subtotal']),
      totalImpuestos: _toDouble(json['total_impuestos']),
      total: _toDouble(json['total']),
      estadoCompra: json['estado_compra']?.toString() ?? '',
      detalleCompra:
          (json['detalle_compra'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => PurchaseDetailModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          <PurchaseDetailModel>[],
      proveedor: json['proveedores'] is Map
          ? SupplierModel.fromJson(
              Map<String, dynamic>.from(json['proveedores'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_compra': id,
    'fecha_compra': fechaCompra.toIso8601String(),
    'id_proveedor': idProveedor,
    'subtotal': subtotal,
    'total_impuestos': totalImpuestos,
    'total': total,
    'estado_compra': estadoCompra,
    'detalle_compra': detalleCompra.map((d) => d.toJson()).toList(),
    'proveedores': proveedor?.toJson(),
  };
}

/// Purchase detail line model.
class PurchaseDetailModel {
  final String id;
  final String idCompra;
  final int? cantidad;
  final double? precioUnitario;
  final double? subtotal;
  final String? idDetalleProducto;
  final String? idProducto;
  final String? nombreProducto;
  final int? cantidadPaquetes;
  final int? unidadesPorPaquete;
  final int? cantidadTotalUnidades;

  PurchaseDetailModel({
    required this.id,
    required this.idCompra,
    this.cantidad,
    this.precioUnitario,
    this.subtotal,
    this.idDetalleProducto,
    this.idProducto,
    this.nombreProducto,
    this.cantidadPaquetes,
    this.unidadesPorPaquete,
    this.cantidadTotalUnidades,
  });

  factory PurchaseDetailModel.fromJson(Map<String, dynamic> json) {
    final detalleProductos = json['detalle_productos'] is Map
        ? Map<String, dynamic>.from(json['detalle_productos'] as Map)
        : const <String, dynamic>{};
    final productos = detalleProductos['productos'] is Map
        ? Map<String, dynamic>.from(detalleProductos['productos'] as Map)
        : const <String, dynamic>{};

    return PurchaseDetailModel(
      id: json['id_detalle']?.toString() ?? json['id']?.toString() ?? '',
      idCompra: json['id_compra']?.toString() ?? '',
      cantidad: _toInt(json['cantidad']),
      precioUnitario: _toNullableDouble(json['precio_unitario'] ?? json['precio']),
      subtotal: _toNullableDouble(json['subtotal']),
      idDetalleProducto:
          json['id_detalle_producto']?.toString() ??
          detalleProductos['id_detalle_producto']?.toString(),
      idProducto:
          json['id_producto']?.toString() ??
          detalleProductos['id_producto']?.toString(),
      nombreProducto: productos['nombre']?.toString(),
      cantidadPaquetes: _toInt(json['cantidad_paquetes']),
      unidadesPorPaquete: _toInt(json['unidades_por_paquete']),
      cantidadTotalUnidades: _toInt(json['cantidad_total_unidades']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_detalle': id,
    'id_compra': idCompra,
    'cantidad': cantidad,
    'precio_unitario': precioUnitario,
    'subtotal': subtotal,
    'id_detalle_producto': idDetalleProducto,
    'id_producto': idProducto,
    'cantidad_paquetes': cantidadPaquetes,
    'unidades_por_paquete': unidadesPorPaquete,
    'cantidad_total_unidades': cantidadTotalUnidades,
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
      maxPorcentajeDeDevolucion: json['max_porcentaje_de_devolucion']?.toString(),
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

double _toDouble(dynamic value) {
  if (value == null) return 0;
  return double.tryParse(value.toString()) ?? 0;
}

double? _toNullableDouble(dynamic value) {
  if (value == null) return null;
  return double.tryParse(value.toString());
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

const List<PurchaseModel> _mockPurchases = [];

List<PurchaseModel> get mockPurchases => _mockPurchases;
