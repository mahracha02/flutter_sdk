// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileNotifierHash() =>
    r'3094b71222a19a5d24a04ca6422d899eaf50713d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserProfileNotifier
    extends BuildlessAutoDisposeAsyncNotifier<UserProfile> {
  late final String userId;

  FutureOr<UserProfile> build(
    String userId,
  );
}

/// Provider pour récupérer le profil utilisateur
///
/// Utilise code generation pour:
/// - Génération automatique du provider
/// - Type-safety
/// - Gestion automatique du loading/error state
///
/// Copied from [UserProfileNotifier].
@ProviderFor(UserProfileNotifier)
const userProfileNotifierProvider = UserProfileNotifierFamily();

/// Provider pour récupérer le profil utilisateur
///
/// Utilise code generation pour:
/// - Génération automatique du provider
/// - Type-safety
/// - Gestion automatique du loading/error state
///
/// Copied from [UserProfileNotifier].
class UserProfileNotifierFamily extends Family<AsyncValue<UserProfile>> {
  /// Provider pour récupérer le profil utilisateur
  ///
  /// Utilise code generation pour:
  /// - Génération automatique du provider
  /// - Type-safety
  /// - Gestion automatique du loading/error state
  ///
  /// Copied from [UserProfileNotifier].
  const UserProfileNotifierFamily();

  /// Provider pour récupérer le profil utilisateur
  ///
  /// Utilise code generation pour:
  /// - Génération automatique du provider
  /// - Type-safety
  /// - Gestion automatique du loading/error state
  ///
  /// Copied from [UserProfileNotifier].
  UserProfileNotifierProvider call(
    String userId,
  ) {
    return UserProfileNotifierProvider(
      userId,
    );
  }

  @override
  UserProfileNotifierProvider getProviderOverride(
    covariant UserProfileNotifierProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userProfileNotifierProvider';
}

/// Provider pour récupérer le profil utilisateur
///
/// Utilise code generation pour:
/// - Génération automatique du provider
/// - Type-safety
/// - Gestion automatique du loading/error state
///
/// Copied from [UserProfileNotifier].
class UserProfileNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserProfileNotifier, UserProfile> {
  /// Provider pour récupérer le profil utilisateur
  ///
  /// Utilise code generation pour:
  /// - Génération automatique du provider
  /// - Type-safety
  /// - Gestion automatique du loading/error state
  ///
  /// Copied from [UserProfileNotifier].
  UserProfileNotifierProvider(
    String userId,
  ) : this._internal(
          () => UserProfileNotifier()..userId = userId,
          from: userProfileNotifierProvider,
          name: r'userProfileNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfileNotifierHash,
          dependencies: UserProfileNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserProfileNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProfileNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<UserProfile> runNotifierBuild(
    covariant UserProfileNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserProfileNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserProfileNotifierProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserProfileNotifier, UserProfile>
      createElement() {
    return _UserProfileNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileNotifierProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserProfileNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<UserProfile> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProfileNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserProfileNotifier,
        UserProfile> with UserProfileNotifierRef {
  _UserProfileNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as UserProfileNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
