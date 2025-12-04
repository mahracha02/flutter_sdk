import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_avatar.dart';
import '../../domain/models/user_profile.dart';
import 'package:intl/intl.dart';

/// Écran d'affichage du profil utilisateur
///
/// Utilise Riverpod pour:
/// - Gestion automatique des états (loading, data, error)
/// - Réactivité automatique
/// - Pas de setState nécessaire
class UserProfileScreen extends ConsumerWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute le provider et reconstruit automatiquement sur changement
    final profileAsync = ref.watch(userProfileNotifierProvider(userId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          // Bouton de rafraîchissement
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(userProfileNotifierProvider(userId).notifier)
                  .refresh(userId);
            },
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: profileAsync.when(
        // État de chargement
        loading: () => const LoadingWidget(
          message: 'Chargement du profil...',
        ),

        // État d'erreur
        error: (error, stackTrace) => ErrorDisplayWidget(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(userProfileNotifierProvider(userId));
          },
        ),

        // État de succès avec données
        data: (profile) => _buildProfileContent(context, ref, profile),
      ),
    );
  }

  /// Construit le contenu du profil
  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(userProfileNotifierProvider(userId).notifier)
            .refresh(userId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // En-tête avec avatar et nom
            _buildHeader(profile),

            const SizedBox(height: 32),

            // Informations détaillées
            _buildInfoSection(profile),

            const SizedBox(height: 24),

            // Actions
            _buildActionsSection(context, ref),
          ],
        ),
      ),
    );
  }

  /// En-tête avec avatar et nom
  Widget _buildHeader(UserProfile profile) {
    return Column(
      children: [
        ProfileAvatar(
          avatarUrl: profile.avatarUrl,
          initials: profile.initials,
          size: 120,
        ),
        const SizedBox(height: 16),
        Text(
          profile.fullName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: ${profile.id}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Section des informations
  Widget _buildInfoSection(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        ProfileInfoCard(
          icon: Icons.person,
          label: 'Prénom',
          value: profile.firstName,
        ),
        const SizedBox(height: 12),
        ProfileInfoCard(
          icon: Icons.person_outline,
          label: 'Nom',
          value: profile.lastName,
        ),
        if (profile.email != null) ...[
          const SizedBox(height: 12),
          ProfileInfoCard(
            icon: Icons.email,
            label: 'Email',
            value: profile.email!,
          ),
        ],
        if (profile.phoneNumber != null) ...[
          const SizedBox(height: 12),
          ProfileInfoCard(
            icon: Icons.phone,
            label: 'Téléphone',
            value: profile.phoneNumber!,
          ),
        ],
        if (profile.createdAt != null) ...[
          const SizedBox(height: 12),
          ProfileInfoCard(
            icon: Icons.calendar_today,
            label: 'Membre depuis',
            value: DateFormat('dd/MM/yyyy').format(profile.createdAt!),
          ),
        ],
      ],
    );
  }

  /// Section des actions
  Widget _buildActionsSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Bouton pour vider le cache
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              // Vider le cache
              await ref
                  .read(userProfileNotifierProvider(userId).notifier)
                  .clearCache(userId);

              // Rafraîchir pour recharger depuis l'API
              await ref
                  .read(userProfileNotifierProvider(userId).notifier)
                  .refresh(userId);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache vidé avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Vider le cache'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
