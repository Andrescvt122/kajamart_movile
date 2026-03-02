/// Funciones de utilidad para formateo y validación de datos en el módulo de clientes.

/// Formatea un número de teléfono para una visualización más legible.
///
/// Ejemplos:
/// - `formatPhoneNumber('51987654321')` → `+51 987 654 321`
/// - `formatPhoneNumber('+51987654321')` → `+51 987 654 321`
/// - `formatPhoneNumber('')` → ``
String formatPhoneNumber(String phone) {
  if (phone.isEmpty) return phone;

  // Elimina espacios y caracteres especiales
  String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

  // Si no tiene +, intenta agregar código de país
  if (!cleaned.startsWith('+') && cleaned.length == 9) {
    cleaned = '+51$cleaned'; // Asume Perú por defecto
  }

  return cleaned;
}

/// Formatea un correo electrónico para visualización.
///
/// Si el email es muy largo, lo trunca con puntos suspensivos.
///
/// Ejemplos:
/// - `formatEmail('juan@example.com')` → `juan@example.com`
/// - `formatEmail('muy.correo.largo.del.usuario@dominioextraordinario.com', maxLength: 20)` → `muy.correo.largo.d...`
String formatEmail(String email, {int maxLength = 50}) {
  if (email.length <= maxLength) return email;
  return '${email.substring(0, maxLength - 3)}...';
}

/// Formatea un número de documento para visualización.
///
/// Ejemplos:
/// - `formatDocumentNumber('12345678', 'DNI')` → `12 345 678`
/// - `formatDocumentNumber('X1234567', 'Pasaporte')` → `X 1234567`
/// - `formatDocumentNumber('20123456789', 'RUC')` → `20 123 456 789`
String formatDocumentNumber(String documentNumber, String documentType) {
  if (documentNumber.isEmpty) return documentNumber;

  switch (documentType.toUpperCase()) {
    case 'DNI':
      // Formato: XX XXX XXX
      if (documentNumber.length == 8) {
        return '${documentNumber.substring(0, 2)} ${documentNumber.substring(2, 5)} ${documentNumber.substring(5)}';
      }
      break;
    case 'RUC':
      // Formato: XX XXX XXX XXX
      if (documentNumber.length == 11) {
        return '${documentNumber.substring(0, 2)} ${documentNumber.substring(2, 5)} ${documentNumber.substring(5, 8)} ${documentNumber.substring(8)}';
      }
      break;
    case 'PASAPORTE':
      // Formato: X XXXXXXX
      if (documentNumber.length == 8) {
        return '${documentNumber.substring(0, 1)} ${documentNumber.substring(1)}';
      }
      break;
  }

  // Si no coincide con un formato conocido, retorna el original
  return documentNumber;
}

/// Obtiene la inicial del nombre para mostrar en avatares.
///
/// Ejemplos:
/// - `getInitials('Juan Pérez')` → `J`
/// - `getInitials('María González López')` → `M`
/// - `getInitials('')` → `?`
String getInitials(String name) {
  if (name.isEmpty) return '?';
  return name.trim()[0].toUpperCase();
}

/// Obtiene las dos primeras iniciales del nombre.
///
/// Útil para avatares de dos letras.
///
/// Ejemplos:
/// - `getInitials2('Juan Pérez')` → `JP`
/// - `getInitials2('María')` → `M`
/// - `getInitials2('')` → `??`
String getInitials2(String name) {
  if (name.isEmpty) return '??';

  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  return parts[0][0].toUpperCase();
}

/// Valida si un email tiene formato válido.
///
/// Ejemplos:
/// - `isValidEmail('juan@example.com')` → `true`
/// - `isValidEmail('juan@ejemplo')` → `false`
/// - `isValidEmail('juanexample.com')` → `false`
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// Valida si un teléfono tiene un formato válido.
///
/// Ejemplos:
/// - `isValidPhone('+51987654321')` → `true`
/// - `isValidPhone('987654321')` → `true`
/// - `isValidPhone('12345')` → `false`
bool isValidPhone(String phone) {
  // Extrae solo dígitos
  final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
  // Un teléfono válido tiene entre 7 y 15 dígitos
  return cleaned.length >= 7 && cleaned.length <= 15;
}

/// Valida si un nombre es válido.
///
/// - Mínimo 2 caracteres
/// - Máximo 100 caracteres
/// - No solo números
bool isValidName(String name) {
  final trimmed = name.trim();
  if (trimmed.length < 2 || trimmed.length > 100) return false;
  // Verifica que no sea solo números
  return !RegExp(r'^\d+$').hasMatch(trimmed);
}

/// Trunca un texto a una longitud máxima.
///
/// Ejemplos:
/// - `truncateText('Juan Pérez García', 10)` → `Juan Pérez...`
/// - `truncateText('Juan', 10)` → `Juan`
String truncateText(String text, int maxLength, {String suffix = '...'}) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength - suffix.length)}$suffix';
}

/// Capitaliza la primera letra de cada palabra.
///
/// Ejemplos:
/// - `capitalizeWords('juan pérez garcía')` → `Juan Pérez García`
/// - `capitalizeWords('MARIA GONZALEZ')` → `Maria Gonzalez`
String capitalizeWords(String text) {
  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      })
      .join(' ');
}

/// Extrae solo números de un texto.
///
/// Ejemplos:
/// - `extractNumbers('+51 987 654 321')` → `51987654321`
/// - `extractNumbers('DNI: 12345678')` → `12345678`
String extractNumbers(String text) {
  return text.replaceAll(RegExp(r'[^\d]'), '');
}

/// Verifica si dos clientes son iguales (útil para comparaciones).
///
/// Compara por id y números de documento.
bool areCustomersEqual(String id1, String id2) {
  return id1 == id2;
}

/// Formatea una cadena de búsqueda para mejor coincidencia.
///
/// - Elimina espacios extras
/// - Convierte a minúsculas
/// - Elimina acentos (si es posible)
String formatSearchQuery(String query) {
  return query.trim().toLowerCase().replaceAll(
    RegExp(r'\s+'),
    ' ',
  ); // Elimina espacios múltiples
}

/// Verifica si una búsqueda coincide con un cliente.
///
/// Busca en nombre, documento, email y teléfono.
bool searchMatchesCustomer(
  String query,
  String nombre,
  String numeroDocumento,
  String email,
  String telefono,
) {
  final normalizedQuery = formatSearchQuery(query);

  return nombre.toLowerCase().contains(normalizedQuery) ||
      numeroDocumento.toLowerCase().contains(normalizedQuery) ||
      email.toLowerCase().contains(normalizedQuery) ||
      telefono.toLowerCase().contains(normalizedQuery);
}

/// Calcula la similitud entre dos strings (0.0 a 1.0).
///
/// Útil para búsqueda aproximada.
double calculateSimilarity(String s1, String s2) {
  final s1Lower = s1.toLowerCase();
  final s2Lower = s2.toLowerCase();

  if (s1Lower == s2Lower) return 1.0;
  if (s1Lower.isEmpty || s2Lower.isEmpty) return 0.0;

  int matches = 0;
  for (int i = 0; i < s1Lower.length && i < s2Lower.length; i++) {
    if (s1Lower[i] == s2Lower[i]) matches++;
  }

  return matches /
      (s1Lower.length > s2Lower.length ? s1Lower.length : s2Lower.length);
}
