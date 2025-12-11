/// Constantes de configuración del módulo de clientes.
///
/// Este archivo centraliza todas las URLs, endpoints y configuraciones
/// que pueden necesitar cambios según el ambiente (desarrollo/producción).

/// URL base del servidor de API para los clientes.
///
/// Ejemplos:
/// - Desarrollo local: 'http://localhost:8000'
/// - Producción: 'https://api.kajamart.com'
/// - Testing: 'https://test-api.kajamart.com'
const String apiBaseUrl = 'https://api.tu-dominio.com';

/// Endpoint para obtener la lista de clientes.
///
/// La URL completa será: $apiBaseUrl$customersEndpoint
const String customersEndpoint = '/clientes';

/// Endpoint completo para clientes.
const String customersFullUrl = '$apiBaseUrl$customersEndpoint';

/// Habilita datos de prueba (mock data) en lugar de usar la API real.
///
/// Cambiar a false en producción cuando la API esté lista.
const bool useMockDataByDefault = true;

/// Tiempo de espera máximo para las peticiones HTTP en segundos.
const int httpTimeoutSeconds = 30;

/// Tiempo de simulación de carga para datos mock (en milisegundos).
///
/// Se usa para que la experiencia sea más realista cuando se usan datos de prueba.
const int mockLoadingDelayMilliseconds = 800;

/// ============================================================
/// Configuraciones de UI
/// ============================================================

/// Color primario de la aplicación (Verde Kajamart).
const int primaryColorValue = 0xFF00C853;

/// Color de error.
const int errorColorValue = 0xFFE53935;

/// Color de éxito.
const int successColorValue = 0xFF4CAF50;

/// Color de advertencia.
const int warningColorValue = 0xFFFDD835;

/// ============================================================
/// Mensajes de Error
/// ============================================================

const String errorLoadingCustomers = 'No se pudieron cargar los clientes';
const String errorConnectionFailed = 'Error de conexión. Verifica tu internet.';
const String errorInvalidResponse = 'Respuesta inválida del servidor.';
const String errorUnauthorized = 'No autorizado. Verifica tus credenciales.';
const String errorNotFound = 'Recurso no encontrado.';
const String errorServerError = 'Error del servidor. Intenta más tarde.';

/// ============================================================
/// Mensajes de Éxito
/// ============================================================

const String successLoaded = 'Clientes cargados correctamente';

/// ============================================================
/// Textos de Interfaz
/// ============================================================

const String labelSearchCustomers = 'Buscar por nombre o documento...';
const String labelNoCustomersFound = 'No se encontraron clientes';
const String labelTryOtherSearch = 'Intenta con otros términos de búsqueda';
const String labelLoadingCustomers = 'Cargando clientes...';
const String labelRetry = 'Reintentar';
const String labelReload = 'Recargar';
const String labelCustomerDetail = 'Detalle del Cliente';
const String labelCustomers = 'Clientes';
const String labelPersonalInfo = 'Información Personal';
const String labelContactInfo = 'Información de Contacto';
const String labelOptions = 'Opciones';
const String labelFullName = 'Nombre Completo';
const String labelDocumentType = 'Tipo de Documento';
const String labelDocumentNumber = 'Número de Documento';
const String labelEmail = 'Correo Electrónico';
const String labelPhone = 'Teléfono';
const String labelCall = 'Llamar';
const String labelSendEmail = 'Email';

/// ============================================================
/// Validaciones
/// ============================================================

/// Longitud mínima para una búsqueda válida.
const int minSearchLength = 1;

/// Longitud máxima para una búsqueda.
const int maxSearchLength = 100;
