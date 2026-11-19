import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/display/image_url_validator.dart";
import "package:bloco_na_rua/ui/core/widgets/display/safe_network_image.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

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

/// AVATAR_PALETTE — fill/ink pairs used for the initials background, selected
/// by name hash.
///
/// Every fill is paired with an ink that clears WCAG AA (4.5:1) on it: white
/// on the deep violet and magenta, near-black on the brighter gold, green
/// and cyan.
const List<(Color, Color)> _avatarPalette = [
  (AppColors.primary, AppColors.textOnPrimary), // #7C3AED
  (AppColors.accent, AppColors.textPrimary), // #D97706
  (AppColors.success, AppColors.textPrimary), // #16A34A
  (AppColors.info, AppColors.textPrimary), // #0EA5E9
  (AppColors.secondary, AppColors.textOnPrimary), // #E11D74
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

/// Returns the (fill, ink) pair for the initials by hashing [name] into the
/// avatar palette.
///
/// The ink is chosen per fill so the initials always clear WCAG AA (4.5:1).
/// An empty or null [name] falls back to the primary pair.
(Color, Color) _getInitialsPaletteEntry(String? name) {
  if (name == null || name.isEmpty) return _avatarPalette.first;
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
///
/// The foreground is the palette ink paired with the initials fill, so it
/// always clears WCAG AA (4.5:1).
TextStyle _getInitialsStyle(AvatarSize size, Color ink) {
  switch (size) {
    case AvatarSize.xs:
    case AvatarSize.sm:
      return AppTypography.labelSmall.copyWith(color: ink);
    case AvatarSize.md:
      return AppTypography.labelMedium.copyWith(color: ink);
    case AvatarSize.lg:
      return AppTypography.titleSmall.copyWith(color: ink);
    case AvatarSize.xl:
      return AppTypography.titleMedium.copyWith(color: ink);
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
    Widget initialsOrIcon((Color, Color) palette) {
      final initials = _getInitials(name);
      final ink = palette.$2;

      if (initials.isEmpty) {
        // No name — show person icon on the hashed background
        return Icon(Icons.person_rounded, size: diameter * 0.5, color: ink);
      }

      return Text(initials, style: _getInitialsStyle(size, ink));
    }

    // If no usable imageUrl, show initials or icon immediately. The validator
    // also rejects backend placeholder strings (e.g. "img") that would
    // otherwise crash CachedNetworkImageProvider.
    if (!isValidImageUrl(imageUrl)) {
      final palette = _getInitialsPaletteEntry(name);
      if (isCircle) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: palette.$1,
          child: initialsOrIcon(palette),
        );
      }

      return ClipRRect(
        borderRadius: shape == AvatarShape.square
            ? BorderRadius.zero
            : Radii.radiusMd,
        child: Container(
          width: diameter,
          height: diameter,
          color: palette.$1,
          child: Center(child: initialsOrIcon(palette)),
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
        backgroundColor: _getInitialsPaletteEntry(name).$1,
        backgroundImage: imageProvider,
        onBackgroundImageError: (_, _) {
          // CircleAvatar.backgroundImage handles error by showing backgroundColor
        },
      );
    }

    return ClipRRect(
      borderRadius: shape == AvatarShape.square
          ? BorderRadius.zero
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
