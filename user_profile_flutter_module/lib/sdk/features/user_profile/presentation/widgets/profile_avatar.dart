import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ============================================================================
// AVATAR AVEC FALLBACK
// ============================================================================

/// Widget d'avatar avec cache et fallback sur les initiales
class ProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  final String initials;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.initials,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildFallback(),
      ),
    );
  }

  /// Placeholder pendant le chargement
  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  /// Fallback avec les initiales si l'image échoue
  Widget _buildFallback() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[400]!,
            Colors.purple[400]!,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
