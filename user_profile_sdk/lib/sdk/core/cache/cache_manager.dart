import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';

/// Gestionnaire de cache utilisant Hive
///
/// Responsabilités:
/// - Initialiser Hive
/// - Stocker/Récupérer des données avec expiration
/// - Nettoyer le cache expiré
class CacheManager {
  Box? _cacheBox;
  final Logger _logger = Logger();
  bool _isInitialized = false;

  /// Initialise Hive et ouvre la box de cache
  Future<void> init() async {
    if (_isInitialized) return;
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox(ApiConstants.cacheBoxName);
    _isInitialized = true;
    _logger.i('CacheManager initialisé');
  }

  /// Sauvegarde une valeur avec un timestamp
  Future<void> save(String key, dynamic value) async {
    if (_cacheBox == null) {
      _logger.w('CacheBox not initialized, skipping save');
      return;
    }
    final cacheData = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _cacheBox!.put(key, cacheData);
    _logger.d('Données sauvegardées en cache: $key');
  }

  /// Récupère une valeur si elle n'est pas expirée
  dynamic get(String key) {
    if (_cacheBox == null) {
      _logger.w('CacheBox not initialized, returning null');
      return null;
    }
    final cacheData = _cacheBox!.get(key);

    if (cacheData == null) {
      _logger.d('Aucune donnée en cache pour: $key');
      return null;
    }

    final timestamp = cacheData['timestamp'] as int;
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    // Vérifie si le cache est expiré
    if (now.difference(cacheTime) > ApiConstants.cacheExpiration) {
      _logger.d('Cache expiré pour: $key');
      delete(key);
      return null;
    }

    _logger.d('Données récupérées du cache: $key');
    return cacheData['value'];
  }

  /// Supprime une entrée du cache
  Future<void> delete(String key) async {
    if (_cacheBox == null) return;
    await _cacheBox!.delete(key);
    _logger.d('Cache supprimé pour: $key');
  }

  /// Vide tout le cache
  Future<void> clear() async {
    if (_cacheBox == null) return;
    await _cacheBox!.clear();
    _logger.w('Cache entièrement vidé');
  }

  /// Vérifie si une clé existe et n'est pas expirée
  bool exists(String key) {
    return get(key) != null;
  }

  /// Génère une clé de cache pour un userId
  String getUserCacheKey(String userId) {
    return 'user_profile_$userId';
  }
}
