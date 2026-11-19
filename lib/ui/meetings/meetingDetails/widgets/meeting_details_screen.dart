import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_chip.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_icon_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_loading_indicator.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_search_field.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart";
import "package:bloco_na_rua/ui/meetings/meeting_error.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class MeetingDetailsScreen extends StatefulWidget {
  const MeetingDetailsScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MeetingDetailsCubit>().loadMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeetingDetailsCubit, MeetingDetailsState>(
      listenWhen: (previous, current) {
        if (previous is MeetingDetailsLoaded &&
            current is MeetingDetailsLoaded) {
          return previous.markingPresenceStatus !=
              current.markingPresenceStatus;
        }
        return false;
      },
      listener: (context, state) {
        if (state is! MeetingDetailsLoaded) return;

        final l10n = AppLocalizations.of(context)!;
        if (state.markingPresenceStatus == MarkingPresenceStatus.success) {
          AppSnackbar.success(context, message: l10n.meetingsPresenceUpdated);
        } else if (state.markingPresenceStatus == MarkingPresenceStatus.error &&
            state.markingPresenceError != null) {
          AppSnackbar.error(
            context,
            message: localizeMeetingError(context, state.markingPresenceError!),
          );
        } else if (state.deleteStatus == DeleteStatus.success) {
          if (context.mounted) {
            context.read<UserMeetingsCubit>().loadMeetings();
            context.read<HomeCubit>().loadHomeData();
          }
          context.pop();
        } else if (state.deleteStatus == DeleteStatus.failure) {
          AppSnackbar.error(context, message: l10n.meetingsDeleteError);
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is MeetingDetailsInitial) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.meetingsDetailsTitle),
            body: const AppLoading(),
          );
        }

        if (state is MeetingDetailsLoading) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.meetingsDetailsTitle),
            body: const AppLoading(),
          );
        }

        if (state is MeetingDetailsError) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.errorTitle),
            body: AppError(
              message: localizeMeetingError(context, state.error),
              onRetry: () => context.read<MeetingDetailsCubit>().loadMeeting(),
            ),
          );
        }

        if (state is MeetingDetailsLoaded) {
          final meeting = state.meeting;

          final meetingDateTime = meeting.meetingDateTime;
          final isMarkingPresence =
              state.markingPresenceStatus == MarkingPresenceStatus.loading;

          return Scaffold(
            appBar: AppAppBar(
              title: meeting.name ?? l10n.meetingsDetailsTitle,
              actions: _buildAppBarActions(context, state),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                final cubit = context.read<MeetingDetailsCubit>();
                await cubit.loadMeeting();
                await cubit.loadPresences();
              },
              child: ContentWidthLimiter(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.pagePaddingFor(context),
                    vertical: Spacing.pagePaddingMobile,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meeting Info Card
                      _MeetingInfoCard(
                        meeting: meeting,
                        meetingDateTime: meetingDateTime,
                        blockName: state.blockName,
                      ),
                      const SizedBox(height: Spacing.sectionGap),
                      // Presences Section — header row + prominent confirm button.
                      AppSectionHeader(
                        title: l10n.meetingsPresenceListTitle,
                        leading: Icon(
                          Icons.people_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: AppIconSizes.lg,
                        ),
                        titleTrailing: AppChip(
                          label:
                              "${state.presences.where((p) => p.isPresent).length}/${state.blockMembers.isNotEmpty ? state.blockMembers.length : state.presences.length}",
                          variant: ChipVariant.soft,
                          color: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.space_2xs,
                            vertical: Spacing.space_4xs,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.space_xs),
                      // Prominent confirm-presence button — replaces the FAB.
                      // No extra horizontal padding: the scroll view already
                      // insets the column, so the button lines up with the
                      // header and the cards below it.
                      AppButton(
                        key: const Key("button_confirm_presence"),
                        label: l10n.meetingsConfirmPresence,
                        variant: AppButtonVariant.accent,
                        size: AppButtonSizeMetrics.sm,
                        isFullWidth: true,
                        icon: const Icon(Icons.check_rounded),
                        isLoading: isMarkingPresence,
                        onPressed: isMarkingPresence
                            ? null
                            : () => context
                                  .read<MeetingDetailsCubit>()
                                  .markPresence(isPresent: true),
                      ),
                      const SizedBox(height: Spacing.sectionGap),
                      _PresencesSection(
                        state: state,
                        onRetry: () =>
                            context.read<MeetingDetailsCubit>().loadPresences(),
                      ),
                      const SizedBox(height: Spacing.sectionGap),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppAppBar(title: l10n.meetingsDetailsTitle),
          body: AppEmpty(message: l10n.meetingsNoData),
        );
      },
    );
  }

  List<Widget>? _buildAppBarActions(
    BuildContext context,
    MeetingDetailsLoaded state,
  ) {
    if (state.deleteStatus == DeleteStatus.deleting) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.space_sm),
          child: SizedBox(
            width: AppIconSizes.md,
            height: AppIconSizes.md,
            child: AppLoadingIndicator(
              size: AppIconSizes.md,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ];
    }

    if (!state.canDeleteMeeting) return null;

    final l10n = AppLocalizations.of(context)!;
    return [
      Semantics(
        label: l10n.meetingsDeleteTitle,
        button: true,
        child: IconButton(
          icon: Icon(
            Icons.delete_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          tooltip: l10n.meetingsDeleteTitle,
          onPressed: () => _showDeleteDialog(context),
        ),
      ),
    ];
  }

  void _showDeleteDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.meetingsDeleteTitle,
      message: l10n.meetingsDeleteConfirmMessage,
      confirmLabel: l10n.meetingsDeleteAction,
      cancelLabel: l10n.meetingsCancel,
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<MeetingDetailsCubit>().deleteMeeting();
    }
  }
}

