/// Constantes pour la configuration de l'API
class ApiConstants {
  // Base URL de l'API
  static const String baseUrl = 'https://api.azeoo.dev';

  // Endpoints
  static const String userMeEndpoint = '/v1/users/me';

  // Headers
  static const String authHeader = 'Authorization';
  static const String userIdHeader = 'X-User-Id';
  static const String acceptLanguageHeader = 'Accept-Language';
  static const String contentTypeHeader = 'Content-Type';

  // Valeurs par défaut
  static const String defaultLanguage = 'fr-FR';
  static const String jsonContentType = 'application/json';

  // Token (dans un vrai SDK, ceci serait passé en paramètre)
  static const String defaultToken =
      'Bearer api_474758da8532e795f63bc4e5e6beca7298379993f65bb861f2e8e13c352cc4dcebcc3b10961a5c369edb05fbc0b0053cf63df1c53d9ddd7e4e5d680beb514d20';

  // Cache
  static const String cacheBoxName = 'user_profile_cache';
  static const Duration cacheExpiration = Duration(minutes: 30);

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
