import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/user_profile/presentation/screens/user_profile_screen.dart';

/// Configuration du routeur avec go_router
///
/// Avantages:
/// - Navigation déclarative
/// - Deep linking automatique
/// - Type-safe avec extensions
/// - Gestion des erreurs 404
class AppRouter {
  static const String homeRoute = '/';
  static const String profileRoute = '/profile/:userId';

  /// Instance du GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: homeRoute,
    debugLogDiagnostics: true,
    routes: [
      // Route d'accueil (exemple)
      GoRoute(
        path: homeRoute,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Route du profil utilisateur avec paramètre userId
      GoRoute(
        path: profileRoute,
        name: 'profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfileScreen(userId: userId);
        },
      ),
    ],

    // Page d'erreur 404
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(homeRoute),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Extensions pour une navigation type-safe
extension AppRouterExtension on BuildContext {
  /// Navigue vers le profil d'un utilisateur
  void goToProfile(String userId) {
    go('/profile/$userId');
  }

  /// Retourne à l'accueil
  void goToHome() {
    go(AppRouter.homeRoute);
  }
}

// ============================================================================
// ÉCRAN D'ACCUEIL (EXEMPLE)
// ============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SDK Profil Utilisateur'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                'SDK Flutter Profil Utilisateur',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Exemple d\'utilisation du SDK',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => context.goToProfile('1'),
                icon: const Icon(Icons.person),
                label: const Text('Voir le profil (User ID: 1)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
