class CategoryModel {
  final String id;
  final String nombreCategoria;
  final String? descripcionCategoria;
  final bool estado;
  final List<CategoryProductModel> productos;

  CategoryModel({
    required this.id,
    required this.nombreCategoria,
    this.descripcionCategoria,
    required this.estado,
    required this.productos,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id_categoria']?.toString() ?? '',
      nombreCategoria: json['nombre_categoria']?.toString() ?? 'Sin categoria',
      descripcionCategoria: json['descripcion_categoria']?.toString(),
      estado: _toBool(json['estado']),
      productos:
          (json['productos'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => CategoryProductModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          <CategoryProductModel>[],
    );
  }

  String get firstProductPreview {
    if (productos.isEmpty) {
      return 'Sin productos';
    }
    final first = productos.first.nombre;
    return productos.length > 1 ? '$first...' : first;
  }
}

class CategoryProductModel {
  final String id;
  final String nombre;
  final int stockActual;
  final String? urlImagen;

  CategoryProductModel({
    required this.id,
    required this.nombre,
    required this.stockActual,
    this.urlImagen,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      id: json['id_producto']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? 'Producto',
      stockActual: _toInt(json['stock_actual']),
      urlImagen: json['url_imagen']?.toString(),
    );
  }
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  final text = value?.toString().toLowerCase() ?? '';
  return text == '1' || text == 'true';
}

int _toInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
