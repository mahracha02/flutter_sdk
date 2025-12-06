import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Modèle métier du profil utilisateur
///
/// Utilise Freezed pour:
/// - Immutabilité
/// - Génération automatique de copyWith, ==, hashCode
/// - Pattern matching
/// - Sérialisation JSON
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String avatarUrl,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
  }) = _UserProfile;

  /// Constructeur privé pour ajouter des getters
  const UserProfile._();

  /// Nom complet de l'utilisateur
  String get fullName => '$firstName $lastName';

  /// Initiales (pour fallback de l'avatar)
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Désérialisation depuis JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
