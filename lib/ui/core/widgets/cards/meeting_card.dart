import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_badge.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_chip.dart";
import "package:flutter/material.dart";

class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.meeting,
    this.onTap,
    this.totalPresences,
    this.confirmedPresences,
    this.showDescription = false,
    this.showMeetingCode = false,
  });

  /// The meeting data to display.
  final MeetingsEntity meeting;

  /// Optional tap callback forwarded to AppCard.
  final VoidCallback? onTap;

  /// Optional total expected presence count. When provided alongside
  /// [confirmedPresences], triggers the presence chips row.
  final int? totalPresences;

  /// Optional confirmed presence count. When provided alongside
  /// [totalPresences], triggers the presence chips row.
  final int? confirmedPresences;

  /// When true and [meeting.description] is non-null, renders the
  /// description as a second line below the location row.
  final bool showDescription;

  /// When true, renders the meeting code badge.
  final bool showMeetingCode;

  /// Formats a DateTime to "dd MMM yyyy • HH:mm" using [context]'s locale.
  /// Returns the localized "date not set" message when [dateTime] is null.
  String _formatDateTime(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) {
      return AppLocalizations.of(context)!.coreDateNotSet;
    }
    return formatDateTime(dateTime, context);
  }

  /// Returns a small [AppIconSizes.xs] icon with the onSurfaceVariant colour.
  Widget _icon(BuildContext context, IconData icon) {
    return Icon(
      icon,
      size: AppIconSizes.xs,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  /// A compact vertical gap using Spacing.space_4xs.
  Widget get _gap => SizedBox(height: Spacing.space_4xs);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      key: Key('meeting_card_${meeting.id}'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: meeting name + optional code badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  meeting.name ?? l10n.coreMeetingFallback,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showMeetingCode && meeting.meetingCode != null)
                AppBadge(label: meeting.meetingCode!, size: BadgeSize.sm),
            ],
          ),

          SizedBox(height: Spacing.space_xs),

          // Row 2: datetime
          Row(
            children: [
              _icon(context, Icons.event_rounded),
              SizedBox(width: Spacing.space_xs),
              // Flexible: the date wraps to a second line instead of
              // overflowing the row at a large text scale.
              Flexible(
                child: Text(
                  _formatDateTime(context, meeting.meetingDateTime),
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          // Optional location row
          if (meeting.location != null) ...[
            _gap,
            Row(
              children: [
                _icon(context, Icons.location_on_rounded),
                SizedBox(width: Spacing.space_xs),
                Expanded(
                  child: Text(
                    meeting.location!,
                    style: AppTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          // Optional description row
          if (showDescription && meeting.description != null) ...[
            _gap,
            Text(
              meeting.description!,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Optional presence chips row
          if (totalPresences != null && confirmedPresences != null) ...[
            _gap,
            // Wrap (not Row): the chips drop to the next line when they no
            // longer fit side by side on a narrow screen or at a large text
            // scale.
            Wrap(
              spacing: Spacing.space_xs,
              runSpacing: Spacing.space_4xs,
              children: [
                AppChip(
                  label: l10n.corePresencesCount(
                    confirmedPresences!,
                    totalPresences!,
                  ),
                  variant: ChipVariant.soft,
                  color: AppColors.primary,
                ),
                if (confirmedPresences == totalPresences)
                  AppChip.meetingStatus(l10n.corePresenceConfirmed)
                else if (confirmedPresences == 0)
                  AppChip.presenceAbsent(l10n.corePresencePending)
                else
                  AppChip(
                    label: l10n.corePresencePartial,
                    variant: ChipVariant.soft,
                    color: AppColors.warning,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
