import 'package:logger/logger.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

/// Implémentation du UserRepository
///
/// Stratégie de cache:
/// 1. Si forceRefresh=false, tente de récupérer depuis le cache
/// 2. Si cache vide ou forceRefresh=true, appelle l'API
/// 3. Met en cache le résultat de l'API
///
/// Gestion d'erreurs:
/// - Logs détaillés des erreurs
/// - Propagation des exceptions pour que la UI puisse les gérer
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  final DioClient _dioClient;
  final Logger _logger = Logger();

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
    required DioClient dioClient,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _dioClient = dioClient;

  @override
  Future<UserProfile> getUserProfile({
    required String userId,
    bool forceRefresh = false,
  }) async {
    try {
      // 1. Essayer le cache si forceRefresh = false
      if (!forceRefresh) {
        final cachedProfile = _localDataSource.getCachedUserProfile(userId);
        if (cachedProfile != null) {
          _logger.i(' Profil utilisateur récupéré du cache');
          return cachedProfile;
        }
        _logger.d(' Aucun profil en cache, appel API nécessaire');
      } else {
        _logger.d(' Force refresh activé, appel API');
      }

      // 2. Configurer les headers pour l'appel API
      _dioClient.setUserId(userId);
      _dioClient.setAuthToken(ApiConstants.defaultToken);

      // 3. Appeler l'API
      _logger.d(' Appel API pour récupérer le profil utilisateur $userId');
      final dto = await _remoteDataSource.getUserProfile();

      // 4. Convertir le DTO en modèle métier
      final profile = dto.toDomain();
      _logger.i(' Profil utilisateur récupéré de l\'API');

      // 5. Mettre en cache
      await _localDataSource.cacheUserProfile(profile);

      return profile;
    } catch (e, stackTrace) {
      _logger.e(' Erreur lors de la récupération du profil',
          error: e, stackTrace: stackTrace);

      // En cas d'erreur réseau, essayer de retourner le cache même expiré
      final cachedProfile = _localDataSource.getCachedUserProfile(userId);
      if (cachedProfile != null) {
        _logger.w(' Retour du cache expiré suite à une erreur réseau');
        return cachedProfile;
      }

      // Si aucun cache disponible, propager l'erreur
      throw Exception('Impossible de récupérer le profil utilisateur: $e');
    }
  }

  @override
  Future<void> clearUserCache(String userId) async {
    try {
      await _localDataSource.clearUserProfile(userId);
      _logger.i('Cache utilisateur $userId vidé');
    } catch (e) {
      _logger.e('Erreur lors du vidage du cache: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await _localDataSource.clearAll();
      _logger.i('Tout le cache a été vidé');
    } catch (e) {
      _logger.e('Erreur lors du vidage du cache: $e');
    }
  }
}
