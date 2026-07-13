// lib/core/cache/app_cache_manager.dart
//
// Custom CacheManager for CachedNetworkImage with a finite 7-day disk cache.
// This prevents stale profile images from persisting indefinitely.
// Default CachedNetworkImage cache is 30 days.

import "package:flutter_cache_manager/flutter_cache_manager.dart";

/// App-wide cache manager with 7-day stale period for disk-cached images.
///
/// Use this instead of the default CachedNetworkImage cache to ensure
/// profile picture updates propagate within a reasonable timeframe.
class AppCacheManager extends CacheManager with ImageCacheManager {
  AppCacheManager._()
    : super(
        Config(
          "appImageCache",
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
        ),
      );

  static final AppCacheManager _instance = AppCacheManager._();
  static AppCacheManager get instance => _instance;
}
