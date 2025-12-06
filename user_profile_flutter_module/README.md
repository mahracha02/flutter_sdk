#  Création du module Flutter

## 1. Créer un nouveau module Flutter

```bash
# Dans un dossier séparé (à côté de votre projet RN)
flutter create --template module user_profile_flutter_module
cd user_profile_flutter_module
```

## 2. Structure attendue

```
user_profile_flutter_module/
├── .android/          # Build Android
├── .ios/             # Build iOS
├── lib/
    ├── main.dart
    ├── sdk/
    │   ├── user_profile_sdk.dart          # Point d'entrée public
    │   │
    │   ├── core/                          # Fondations techniques
    │   │   ├── constants/
    │   │   │   └── api_constants.dart
    │   │   ├── network/
    │   │   │   ├── dio_client.dart        # Configuration Dio
    │   │   │   └── api_interceptor.dart   # Logs + erreurs
    │   │   ├── cache/
    │   │   │   └── cache_manager.dart     # Wrapper Hive
    │   │   └── router/
    │   │       └── app_router.dart        # go_router config
    │   │
    │   └── features/
    │       └── user_profile/
    │           ├── domain/                 # Logique métier
    │           │   ├── models/
    │           │   │   └── user_profile.dart
    │           │   └── repositories/
    │           │       └── user_repository.dart
    │           │
    │           ├── data/                   # Implémentation
    │           │   ├── models/
    │           │   │   └── user_profile_dto.dart
    │           │   ├── datasources/
    │           │   │   ├── user_remote_datasource.dart
    │           │   │   └── user_local_datasource.dart
    │           │   └── repositories/
    │           │       └── user_repository_impl.dart
    │           │
    │           └── presentation/           # UI
    │               ├── providers/
    │               │   └── user_profile_provider.dart
    │               ├── screens/
    │               │   └── user_profile_screen.dart
    │               └── widgets/
    │                   └── profile_widgets.dart
├── pubspec.yaml
```


## 4. Modifier le pubspec.yaml

Gardez les mêmes dépendances mais ajoutez:

```yaml
name: user_profile_flutter_module
description: Flutter module pour React Native

# Important pour les modules
module:
  androidX: true
  androidPackage: com.example.user_profile_flutter_module
  iosBundleIdentifier: com.example.userProfileFlutterModule
```

## 4. Générer le code

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```
