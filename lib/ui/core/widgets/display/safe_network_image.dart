import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";

import "image_url_validator.dart";

/// A CachedNetworkImage wrapper that validates the URL before loading.
///
/// Shows a fallback placeholder when [url] is invalid (null, empty, or not
/// an absolute http(s) URL). When valid, delegates to CachedNetworkImage
/// with the app's 7-day disk cache.
class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderBuilder,
    this.errorIcon,
    this.errorColor,
  });

  /// The URL to load. Must be an absolute http(s) URL with a host.
  final String? url;

  /// Optional width. Defaults to full width if not specified.
  final double? width;

  /// Optional height. Defaults to natural height if not specified.
  final double? height;

  /// How to inscribe the image into the allocated space. Defaults to cover.
  final BoxFit fit;

  /// Optional border radius applied to the image and the fallback placeholder.
  final BorderRadius? borderRadius;

  /// Optional custom placeholder builder. When null, shows a shimmer-colored
  /// Container.
  final Widget Function(BuildContext context, String url)? placeholderBuilder;

  /// Optional icon shown in the error/fallback state. When null, shows a
  /// generic image placeholder icon.
  final IconData? errorIcon;

  /// Optional color for the error icon. When null, uses onSurfaceVariant.
  final Color? errorColor;

  @override
  Widget build(BuildContext context) {
    final isValid = isValidImageUrl(url);

    Widget content;

    if (!isValid) {
      content = _buildFallback(context);
    } else {
      content = CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        cacheManager: _cacheManager,
        fadeInDuration: fadeInDuration,
        placeholder: placeholderBuilder ?? _shimmerPlaceholder,
        errorWidget: (context, url, error) => _buildFallback(context),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: content);
    }

    return content;
  }

  Widget _buildFallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = errorColor ?? colorScheme.onSurfaceVariant;
    final bgColor = colorScheme.surfaceContainerHighest;

    return Container(
      width: width,
      height: height,
      color: bgColor,
      child: Center(
        child: Icon(
          errorIcon ?? Icons.image_rounded,
          size: _iconSize(height),
          color: iconColor,
        ),
      ),
    );
  }

  Widget _shimmerPlaceholder(BuildContext context, String url) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  double _iconSize(double? dimension) {
    if (dimension == null) return 32;
    if (dimension < 32) return dimension * 0.4;
    return 32;
  }

  /// Fade-in duration for loaded images (150ms — matches AppDurations.fast).
  static const Duration fadeInDuration = Duration(milliseconds: 150);

  /// Default cache manager used for image caching.
  /// Uses the standard flutter_cache_manager with default settings.
  static final CacheManager _cacheManager = CacheManager(
    Config(
      "safeNetworkImageCache",
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
    ),
  );
}
