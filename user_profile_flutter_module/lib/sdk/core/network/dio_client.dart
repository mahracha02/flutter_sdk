import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';

/// Client Dio configuré pour l'API
///
/// Responsabilités:
/// - Configuration de base (baseUrl, timeouts, headers)
/// - Ajout des intercepteurs (logs, erreurs)
/// - Fournit une instance Dio configurée
class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
          ApiConstants.acceptLanguageHeader: ApiConstants.defaultLanguage,
        },
      ),
    );

    // Ajout des intercepteurs
    _dio.interceptors.add(ApiInterceptor(_logger));

    _logger.i('DioClient initialisé avec baseUrl: ${ApiConstants.baseUrl}');
  }

  /// Obtenir l'instance Dio configurée
  Dio get dio => _dio;

  /// Configure les headers d'authentification
  void setAuthToken(String token) {
    _dio.options.headers[ApiConstants.authHeader] = token;
    _logger.d('Token d\'authentification configuré');
  }

  /// Configure le userId dans les headers
  void setUserId(String userId) {
    _dio.options.headers[ApiConstants.userIdHeader] = userId;
    _logger.d('User ID configuré: $userId');
  }

  /// Configure la langue
  void setLanguage(String language) {
    _dio.options.headers[ApiConstants.acceptLanguageHeader] = language;
    _logger.d('Langue configurée: $language');
  }
}
