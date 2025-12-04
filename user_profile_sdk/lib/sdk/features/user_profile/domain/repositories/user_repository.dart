import '../models/user_profile.dart';

/// Interface du repository utilisateur
///
/// Définit le contrat pour accéder aux données utilisateur
/// L'implémentation concrète sera dans la couche Data
///
/// Avantages:
/// - Inversion de dépendance (SOLID)
/// - Facilite les tests (mocking)
/// - Découplage entre Domain et Data
abstract class UserRepository {
  /// Récupère le profil utilisateur par son ID
  ///
  /// Paramètres:
  /// - [userId]: Identifiant de l'utilisateur
  /// - [forceRefresh]: Force la récupération depuis l'API (ignore le cache)
  ///
  /// Retourne:
  /// - [UserProfile] si succès
  ///
  /// Lève:
  /// - Exception en cas d'erreur réseau ou parsing
  Future<UserProfile> getUserProfile({
    required String userId,
    bool forceRefresh = false,
  });

  /// Vide le cache pour un utilisateur spécifique
  Future<void> clearUserCache(String userId);

  /// Vide tout le cache utilisateur
  Future<void> clearAllCache();
}
