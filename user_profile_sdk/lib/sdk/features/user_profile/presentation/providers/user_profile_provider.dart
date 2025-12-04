import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/cache/cache_manager.dart';

part 'user_profile_provider.g.dart';

// ============================================================================
// PROVIDERS D'INFRASTRUCTURE (Singleton)
// ============================================================================

/// Provider du client Dio
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Provider du gestionnaire de cache
final cacheManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager();
});

/// Provider du datasource distant
final remoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UserRemoteDataSource(dioClient.dio);
});

/// Provider du datasource local
final localDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  final cacheManager = ref.watch(cacheManagerProvider);
  return UserLocalDataSource(cacheManager);
});

/// Provider du repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
    dioClient: ref.watch(dioClientProvider),
  );
});

// ============================================================================
// PROVIDERS DE DONNÉES (AsyncNotifier avec code generation)
// ============================================================================

/// Provider pour récupérer le profil utilisateur
///
/// Utilise code generation pour:
/// - Génération automatique du provider
/// - Type-safety
/// - Gestion automatique du loading/error state
@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile> build(String userId) async {
    // Récupération initiale du profil
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getUserProfile(userId: userId);
  }

  /// Rafraîchir le profil (force l'appel API)
  Future<void> refresh(String userId) async {
    state = const AsyncValue.loading();
    final repository = ref.watch(userRepositoryProvider);

    state = await AsyncValue.guard(() async {
      return await repository.getUserProfile(
        userId: userId,
        forceRefresh: true,
      );
    });
  }

  /// Vider le cache pour cet utilisateur
  Future<void> clearCache(String userId) async {
    final repository = ref.watch(userRepositoryProvider);
    await repository.clearUserCache(userId);
  }
}

// Note: Pour générer le code, exécutez:
// flutter pub run build_runner build --delete-conflicting-outputs
