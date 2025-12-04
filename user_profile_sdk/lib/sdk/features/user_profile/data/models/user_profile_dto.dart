import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/user_profile.dart';

part 'user_profile_dto.freezed.dart';
part 'user_profile_dto.g.dart';

/// DTO pour la sérialisation depuis l'API
///
/// Séparer le DTO du modèle métier permet:
/// - Adapter les noms de champs de l'API
/// - Gérer les changements d'API sans impacter le Domain
/// - Validation spécifique aux données API

/// Modèle pour les images de profil
@freezed
class PictureDto with _$PictureDto {
  const factory PictureDto({
    required String url,
    required String label,
  }) = _PictureDto;

  factory PictureDto.fromJson(Map<String, dynamic> json) =>
      _$PictureDtoFromJson(json);
}

@freezed
class UserProfileDto with _$UserProfileDto {
  const factory UserProfileDto({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    String? email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    List<PictureDto>? picture,
  }) = _UserProfileDto;

  const UserProfileDto._();

  /// Désérialisation depuis JSON
  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  /// Conversion vers le modèle métier
  UserProfile toDomain() {
    // Extraire l'URL de l'avatar depuis le tableau picture
    String avatarUrl = '';
    if (picture != null && picture!.isNotEmpty) {
      // Chercher l'image "large" ou "small", sinon prendre la première
      final largeImage = picture!.firstWhere(
        (p) => p.label == 'large',
        orElse: () => picture!.firstWhere(
          (p) => p.label == 'small',
          orElse: () => picture!.first,
        ),
      );
      avatarUrl = largeImage.url;
    }

    return UserProfile(
      id: id.toString(),
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
    );
  }
}

/// Wrapper pour la réponse de l'API
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    required T data,
    String? message,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
