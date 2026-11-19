import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/theme/app_text_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_icon_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/image_url_validator.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";

/// BlockCard compound widget for displaying a carnival block summary.
///
/// Shows: block image or celebration icon tile + block name + location • date + optional live indicator.
class BlockCard extends StatelessWidget {
  const BlockCard({
    super.key,
    required this.block,
    this.onTap,
    this.location,
    this.date,
    this.isLive = false,
  });

  /// The carnival block entity to display.
  final CarnivalBlocksEntity block;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Optional location string (e.g. "Recife").
  final String? location;

  /// Optional date string (e.g. "12 Jan").
  final String? date;

  /// When true, shows a tertiary teal dot + "Ao vivo" indicator.
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textSecondary = colorScheme.onSurfaceVariant;
    final textTertiary = Theme.of(
      context,
    ).extension<AppTextColors>()!.textTertiary;

    return AppCard(
      key: Key('block_card_${block.id}'),
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.space_sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container — AppIconSizes.display to fit content height
            if (isValidImageUrl(block.carnivalBlockImage))
              ClipRRect(
                borderRadius: Radii.radiusSm,
                child: CachedNetworkImage(
                  imageUrl: block.carnivalBlockImage,
                  width: AppIconSizes.display,
                  height: AppIconSizes.display,
                  fit: BoxFit.cover,
                  cacheManager: CacheManager(
                    Config(
                      "appImageCache",
                      stalePeriod: Duration(days: 7),
                      maxNrOfCacheObjects: 200,
                    ),
                  ),
                  placeholder: (_, shim) => _buildIconPlaceholder(colorScheme),
                  errorWidget: (_, shim, err) =>
                      _buildIconPlaceholder(colorScheme),
                ),
              )
            else
              _buildIconPlaceholder(colorScheme),
            const SizedBox(width: Spacing.space_xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    block.name,
                    style: AppTypography.labelLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location != null || date != null)
                    Text(
                      [location, date].whereType<String>().join(" • "),
                      style: AppTypography.bodySmall.copyWith(
                        color: textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (isLive) _buildLiveIndicator(context, textTertiary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder(ColorScheme colorScheme) {
    return AppIconTile(
      icon: Icons.celebration_rounded,
      backgroundColor: colorScheme.primaryContainer,
      size: AppIconSizes.display,
      radius: Radii.sm,
      iconSize: AppIconSizes.md,
    );
  }

  Widget _buildLiveIndicator(BuildContext context, Color textTertiary) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.tertiary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: Spacing.space_2xs),
        Text(
          AppLocalizations.of(context)!.coreLive,
          style: AppTypography.labelSmall.copyWith(color: textTertiary),
        ),
      ],
    );
  }
}
