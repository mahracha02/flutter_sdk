import 'package:logger/logger.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../domain/models/user_profile.dart';

/// DataSource local pour le cache des profils utilisateur
///
/// Responsabilités:
/// - Sauvegarder les profils en cache
/// - Récupérer les profils du cache
/// - Gérer l'expiration du cache
class UserLocalDataSource {
  final CacheManager _cacheManager;
  final Logger _logger = Logger();

  UserLocalDataSource(this._cacheManager);

  /// Sauvegarde un profil utilisateur en cache
  Future<void> cacheUserProfile(UserProfile profile) async {
    try {
      final cacheKey = _cacheManager.getUserCacheKey(profile.id);
      final json = profile.toJson();
      await _cacheManager.save(cacheKey, json);
      _logger.i('Profil utilisateur ${profile.id} mis en cache');
    } catch (e) {
      _logger.e('Erreur lors de la mise en cache: $e');
      // On ne propage pas l'erreur pour ne pas bloquer l'app
    }
  }

  /// Récupère un profil utilisateur depuis le cache
  UserProfile? getCachedUserProfile(String userId) {
    try {
      final cacheKey = _cacheManager.getUserCacheKey(userId);
      final json = _cacheManager.get(cacheKey);

      if (json == null) {
        _logger.d('Aucun profil en cache pour l\'utilisateur $userId');
        return null;
      }

      final profile = UserProfile.fromJson(json as Map<String, dynamic>);
      _logger.i('Profil utilisateur $userId récupéré du cache');
      return profile;
    } catch (e) {
      _logger.e('Erreur lors de la lecture du cache: $e');
      return null;
    }
  }

  /// Supprime le profil d'un utilisateur du cache
  Future<void> clearUserProfile(String userId) async {
    try {
      final cacheKey = _cacheManager.getUserCacheKey(userId);
      await _cacheManager.delete(cacheKey);
      _logger.i('Cache supprimé pour l\'utilisateur $userId');
    } catch (e) {
      _logger.e('Erreur lors de la suppression du cache: $e');
    }
  }

  /// Vide tout le cache
  Future<void> clearAll() async {
    try {
      await _cacheManager.clear();
      _logger.w('Tout le cache a été vidé');
    } catch (e) {
      _logger.e('Erreur lors du vidage du cache: $e');
    }
  }

  /// Vérifie si un profil existe en cache
  bool hasCache(String userId) {
    final cacheKey = _cacheManager.getUserCacheKey(userId);
    return _cacheManager.exists(cacheKey);
  }
}
