import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Intercepteur Dio pour logger les requêtes/réponses et gérer les erreurs
///
/// Responsabilités:
/// - Logger les requêtes sortantes
/// - Logger les réponses entrantes
/// - Logger les erreurs réseau
/// - Transformer les erreurs en format lisible
class ApiInterceptor extends Interceptor {
  final Logger _logger;

  ApiInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('''
    ╔══════════════════════════════════════════════════════════════════════
    ║ 📤 REQUEST
    ╠══════════════════════════════════════════════════════════════════════
    ║ Method: ${options.method}
    ║ URL: ${options.uri}
    ║ Headers: ${options.headers}
    ║ Data: ${options.data}
    ╚══════════════════════════════════════════════════════════════════════
    ''');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('''
    ╔══════════════════════════════════════════════════════════════════════
    ║ 📥 RESPONSE [${response.statusCode}]
    ╠══════════════════════════════════════════════════════════════════════
    ║ URL: ${response.requestOptions.uri}
    ║ Data: ${response.data}
    ╚══════════════════════════════════════════════════════════════════════
    ''');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('''
    ╔══════════════════════════════════════════════════════════════════════
    ║ ❌ ERROR [${err.response?.statusCode ?? 'NETWORK'}]
    ╠══════════════════════════════════════════════════════════════════════
    ║ URL: ${err.requestOptions.uri}
    ║ Type: ${err.type}
    ║ Message: ${err.message}
    ║ Response: ${err.response?.data}
    ╚══════════════════════════════════════════════════════════════════════
    ''');

    // Enrichir l'erreur avec un message personnalisé
    final customError = _handleError(err);
    super.onError(customError, handler);
  }

  /// Transforme les erreurs Dio en messages lisibles
  DioException _handleError(DioException error) {
    String customMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        customMessage = 'Délai d\'attente dépassé. Vérifiez votre connexion.';
        break;
      case DioExceptionType.badResponse:
        customMessage = _handleStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        customMessage = 'Requête annulée.';
        break;
      default:
        customMessage = 'Erreur de connexion. Vérifiez votre réseau.';
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: customMessage,
    );
  }

  /// Gère les codes de statut HTTP
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requête invalide.';
      case 401:
        return 'Non autorisé. Vérifiez vos identifiants.';
      case 403:
        return 'Accès interdit.';
      case 404:
        return 'Ressource non trouvée.';
      case 500:
        return 'Erreur serveur. Réessayez plus tard.';
      case 503:
        return 'Service temporairement indisponible.';
      default:
        return 'Erreur serveur (code: $statusCode).';
    }
  }
}
