import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_radius.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";
import "../cards/app_card.dart";
import "../display/image_url_validator.dart";

const _blockEmojis = ["🎭", "🎉", "🎊", "", "🎷", "🎺", "🪇", "🏟️"];

/// BlockCard compound widget for displaying a carnival block summary.
///
/// Shows: emoji icon + block name + location • date + member count badge +
/// optional live indicator.
class BlockCard extends StatelessWidget {
  const BlockCard({
    super.key,
    required this.block,
    this.onTap,
    this.memberCount,
    this.location,
    this.date,
    this.isLive = false,
  });

  /// The carnival block entity to display.
  final CarnivalBlocksEntity block;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Optional member count. When provided displays "N membros".
  /// When null displays "Sem membros".
  final int? memberCount;

  /// Optional location string (e.g. "Recife").
  final String? location;

  /// Optional date string (e.g. "12 Jan").
  final String? date;

  /// When true, shows a tertiary teal dot + "Ao vivo" indicator.
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final surfaceVariant = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final textTertiary = Theme.of(context).brightness == Brightness.dark
        ? AppColors.textTertiaryDark
        : AppColors.textTertiary;

    return AppCard(
      key: Key('block_card_${block.id}'),
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.space_sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container — 40x40px to fit content height
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: Radii.radiusSm,
              ),
              child: isValidImageUrl(block.carnivalBlockImage)
                  ? ClipRRect(
                      borderRadius: Radii.radiusSm,
                      child: CachedNetworkImage(
                        imageUrl: block.carnivalBlockImage,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        cacheManager: CacheManager(
                          Config(
                            "appImageCache",
                            stalePeriod: Duration(days: 7),
                            maxNrOfCacheObjects: 200,
                          ),
                        ),
                        placeholder: (_, shim) =>
                            _buildEmojiPlaceholder(surfaceVariant),
                        errorWidget: (_, shim, err) =>
                            _buildEmojiPlaceholder(surfaceVariant),
                      ),
                    )
                  : _buildEmojiPlaceholder(surfaceVariant),
            ),
            const SizedBox(width: Spacing.space_xs),
            // Content column — tight fit, no Expanded to avoid stretching row height
            Column(
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
                _buildBadgeRow(surfaceVariant, textSecondary, textTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPlaceholder(Color surfaceVariant) {
    final emoji = _blockEmojis[block.id.hashCode % _blockEmojis.length];
    return Container(
      decoration: BoxDecoration(
        color: surfaceVariant,
        borderRadius: Radii.radiusSm,
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
    );
  }

  Widget _buildBadgeRow(
    Color surfaceVariant,
    Color textSecondary,
    Color textTertiary,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_2xs,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: surfaceVariant,
            borderRadius: Radii.radiusFull,
          ),
          child: Text(
            memberCount != null ? "$memberCount membros" : "Sem membros",
            style: AppTypography.labelSmall.copyWith(color: textSecondary),
          ),
        ),
        if (isLive) ...[
          const SizedBox(width: Spacing.space_xs),
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
            "Ao vivo",
            style: AppTypography.labelSmall.copyWith(color: textTertiary),
          ),
        ],
      ],
    );
  }
}
