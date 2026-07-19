import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../../domain/entities/meetings/meetings_entity.dart";
import "../../tokens/app_colors.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";
import "../cards/app_card.dart";
import "../display/app_badge.dart";
import "../display/app_chip.dart";

class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.meeting,
    this.onTap,
    this.totalPresences,
    this.confirmedPresences,
    this.showDescription = false,
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

  /// Formats an ISO 8601 datetime string to "dd MMM yyyy • HH:mm" in pt-BR.
  /// Returns "Data nao definida" when [dateTimeStr] is null or invalid.
  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return "Data nao definida";
    }
    final parsed = DateTime.tryParse(dateTimeStr);
    if (parsed == null) {
      return "Data nao definida";
    }
    return DateFormat("dd MMM yyyy • HH:mm", "pt_BR").format(parsed);
  }

  /// Returns a small 14px icon with the onSurfaceVariant colour.
  Widget _icon(IconData icon) {
    return Icon(icon, size: 14, color: AppColors.textSecondary);
  }

  /// A compact vertical gap using Spacing.space_4xs.
  Widget get _gap => SizedBox(height: Spacing.space_4xs);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: Key('meeting_card_${meeting.id}'),
      onTap: onTap,
      elevation: AppCardElevation.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: meeting name + optional code badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  meeting.name ?? "Reuniao",
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (meeting.meetingCode != null)
                AppBadge(label: meeting.meetingCode!, size: BadgeSize.sm),
            ],
          ),

          SizedBox(height: Spacing.space_xs),

          // Row 2: datetime
          Row(
            children: [
              _icon(Icons.event_rounded),
              SizedBox(width: Spacing.space_xs),
              Text(
                _formatDateTime(meeting.meetingDateTime),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // Optional location row
          if (meeting.location != null) ...[
            _gap,
            Row(
              children: [
                _icon(Icons.location_on_rounded),
                SizedBox(width: Spacing.space_xs),
                Expanded(
                  child: Text(
                    meeting.location!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
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
            Row(
              children: [
                AppChip(
                  label: "$confirmedPresences/$totalPresences presencas",
                  variant: ChipVariant.soft,
                  color: AppColors.primary,
                ),
                SizedBox(width: Spacing.space_xs),
                if (confirmedPresences == totalPresences)
                  AppChip.meetingStatus("Confirmada")
                else if (confirmedPresences == 0)
                  AppChip.presenceAbsent("Pendente")
                else
                  AppChip(
                    label: "Parcial",
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
