import "package:flutter/material.dart";

import "../../../../domain/entities/members/members_entity.dart";
import "../../tokens/app_colors.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";
import "../display/app_avatar.dart";
import "../display/app_chip.dart";
import "app_card.dart";

/// A compound card widget that displays a member's avatar, name,
/// optional email subtitle, optional role chip, and optional online indicator.
class MemberCard extends StatelessWidget {
  /// Creates a MemberCard.
  ///
  /// [member] is required and provides the data to display.
  /// [onTap] is optional; when provided the card becomes interactive.
  /// [roleLabel] and [roleColor] control an optional role chip shown on the trailing side.
  /// [showEmail] controls whether the member's email is displayed as a subtitle.
  /// [isOnline] controls whether a green online indicator dot appears on the avatar.
  const MemberCard({
    super.key,
    required this.member,
    this.onTap,
    this.roleLabel,
    this.roleColor,
    this.showEmail = true,
    this.isOnline = false,
  });

  /// The member entity to display.
  final MembersEntity member;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Optional label for a role chip (e.g. "Organizadora").
  final String? roleLabel;

  /// Background color for the role chip. Defaults to [AppColors.primary].
  final Color? roleColor;

  /// Whether to display the member's email as a subtitle. Defaults to true.
  final bool showEmail;

  /// Whether to show a green online indicator dot on the avatar. Defaults to false.
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final onlineDot = _OnlineDot();

    return AppCard(
      key: Key('member_card_${member.id}'),
      onTap: onTap,
      elevation: AppCardElevation.sm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with optional online indicator
          Stack(
            children: [
              AppAvatar(
                imageUrl: member.profileImage,
                name: member.name,
                size: AvatarSize.md,
                imageCacheVersion: member.updatedAt,
              ),
              if (isOnline) Positioned(right: 0, bottom: 0, child: onlineDot),
            ],
          ),
          SizedBox(width: Spacing.space_md),
          // Name and optional email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  member.name ?? "Sem nome",
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showEmail && member.email != null) ...[
                  SizedBox(height: Spacing.space_4xs),
                  Text(
                    member.email!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Optional role chip
          if (roleLabel != null) ...[
            SizedBox(width: Spacing.space_sm),
            AppChip(
              label: roleLabel!,
              variant: ChipVariant.filled,
              color: roleColor ?? AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }
}

/// Green circle indicator representing online status.
///
/// 12px diameter, [AppColors.success] fill, 2px white border.
class _OnlineDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
