/// Modelo de dato para una Venta (mapea la respuesta del backend).
class SaleModel {
  final String id;
  final DateTime fechaVenta;
  final int? idCliente;
  final String metodoPago;
  final double total;
  final String estadoVenta;
  final ClientModel? cliente;
  final List<SaleDetailModel> detalleVenta;

  SaleModel({
    required this.id,
    required this.fechaVenta,
    this.idCliente,
    required this.metodoPago,
    required this.total,
    required this.estadoVenta,
    this.cliente,
    required this.detalleVenta,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    DateTime parsed;
    try {
      parsed = DateTime.parse(json['fecha_venta'].toString());
    } catch (e) {
      parsed = DateTime.now();
    }

    return SaleModel(
      id: json['id_venta']?.toString() ?? '',
      fechaVenta: parsed,
      idCliente: json['id_cliente'] != null
          ? int.tryParse(json['id_cliente'].toString())
          : null,
      metodoPago: json['metodo_pago']?.toString() ?? '',
      total: (json['total'] != null)
          ? double.tryParse(json['total'].toString()) ?? 0.0
          : 0.0,
      estadoVenta: json['estado_venta']?.toString() ?? '',
      cliente: json['clientes'] != null
          ? ClientModel.fromJson(json['clientes'] as Map<String, dynamic>)
          : null,
      detalleVenta:
          (json['detalle_venta'] as List<dynamic>?)
              ?.map((e) => SaleDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_venta': id,
    'fecha_venta': fechaVenta.toIso8601String(),
    'id_cliente': idCliente,
    'metodo_pago': metodoPago,
    'total': total.toString(),
    'estado_venta': estadoVenta,
    'clientes': cliente?.toJson(),
    'detalle_venta': detalleVenta.map((d) => d.toJson()).toList(),
  };
}

class SaleDetailModel {
  final String idDetalle;
  final String idVenta;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final int? idDetalleProducto;
  final ProductDetailModel? detalleProducto;

  SaleDetailModel({
    required this.idDetalle,
    required this.idVenta,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.idDetalleProducto,
    this.detalleProducto,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      idDetalle: json['id_detalle']?.toString() ?? '',
      idVenta: json['id_venta']?.toString() ?? '',
      cantidad: json['cantidad'] is int
          ? json['cantidad'] as int
          : int.tryParse(json['cantidad']?.toString() ?? '') ?? 0,
      precioUnitario: (json['precio_unitario'] != null)
          ? double.tryParse(json['precio_unitario'].toString()) ?? 0.0
          : 0.0,
      subtotal: (json['subtotal'] != null)
          ? double.tryParse(json['subtotal'].toString()) ?? 0.0
          : 0.0,
      idDetalleProducto: json['id_detalle_producto'] != null
          ? int.tryParse(json['id_detalle_producto'].toString())
          : null,
      detalleProducto: json['detalle_productos'] != null
          ? ProductDetailModel.fromJson(
              json['detalle_productos'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_detalle': idDetalle,
    'id_venta': idVenta,
    'cantidad': cantidad,
    'precio_unitario': precioUnitario.toString(),
    'subtotal': subtotal.toString(),
    'id_detalle_producto': idDetalleProducto,
    'detalle_productos': detalleProducto?.toJson(),
  };
}

class ProductDetailModel {
  final int idDetalleProducto;
  final int idProducto;
  final String codigoBarras;
  final DateTime? fechaVencimiento;
  final int? stockProducto;
  final bool? estado;
  final ProductModel? producto;

  ProductDetailModel({
    required this.idDetalleProducto,
    required this.idProducto,
    required this.codigoBarras,
    this.fechaVencimiento,
    this.stockProducto,
    this.estado,
    this.producto,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsed;
    if (json['fecha_vencimiento'] != null) {
      try {
        parsed = DateTime.parse(json['fecha_vencimiento'].toString());
      } catch (_) {
        parsed = null;
      }
    }

    return ProductDetailModel(
      idDetalleProducto:
          int.tryParse(json['id_detalle_producto']?.toString() ?? '') ?? 0,
      idProducto: int.tryParse(json['id_producto']?.toString() ?? '') ?? 0,
      codigoBarras: json['codigo_barras_producto_compra']?.toString() ?? '',
      fechaVencimiento: parsed,
      stockProducto: json['stock_producto'] != null
          ? int.tryParse(json['stock_producto'].toString())
          : null,
      estado: json['estado'] is bool
          ? json['estado'] as bool
          : (json['estado']?.toString() == '1' ||
                json['estado']?.toString().toLowerCase() == 'true'),
      producto: json['productos'] != null
          ? ProductModel.fromJson(json['productos'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_detalle_producto': idDetalleProducto,
    'id_producto': idProducto,
    'codigo_barras_producto_compra': codigoBarras,
    'fecha_vencimiento': fechaVencimiento?.toIso8601String(),
    'stock_producto': stockProducto,
    'estado': estado,
    'productos': producto?.toJson(),
  };
}

class ProductModel {
  final int id;
  final String nombre;
  final String descripcion;
  final double precioVenta;
  final String? urlImagen;

  ProductModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioVenta,
    this.urlImagen,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json['id_producto']?.toString() ?? '') ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precioVenta: (json['precio_venta'] != null)
          ? double.tryParse(json['precio_venta'].toString()) ?? 0.0
          : 0.0,
      urlImagen: json['url_imagen']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_producto': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio_venta': precioVenta.toString(),
    'url_imagen': urlImagen,
  };
}

class ClientModel {
  final int id;
  final String nombre;
  final String tipoDoc;
  final String numeroDoc;
  final String? correo;
  final String? telefono;
  final String? estado;

  ClientModel({
    required this.id,
    required this.nombre,
    required this.tipoDoc,
    required this.numeroDoc,
    this.correo,
    this.telefono,
    this.estado,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: int.tryParse(json['id_cliente']?.toString() ?? '') ?? 0,
      nombre: json['nombre_cliente']?.toString() ?? '',
      tipoDoc: json['tipo_docume']?.toString() ?? '',
      numeroDoc: json['numero_doc']?.toString() ?? '',
      correo: json['correo_cliente']?.toString(),
      telefono: json['telefono_cliente']?.toString(),
      estado: json['estado_cliente']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_cliente': id,
    'nombre_cliente': nombre,
    'tipo_docume': tipoDoc,
    'numero_doc': numeroDoc,
    'correo_cliente': correo,
    'telefono_cliente': telefono,
    'estado_cliente': estado,
  };
}
