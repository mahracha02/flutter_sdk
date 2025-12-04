import 'package:flutter/material.dart';
import 'core/cache/cache_manager.dart';
import 'features/user_profile/presentation/screens/user_profile_screen.dart';

/// SDK Flutter pour afficher le profil utilisateur
///
/// Point d'entrée principal du SDK
/// Expose les méthodes publiques pour les utilisateurs du SDK
class UserProfileSdk {
  static UserProfileSdk? _instance;
  final CacheManager _cacheManager;
  bool _isInitialized = false;

  UserProfileSdk._internal(this._cacheManager);

  /// Obtenir l'instance singleton du SDK
  static UserProfileSdk get instance {
    _instance ??= UserProfileSdk._internal(CacheManager());
    return _instance!;
  }

  /// Initialiser le SDK (obligatoire avant utilisation)
  ///
  /// Doit être appelé une seule fois au démarrage de l'app
  ///
  /// Exemple:
  /// ```dart
  /// await UserProfileSdk.instance.initialize();
  /// ```
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('SDK déjà initialisé');
      return;
    }

    try {
      // Initialiser Hive pour le cache
      await _cacheManager.init();
      _isInitialized = true;
      debugPrint('UserProfileSdk initialisé avec succès');
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation du SDK: $e');
      rethrow;
    }
  }

  /// Affiche l'écran de profil d'un utilisateur
  ///
  /// Paramètres:
  /// - [context]: BuildContext Flutter
  /// - [userId]: ID de l'utilisateur à afficher
  ///
  /// Exemple:
  /// ```dart
  /// UserProfileSdk.instance.showUserProfile(
  ///   context: context,
  ///   userId: '1',
  /// );
  /// ```
  void showUserProfile({
    required BuildContext context,
    required String userId,
  }) {
    if (!_isInitialized) {
      throw Exception(
        'SDK non initialisé. Appelez UserProfileSdk.instance.initialize() '
        'avant d\'utiliser le SDK.',
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(userId: userId),
      ),
    );
  }

  /// Obtient le widget de profil sans navigation
  ///
  /// Permet d'intégrer le profil directement dans votre UI
  ///
  /// Exemple:
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return UserProfileSdk.instance.getUserProfileWidget(userId: '1');
  /// }
  /// ```
  Widget getUserProfileWidget({required String userId}) {
    if (!_isInitialized) {
      throw Exception(
        'SDK non initialisé. Appelez UserProfileSdk.instance.initialize() '
        'avant d\'utiliser le SDK.',
      );
    }

    return UserProfileScreen(userId: userId);
  }

  /// Vide tout le cache du SDK
  ///
  /// Exemple:
  /// ```dart
  /// await UserProfileSdk.instance.clearCache();
  /// ```
  Future<void> clearCache() async {
    if (!_isInitialized) {
      throw Exception('SDK non initialisé');
    }

    await _cacheManager.clear();
    debugPrint('Cache du SDK vidé');
  }

  /// Vérifie si le SDK est initialisé
  bool get isInitialized => _isInitialized;
}

/// Extension pour simplifier l'utilisation du SDK
extension UserProfileSdkExtension on BuildContext {
  /// Affiche le profil d'un utilisateur
  void showUserProfile(String userId) {
    UserProfileSdk.instance.showUserProfile(
      context: this,
      userId: userId,
    );
  }
}
