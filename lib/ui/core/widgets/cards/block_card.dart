// lib/ui/core/widgets/cards/block_card.dart
//
// BlockCard compound widget for displaying a carnival block summary card.
//
// Renders: block image (100px) + block name + member count + invite code + optional tags.
//
// Uses CachedNetworkImage for the block photo with a surfaceContainerHighest
// placeholder while loading. All layout uses design system tokens.

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:bloco_na_rua/core/cache/app_cache_manager.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";

import "../../tokens/app_radius.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";
import "../cards/app_card.dart";
import "../display/app_chip.dart";
import "../display/image_url_validator.dart";

/// BlockCard compound widget for displaying a carnival block summary.
///
/// Shows: block image (100px, top-rounded) + block name + member count +
/// invite code (if present) + optional soft tag chips.
class BlockCard extends StatelessWidget {
  const BlockCard({
    super.key,
    required this.block,
    this.onTap,
    this.memberCount,
    this.tags,
  });

  /// The carnival block entity to display.
  final CarnivalBlocksEntity block;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Optional member count. When provided displays "N membros".
  /// When null displays "Sem membros".
  final int? memberCount;

  /// Optional list of tag strings rendered as soft chips below the info row.
  final List<String>? tags;

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    final shimmerColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final imageRadius = Radius.circular(Radii.card.topLeft.x);

    return AppCard(
      onTap: onTap,
      elevation: AppCardElevation.sm,
      padding: EdgeInsets.zero,
      // Defensive: clips any future visual overflow to card bounds.
      // The actual layout overflow is prevented by the 100px image header
      // and the removal of the 200px parent SizedBox in home_screen.dart.
      child: ClipRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Block image — 100px, top corners match card radius.
            // Guard with isValidImageUrl() because the backend sometimes returns
            // bare placeholder strings (e.g. "img") that would crash
            // CachedNetworkImageProvider asynchronously, escaping the
            // errorWidget callback and tripping the ImageResourceService.
            if (isValidImageUrl(block.carnivalBlockImage))
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: imageRadius),
                child: SizedBox(
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: block.carnivalBlockImage,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheManager: AppCacheManager.instance,
                    placeholder: (_, _) =>
                        Container(height: 100, color: shimmerColor),
                    errorWidget: (_, _, _) =>
                        Container(height: 100, color: shimmerColor),
                  ),
                ),
              )
            else
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: imageRadius),
                  color: shimmerColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.celebration_rounded,
                    size: 40,
                    color: onSurfaceVariant,
                  ),
                ),
              ),

            // Content padding + column.
            Padding(
              padding: const EdgeInsets.all(Spacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Block name.
                  Text(
                    block.name,
                    style: AppTypography.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: Spacing.space_xs),

                  // Member count row + invite code.
                  Row(
                    children: [
                      Icon(
                        Icons.group_rounded,
                        size: 14,
                        color: onSurfaceVariant,
                      ),
                      SizedBox(width: Spacing.space_2xs),
                      // Flexible allows this text to ellipsize when the row is
                      // narrow (e.g. card width 240px with a long invite code
                      // like "managers_invite_fulano_block"). Without Flexible
                      // the Row overflows on the right.
                      Flexible(
                        child: Text(
                          memberCount != null
                              ? "$memberCount membros"
                              : "Sem membros",
                          style: AppTypography.bodySmall.copyWith(
                            color: onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (block.inviteCode.isNotEmpty) ...[
                        SizedBox(width: Spacing.space_sm),
                        Icon(
                          Icons.qr_code_rounded,
                          size: 14,
                          color: onSurfaceVariant,
                        ),
                        SizedBox(width: Spacing.space_2xs),
                        Flexible(
                          child: Text(
                            block.inviteCode,
                            style: AppTypography.bodySmall.copyWith(
                              color: onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Optional tags.
                  if (tags?.isNotEmpty == true) ...[
                    SizedBox(height: Spacing.space_sm),
                    Wrap(
                      spacing: Spacing.space_2xs,
                      runSpacing: Spacing.space_2xs,
                      children: tags!
                          .map(
                            (t) => AppChip(label: t, variant: ChipVariant.soft),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
