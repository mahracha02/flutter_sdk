import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sdk/user_profile_sdk.dart';
import 'sdk/features/user_profile/presentation/screens/user_profile_screen.dart';

/// Point d'entrée du module Flutter pour React Native
///
/// Ce main.dart est spécialement conçu pour être appelé depuis React Native
/// Il utilise un MethodChannel pour communiquer avec le code natif
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le SDK
  await UserProfileSdk.instance.initialize();

  runApp(
    const ProviderScope(
      child: FlutterModuleApp(),
    ),
  );
}

/// Application Flutter pour React Native
class FlutterModuleApp extends StatefulWidget {
  const FlutterModuleApp({super.key});

  @override
  State<FlutterModuleApp> createState() => _FlutterModuleAppState();
}

class _FlutterModuleAppState extends State<FlutterModuleApp> {
  // Canal de communication avec React Native
  static const platform = MethodChannel('com.example.userprofile/channel');

  // UserId par défaut
  String _currentUserId = '1';

  @override
  void initState() {
    super.initState();
    _setupMethodChannel();
  }

  /// Configure le MethodChannel pour recevoir les commandes de RN
  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'setUserId':
          // React Native envoie un nouveau userId
          final String userId = call.arguments as String;
          setState(() {
            _currentUserId = userId;
          });
          return 'UserId updated to $userId';

        case 'getUserId':
          // React Native demande le userId actuel
          return _currentUserId;

        case 'clearCache':
          // React Native demande de vider le cache
          await UserProfileSdk.instance.clearCache();
          return 'Cache cleared';

        default:
          throw PlatformException(
            code: 'UNKNOWN_METHOD',
            message: 'Method ${call.method} not implemented',
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile SDK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // Affiche directement l'écran de profil avec l'userId courant
      home: UserProfileScreen(userId: _currentUserId),
    );
  }
}
