// lib/models/provider_category.dart
class ProviderCategory {
  final String id;
  final String name;
  final String description;

  const ProviderCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ProviderCategory.fromJson(dynamic json) {
    if (json is ProviderCategory) {
      return json;
    }

    if (json is Map<String, dynamic>) {
      final nested = json['categorias'];
      final nestedMap = nested is Map<String, dynamic>
          ? Map<String, dynamic>.from(nested)
          : null;
      final sources = [if (nestedMap != null) nestedMap, json];

      String readValue(List<String> keys) {
        for (final source in sources) {
          for (final key in keys) {
            if (source.containsKey(key) && source[key] != null) {
              final value = source[key].toString().trim();
              if (value.isNotEmpty) {
                return value;
              }
            }
          }
        }
        return '';
      }

      final id = readValue([
        'id',
        'uuid',
        'code',
        'id_categoria',
        'idCategory',
        'id_proveedor_categoria',
      ]);
      final name = readValue([
        'name',
        'title',
        'label',
        'nombre',
        'nombre_categoria',
      ]);
      final description = readValue([
        'description',
        'details',
        'summary',
        'descripcion',
        'descripcion_categoria',
      ]);

      final resolvedName = name.isEmpty ? 'Sin categoría' : name;
      final resolvedId = id.isEmpty ? resolvedName : id;

      return ProviderCategory(
        id: resolvedId,
        name: resolvedName,
        description: description,
      );
    }

    if (json is String) {
      final value = json.trim();
      return ProviderCategory(
        id: value.isEmpty ? 'category' : value,
        name: value.isEmpty ? 'Sin categoría' : value,
        description: '',
      );
    }

    return const ProviderCategory(
      id: 'category',
      name: 'Sin categoría',
      description: '',
    );
  }

  @override
  String toString() => name;
}
