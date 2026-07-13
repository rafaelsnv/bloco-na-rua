// lib/ui/core/widgets/display/app_avatar.dart
//
// Avatar widget for the Bloco na Rua design system.
//
// Displays a user avatar with the following behavior:
// - If [imageUrl] is non-null and loads successfully: shows the network image
// - If [imageUrl] is non-null but fails to load: shows initials fallback
// - If [name] is provided but no imageUrl: shows initials with hashed background
// - If neither [imageUrl] nor [name] is available: shows a person icon on primary background
//
// The initials are generated from the [name]:
// - Two or more words: first letter of the first two words (uppercase)
// - Single word: first two letters (uppercase)
// - Empty or null: person icon is shown

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_radius.dart";
import "../../tokens/app_typography.dart";
import "image_url_validator.dart";
import "safe_network_image.dart";

/// Avatar size variants with their pixel values.
enum AvatarSize {
  xs(24),
  sm(32),
  md(48),
  lg(64),
  xl(96);

  const AvatarSize(this.pixels);
  final double pixels;
}

/// Avatar shape variants that control border radius.
enum AvatarShape { circle, square, roundedSquare }

/// AVATAR_PALETTE — six colors used for initials background, selected by name hash.
const List<Color> _avatarPalette = [
  AppColors.primary, // #4F46E5
  AppColors.cta, // #F97316
  AppColors.success, // #10B981
  AppColors.info, // #3B82F6
  Color(0xFF8B5CF6), // purple
  Color(0xFFEC4899), // pink
];

/// Returns the initials text for a given [name].
///
/// Rules:
/// - Two or more words: first letter of the first two words (uppercase)
/// - Single word: first two letters (uppercase)
/// - Empty or null: returns empty string
String _getInitials(String? name) {
  if (name == null || name.trim().isEmpty) return "";

  final words = name.trim().split(RegExp(r"\s+"));

  if (words.length >= 2) {
    final first = words[0].isNotEmpty ? words[0][0].toUpperCase() : "";
    final second = words[1].isNotEmpty ? words[1][0].toUpperCase() : "";
    return "$first$second";
  } else {
    final word = words[0];
    if (word.length >= 2) {
      return "${word[0].toUpperCase()}${word[1].toUpperCase()}";
    } else if (word.length == 1) {
      return word[0].toUpperCase();
    }
    return "";
  }
}

/// Returns the background color for initials by hashing [name] into the avatar palette.
Color _getInitialsBackground(String? name) {
  if (name == null || name.isEmpty) return AppColors.primary;
  final hash = name.hashCode.abs();
  return _avatarPalette[hash % _avatarPalette.length];
}

/// Returns [url] with a `?v=<version>` query parameter appended when
/// [versionToken] is non-null. Falls back to [url] if it cannot be parsed.
String _buildVersionedUrl(String url, Object? versionToken) {
  if (versionToken == null) return url;
  final tokenStr = versionToken is DateTime
      ? versionToken.millisecondsSinceEpoch.toString()
      : versionToken.toString();
  final uri = Uri.tryParse(url);
  if (uri == null) return url;
  return uri
      .replace(queryParameters: {...uri.queryParameters, "v": tokenStr})
      .toString();
}

/// Returns the appropriate text style for initials based on [size].
TextStyle _getInitialsStyle(AvatarSize size) {
  switch (size) {
    case AvatarSize.xs:
    case AvatarSize.sm:
      return AppTypography.labelSmall.copyWith(color: Colors.white);
    case AvatarSize.md:
      return AppTypography.labelMedium.copyWith(color: Colors.white);
    case AvatarSize.lg:
      return AppTypography.titleSmall.copyWith(color: Colors.white);
    case AvatarSize.xl:
      return AppTypography.titleMedium.copyWith(color: Colors.white);
  }
}

/// A user avatar widget that displays a network image with initials fallback.
///
/// [AppAvatar] shows:
/// - A [CachedNetworkImage] when [imageUrl] is provided
/// - Initials with a hashed background color when only [name] is available
/// - A person icon when neither [imageUrl] nor [name] is available
///
/// The [size] controls the diameter in pixels (xs=24, sm=32, md=48, lg=64, xl=96).
/// The [shape] controls the border radius (circle, square, roundedSquare).
///
/// Use [imageCacheVersion] to bust the image cache when the backend returns the
/// same URL for an updated image (e.g., a new profile picture). Pass a
/// [DateTime] like `member.updatedAt` or a version string — this value is
/// appended as `?v=<value>` to both the loaded URL and the cache key.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.md,
    this.shape = AvatarShape.circle,
    this.imageCacheVersion,
  });

  /// Optional URL for the avatar network image.
  final String? imageUrl;

  /// Optional display name used to generate initials and select background color.
  final String? name;

  /// Avatar size variant controlling diameter. Defaults to [AvatarSize.md].
  final AvatarSize size;

  /// Avatar shape variant controlling border radius. Defaults to [AvatarShape.circle].
  final AvatarShape shape;

  /// Optional version token (e.g., `DateTime` or version string) appended to
  /// the image URL and cache key as `?v=<value>` to bust stale cached images.
  final Object? imageCacheVersion;

  @override
  Widget build(BuildContext context) {
    final diameter = size.pixels;
    final radius = diameter / 2;
    final isCircle = shape == AvatarShape.circle;

    // Show initials widget as a fallback or primary content
    Widget initialsOrIcon() {
      final initials = _getInitials(name);

      if (initials.isEmpty) {
        // No name — show person icon on primary background
        return Icon(
          Icons.person_rounded,
          size: diameter * 0.5,
          color: Colors.white,
        );
      }

      return Text(initials, style: _getInitialsStyle(size));
    }

    // If no usable imageUrl, show initials or icon immediately. The validator
    // also rejects backend placeholder strings (e.g. "img") that would
    // otherwise crash CachedNetworkImageProvider.
    if (!isValidImageUrl(imageUrl)) {
      if (isCircle) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: _getInitialsBackground(name),
          child: initialsOrIcon(),
        );
      }

      return ClipRRect(
        borderRadius: shape == AvatarShape.square
            ? Radii.radiusFull
            : Radii.radiusMd,
        child: Container(
          width: diameter,
          height: diameter,
          color: _getInitialsBackground(name),
          child: Center(child: initialsOrIcon()),
        ),
      );
    }

    // Compute versioned URL + cache key when imageCacheVersion is supplied.
    // This ensures a new profile picture (same URL, new content) busts the
    // stale cached entry by varying the cache key.
    final versionedUrl = _buildVersionedUrl(imageUrl!, imageCacheVersion);
    final cacheKey = versionedUrl;

    // Build image provider for CircleAvatar
    final imageProvider = CachedNetworkImageProvider(
      versionedUrl,
      cacheKey: cacheKey,
    );

    if (isCircle) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: _getInitialsBackground(name),
        backgroundImage: imageProvider,
        onBackgroundImageError: (_, _) {
          // CircleAvatar.backgroundImage handles error by showing backgroundColor
        },
      );
    }

    return ClipRRect(
      borderRadius: shape == AvatarShape.square
          ? Radii.radiusFull
          : Radii.radiusMd,
      child: SafeNetworkImage(
        url: versionedUrl,
        width: diameter,
        height: diameter,
        placeholderBuilder: (_, _) =>
            _buildShimmerPlaceholder(context, diameter),
        errorIcon: null, // Use initials as error fallback
      ),
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context, double diameter) {
    final shimmerColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(width: diameter, height: diameter, color: shimmerColor);
  }
}
