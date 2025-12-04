import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_profile_dto.dart';
import '../../../../core/constants/api_constants.dart';

part 'user_remote_datasource.g.dart';

/// DataSource distant pour récupérer les profils utilisateur via API
///
/// Utilise Retrofit pour:
/// - Génération automatique du code HTTP
/// - Type-safety
/// - Gestion automatique de la sérialisation
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class UserRemoteDataSource {
  factory UserRemoteDataSource(Dio dio, {String baseUrl}) =
      _UserRemoteDataSource;

  /// Récupère le profil de l'utilisateur courant
  ///
  /// Endpoint: GET /v1/users/me
  ///
  /// Headers requis:
  /// - Authorization: Bearer token
  /// - X-User-Id: userId
  /// - Accept-Language: langue
  @GET(ApiConstants.userMeEndpoint)
  Future<UserProfileDto> getUserProfile();
}

// Note: Pour générer le code, exécutez:
// flutter pub run build_runner build --delete-conflicting-outputs
