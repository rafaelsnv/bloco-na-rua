import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_chip.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_loading_indicator.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_search_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

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

        if (state.markingPresenceStatus == MarkingPresenceStatus.success) {
          AppSnackbar.success(
            context,
            message: "Presença atualizada com sucesso!",
          );
        } else if (state.markingPresenceStatus == MarkingPresenceStatus.error &&
            state.markingPresenceError != null) {
          AppSnackbar.error(context, message: state.markingPresenceError!);
        } else if (state.deleteStatus == DeleteStatus.success) {
          if (context.mounted) {
            context.read<UserMeetingsCubit>().loadMeetings();
            context.read<HomeCubit>().loadHomeData();
          }
          context.pop();
        } else if (state.deleteStatus == DeleteStatus.failure) {
          AppSnackbar.error(context, message: "Erro ao excluir encontro");
        }
      },
      builder: (context, state) {
        if (state is MeetingDetailsInitial) {
          return Scaffold(
            appBar: const AppAppBar(title: "Detalhes do Encontro"),
            body: const AppLoading(),
          );
        }

        if (state is MeetingDetailsLoading) {
          return Scaffold(
            appBar: const AppAppBar(title: "Detalhes do Encontro"),
            body: const AppLoading(),
          );
        }

        if (state is MeetingDetailsError) {
          return Scaffold(
            appBar: const AppAppBar(title: "Erro"),
            body: AppError(
              message: state.message,
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
              title: meeting.name ?? "Detalhes do Encontro",
              actions: _buildAppBarActions(context, state),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                final cubit = context.read<MeetingDetailsCubit>();
                await cubit.loadMeeting();
                await cubit.loadPresences();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(Spacing.pagePaddingMobile),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.pagePaddingMobile,
                        vertical: Spacing.space_2xs,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: Spacing.space_2xs),
                          Flexible(
                            child: Text(
                              "Lista de Presença",
                              style: AppTypography.headlineSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Spacing.space_2xs),
                          AppChip(
                            label:
                                "${state.presences.where((p) => p.isPresent).length}/${state.blockMembers.isNotEmpty ? state.blockMembers.length : state.presences.length}",
                            variant: ChipVariant.soft,
                            color: AppColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.space_2xs,
                              vertical: Spacing.space_4xs,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.space_xs),
                    // Prominent confirm-presence button — replaces the FAB.
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.pagePaddingMobile,
                      ),
                      child: AppButton(
                        key: const Key("button_confirm_presence"),
                        label: "Confirmar Presença",
                        variant: AppButtonVariant.accent,
                        isFullWidth: true,
                        icon: const Icon(Icons.check_rounded),
                        isLoading: isMarkingPresence,
                        onPressed: isMarkingPresence
                            ? null
                            : () => context
                                  .read<MeetingDetailsCubit>()
                                  .markPresence(isPresent: true),
                      ),
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
          );
        }

        return Scaffold(
          appBar: const AppAppBar(title: "Detalhes do Encontro"),
          body: const AppEmpty(message: "Nenhum dado encontrado"),
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
            width: 20,
            height: 20,
            child: AppLoadingIndicator(
              size: 20,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ];
    }

    if (!state.canDeleteMeeting) return null;

    return [
      IconButton(
        icon: Icon(
          Icons.delete_outline_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
        tooltip: "Excluir encontro",
        onPressed: () => _showDeleteDialog(context),
      ),
    ];
  }

  void _showDeleteDialog(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: "Excluir encontro",
      message:
          "Tem certeza que deseja excluir este encontro? Esta ação não pode ser desfeita.",
      confirmLabel: "Excluir",
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

  String get _statusLabel {
    if (meetingDateTime == null) return "Próxima";
    final now = DateTime.now();
    if (meetingDateTime!.isBefore(now)) {
      return "Realizada";
    } else if (meetingDateTime!.isBefore(now.add(const Duration(hours: 1)))) {
      return "Em breve";
    } else {
      return "Próxima";
    }
  }

  Color get _statusColor {
    if (meetingDateTime == null) return AppColors.accent;
    final now = DateTime.now();
    if (meetingDateTime!.isBefore(now)) {
      return AppColors.success;
    } else if (meetingDateTime!.isBefore(now.add(const Duration(hours: 1)))) {
      return AppColors.warning;
    } else {
      return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Status chip floats on the card's top edge via a Stack.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(Spacing.space_xs),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: Radii.radiusMd,
                    ),
                    child: Icon(
                      Icons.event_rounded,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
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
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
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
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: Spacing.space_sm),
              // Date + time in a single row
              if (meetingDateTime != null)
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  text: DateFormat(
                    "EEEE, dd/MM/yyyy • HH:mm",
                    "pt_BR",
                  ).format(meetingDateTime!),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              // Location last
              if (meeting.location != null && meeting.location!.isNotEmpty) ...[
                const SizedBox(height: Spacing.space_xs),
                _InfoRow(
                  icon: Icons.location_on_rounded,
                  text: meeting.location!,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
        // Status chip stacked on the card's top edge.
        Positioned(
          top: Spacing.space_3xs,
          right: Spacing.space_xs,
          child: AppChip(
            label: _statusLabel,
            variant: ChipVariant.filled,
            color: _statusColor,
          ),
        ),
      ],
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
            color: color.withValues(alpha: 0.1),
            borderRadius: Radii.radiusSm,
          ),
          child: Icon(icon, size: 20, color: color),
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
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPresent ? AppColors.success : AppColors.error,
      ),
      child: Icon(
        isPresent ? Icons.check_rounded : Icons.close_rounded,
        size: 16,
        color: AppColors.textOnPrimary,
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
  List<_MemberEntry> get _allEntries {
    final state = widget.state;
    final presenceByMember = {for (final p in state.presences) p.memberId: p};
    if (state.blockMembers.isNotEmpty) {
      return [
        for (final bm in state.blockMembers)
          _MemberEntry(
            member:
                state.memberEntities[bm.memberId] ??
                MembersEntity(id: bm.memberId, name: "Membro"),
            isPresent: presenceByMember[bm.memberId]?.isPresent,
          ),
      ];
    }
    return [
      for (final p in state.presences)
        _MemberEntry(
          member: MembersEntity(id: p.memberId, name: "Membro #${p.memberId}"),
          isPresent: p.isPresent,
        ),
    ];
  }

  List<_MemberEntry> get _visibleEntries {
    final query = _searchQuery.toLowerCase();
    final list =
        _allEntries.where((entry) {
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
    if (state.presencesStatus == PresencesStatus.loading) {
      return AppCard(
        child: Padding(
          padding: EdgeInsets.all(Spacing.space_lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: AppLoadingIndicator(size: 32)),
              const SizedBox(height: Spacing.space_sm),
              Text(
                "Carregando presenças...",
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

    final allEntries = _allEntries;
    if (allEntries.isEmpty) {
      return AppCard(
        child: Padding(
          padding: EdgeInsets.all(Spacing.space_md),
          child: AppEmpty(
            message: "Ninguém confirmou presença ainda",
            icon: Icons.people_outline_rounded,
          ),
        ),
      );
    }

    final entries = _visibleEntries;
    final isBusy = state.markingPresenceStatus == MarkingPresenceStatus.loading;

    return AppCard(
      elevation: AppCardElevation.none,
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
                    hint: "Buscar membro...",
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: Spacing.space_xs),
                _buildSortFilterMenu(),
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
                message: "Nenhum membro encontrado",
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
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.space_2xs,
                    vertical: Spacing.space_3xs,
                  ),
                  child: MemberCard(
                    member: entry.member,
                    showEmail: false,
                    // Owners/managers toggle presence by tapping the card.
                    onTap: state.canManagePresence && !isBusy
                        ? () => _confirmSetPresence(context, entry)
                        : null,
                    trailing: _PresenceBadge(
                      isPresent: entry.isPresent ?? false,
                    ),
                  ),
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
    final confirmed = await AppDialog.confirm(
      context,
      title: "Alterar presença",
      message:
          "Marcar ${entry.member.name ?? "este membro"} como ${isPresent ? "presente" : "ausente"}?",
      confirmLabel: "Confirmar",
      cancelLabel: "Cancelar",
    );
    if (confirmed == true && context.mounted) {
      context.read<MeetingDetailsCubit>().setMemberPresence(
        memberId: entry.member.id,
        isPresent: isPresent,
      );
    }
  }

  Widget _buildSortFilterMenu() {
    return PopupMenuButton<Object>(
      icon: const Icon(Icons.sort_rounded),
      tooltip: "Ordenar e filtrar",
      onSelected: (value) {
        if (value is _PresenceSort) {
          setState(() => _sort = value);
        } else if (value is _PresenceFilter) {
          setState(() => _filter = value);
        }
      },
      itemBuilder: (context) => [
        _menuHeader("Ordenar"),
        _checkItem(
          _PresenceSort.name,
          "Nome (A-Z)",
          _sort == _PresenceSort.name,
        ),
        _checkItem(
          _PresenceSort.presentFirst,
          "Presentes primeiro",
          _sort == _PresenceSort.presentFirst,
        ),
        _checkItem(
          _PresenceSort.absentFirst,
          "Ausentes primeiro",
          _sort == _PresenceSort.absentFirst,
        ),
        const PopupMenuDivider(),
        _menuHeader("Filtrar"),
        _checkItem(
          _PresenceFilter.all,
          "Todos",
          _filter == _PresenceFilter.all,
        ),
        _checkItem(
          _PresenceFilter.present,
          "Presentes",
          _filter == _PresenceFilter.present,
        ),
        _checkItem(
          _PresenceFilter.absent,
          "Ausentes",
          _filter == _PresenceFilter.absent,
        ),
      ],
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
            width: 24,
            child: checked
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
          Text(label),
        ],
      ),
    );
  }
}