class _MeetingInfoCard extends StatelessWidget {
  const _MeetingInfoCard({
    required this.meeting,
    this.meetingDateTime,
    this.blockName,
  });

  final MeetingsEntity meeting;
  final DateTime? meetingDateTime;
  final String? blockName;

  String _statusLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (meetingDateTime == null) return l10n.meetingsStatusUpcoming;
    final now = DateTime.now();
    if (meetingDateTime!.isBefore(now)) {
      return l10n.meetingsStatusDone;
    } else if (meetingDateTime!.isBefore(now.add(const Duration(hours: 1)))) {
      return l10n.meetingsStatusSoon;
    } else {
      return l10n.meetingsStatusUpcoming;
    }
  }

  Color get _statusColor {
    if (meetingDateTime == null) return AppColors.accent;
    final now = DateTime.now();
    if (meetingDateTime!.isBefore(now)) {
      return AppColors.successContainerLight;
    } else if (meetingDateTime!.isBefore(now.add(const Duration(hours: 1)))) {
      return AppColors.warning;
    } else {
      return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row — the status chip is a trailing widget of this row, so
          // the expanded title always reserves room for it and never overlaps.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconTile(
                icon: Icons.event_rounded,
                backgroundColor: cs.primaryContainer,
                size: AppIconSizes.headerTile,
                radius: Radii.md,
                iconSize: AppIconSizes.xl,
                foregroundColor: cs.onPrimaryContainer,
              ),
              const SizedBox(width: Spacing.space_xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.name ?? "",
                      style: AppTypography.headlineSmall,
                    ),
                    if (blockName != null && blockName!.isNotEmpty)
                      Text(
                        blockName!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.space_xs),
              AppChip(
                label: _statusLabel(context),
                variant: ChipVariant.filled,
                color: _statusColor,
              ),
            ],
          ),
          if (meeting.description != null &&
              meeting.description!.isNotEmpty) ...[
            const SizedBox(height: Spacing.space_sm),
            Text(
              meeting.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: Spacing.space_sm),
          Divider(color: cs.outlineVariant),
          const SizedBox(height: Spacing.space_sm),
          // Date + time in a single row
          if (meetingDateTime != null)
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              text: formatDatePattern(
                "EEEE, dd/MM/yyyy • HH:mm",
                meetingDateTime!,
                context,
              ),
              color: cs.primary,
            ),
          // Location last
          if (meeting.location != null && meeting.location!.isNotEmpty) ...[
            const SizedBox(height: Spacing.space_xs),
            _InfoRow(
              icon: Icons.location_on_rounded,
              text: meeting.location!,
              color: cs.primary,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(Spacing.space_2xs),
          decoration: BoxDecoration(
            color: AppColors.tint(color),
            borderRadius: Radii.radiusSm,
          ),
          child: Icon(icon, size: AppIconSizes.md, color: color),
        ),
        const SizedBox(width: Spacing.space_xs),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

enum _PresenceSort { name, presentFirst, absentFirst }

enum _PresenceFilter { all, present, absent }

/// Round icon-only presence badge shown inside the member card.
class _PresenceBadge extends StatelessWidget {
  const _PresenceBadge({required this.isPresent});

  final bool isPresent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      // The badge is icon-only — announce the presence state. `container`
      // keeps it a node of its own instead of merging into the member row.
      container: true,
      label: isPresent ? l10n.meetingsPresent : l10n.meetingsAbsent,
      child: Container(
        width: AppIconSizes.xl,
        height: AppIconSizes.xl,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPresent ? AppColors.success : AppColors.error,
        ),
        child: Icon(
          isPresent ? Icons.check_rounded : Icons.close_rounded,
          size: AppIconSizes.sm,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}

/// One row in the presence list: a block member and their presence status
/// (null = no presence record yet).
class _MemberEntry {
  const _MemberEntry({required this.member, this.isPresent});

  final MembersEntity member;
  final bool? isPresent;
}

class _PresencesSection extends StatefulWidget {
  const _PresencesSection({required this.state, required this.onRetry});

  final MeetingDetailsLoaded state;
  final VoidCallback onRetry;

  @override
  State<_PresencesSection> createState() => _PresencesSectionState();
}

class _PresencesSectionState extends State<_PresencesSection> {
  String _searchQuery = "";
  _PresenceSort _sort = _PresenceSort.name;
  _PresenceFilter _filter = _PresenceFilter.all;

  /// All members: the block roster when loaded (real names), otherwise
  /// derived from presence rows as a fallback.
  List<_MemberEntry> _allEntries(AppLocalizations l10n) {
    final state = widget.state;
    final presenceByMember = {for (final p in state.presences) p.memberId: p};
    if (state.blockMembers.isNotEmpty) {
      return [
        for (final bm in state.blockMembers)
          _MemberEntry(
            member:
                state.memberEntities[bm.memberId] ??
                MembersEntity(
                  id: bm.memberId,
                  name: l10n.meetingsMemberFallback,
                ),
            isPresent: presenceByMember[bm.memberId]?.isPresent,
          ),
      ];
    }
    return [
      for (final p in state.presences)
        _MemberEntry(
          member: MembersEntity(
            id: p.memberId,
            name: l10n.meetingsMemberNumber(p.memberId),
          ),
          isPresent: p.isPresent,
        ),
    ];
  }

  List<_MemberEntry> _visibleEntries(AppLocalizations l10n) {
    final query = _searchQuery.toLowerCase();
    final list =
        _allEntries(l10n).where((entry) {
          final matchesFilter = switch (_filter) {
            _PresenceFilter.all => true,
            _PresenceFilter.present => entry.isPresent == true,
            _PresenceFilter.absent => entry.isPresent != true,
          };
          final name = (entry.member.name ?? "").toLowerCase();
          return matchesFilter && (query.isEmpty || name.contains(query));
        }).toList()..sort((a, b) {
          final byName = (a.member.name ?? "").compareTo(b.member.name ?? "");
          final aPresent = a.isPresent == true;
          final bPresent = b.isPresent == true;
          return switch (_sort) {
            _PresenceSort.name => byName,
            _PresenceSort.presentFirst =>
              aPresent == bPresent ? byName : (aPresent ? -1 : 1),
            _PresenceSort.absentFirst =>
              aPresent == bPresent ? byName : (aPresent ? 1 : -1),
          };
        });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final l10n = AppLocalizations.of(context)!;
    if (state.presencesStatus == PresencesStatus.loading) {
      return AppCard(
        child: Padding(
          padding: EdgeInsets.all(Spacing.space_lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: AppLoadingIndicator(size: AppIconSizes.xxl)),
              const SizedBox(height: Spacing.space_sm),
              Text(
                l10n.meetingsLoadingPresences,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final allEntries = _allEntries(l10n);
    if (allEntries.isEmpty) {
      return AppCard(
        child: Padding(
          padding: EdgeInsets.all(Spacing.space_md),
          child: AppEmpty(
            message: l10n.meetingsNoPresenceYet,
            icon: Icons.people_outline_rounded,
          ),
        ),
      );
    }

    final entries = _visibleEntries(l10n);
    final isBusy = state.markingPresenceStatus == MarkingPresenceStatus.loading;

    return AppCard(
      elevation: AppElevation.none,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Search + sort/filter, inside the list card.
          Padding(
            padding: EdgeInsets.all(Spacing.space_xs),
            child: Row(
              children: [
                Expanded(
                  child: AppSearchField(
                    hint: l10n.meetingsSearchMemberHint,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: Spacing.space_xs),
                _buildSortFilterMenu(l10n),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          if (entries.isEmpty)
            Padding(
              padding: EdgeInsets.all(Spacing.space_md),
              child: AppEmpty(
                message: l10n.meetingsNoMemberFound,
                icon: Icons.search_off_rounded,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final canToggle = state.canManagePresence && !isBusy;
                final card = MemberCard(
                  member: entry.member,
                  showEmail: false,
                  // Owners/managers toggle presence by tapping the card.
                  onTap: canToggle
                      ? () => _confirmSetPresence(context, entry)
                      : null,
                  trailing: _PresenceBadge(isPresent: entry.isPresent ?? false),
                );
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.space_2xs,
                    vertical: Spacing.space_3xs,
                  ),
                  child: canToggle
                      // Announce the tap action for screen readers.
                      ? Semantics(
                          container: true,
                          label: l10n.meetingsMarkPresenceOf(
                            entry.member.name ?? l10n.meetingsMemberFallback,
                          ),
                          button: true,
                          child: card,
                        )
                      : card,
                );
              },
            ),
        ],
      ),
    );
  }

  /// Asks for confirmation before changing a member's presence.
  Future<void> _confirmSetPresence(
    BuildContext context,
    _MemberEntry entry,
  ) async {
    final isPresent = !(entry.isPresent ?? false);
    final l10n = AppLocalizations.of(context)!;
    final memberName = entry.member.name ?? l10n.meetingsMemberFallback;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.meetingsChangePresenceTitle,
      message: isPresent
          ? l10n.meetingsMarkPresent(memberName)
          : l10n.meetingsMarkAbsent(memberName),
      confirmLabel: l10n.meetingsConfirm,
      cancelLabel: l10n.meetingsCancel,
    );
    if (confirmed == true && context.mounted) {
      context.read<MeetingDetailsCubit>().setMemberPresence(
        memberId: entry.member.id,
        isPresent: isPresent,
      );
    }
  }

  Widget _buildSortFilterMenu(AppLocalizations l10n) {
    return Semantics(
      label: l10n.meetingsSortFilterTooltip,
      button: true,
      child: PopupMenuButton<Object>(
        icon: const Icon(Icons.sort_rounded),
        tooltip: l10n.meetingsSortFilterTooltip,
        onSelected: (value) {
          if (value is _PresenceSort) {
            setState(() => _sort = value);
          } else if (value is _PresenceFilter) {
            setState(() => _filter = value);
          }
        },
        itemBuilder: (context) => [
          _menuHeader(l10n.meetingsSortHeader),
          _checkItem(
            _PresenceSort.name,
            l10n.meetingsSortByName,
            _sort == _PresenceSort.name,
          ),
          _checkItem(
            _PresenceSort.presentFirst,
            l10n.meetingsSortPresentFirst,
            _sort == _PresenceSort.presentFirst,
          ),
          _checkItem(
            _PresenceSort.absentFirst,
            l10n.meetingsSortAbsentFirst,
            _sort == _PresenceSort.absentFirst,
          ),
          const PopupMenuDivider(),
          _menuHeader(l10n.meetingsFilterHeader),
          _checkItem(
            _PresenceFilter.all,
            l10n.meetingsFilterAll,
            _filter == _PresenceFilter.all,
          ),
          _checkItem(
            _PresenceFilter.present,
            l10n.meetingsFilterPresent,
            _filter == _PresenceFilter.present,
          ),
          _checkItem(
            _PresenceFilter.absent,
            l10n.meetingsFilterAbsent,
            _filter == _PresenceFilter.absent,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<Object> _menuHeader(String label) {
    return PopupMenuItem<Object>(
      enabled: false,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  PopupMenuItem<Object> _checkItem(Object value, String label, bool checked) {
    return PopupMenuItem<Object>(
      value: value,
      child: Row(
        children: [
          SizedBox(
            width: AppIconSizes.lg,
            child: checked
                ? Icon(
                    Icons.check_rounded,
                    size: AppIconSizes.sm,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
          Text(label, style: AppTypography.titleMedium),
        ],
      ),
    );
  }
}
