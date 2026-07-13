import "package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/display/presence_chip.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_loading_indicator.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class MeetingDetailsScreen extends StatelessWidget {
  const MeetingDetailsScreen({super.key, required this.meetingId});

  final String meetingId;

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
          context.pop();
        } else if (state.deleteStatus == DeleteStatus.failure) {
          AppSnackbar.error(context, message: "Erro ao excluir reunião");
        }
      },
      builder: (context, state) {
        if (state is MeetingDetailsInitial) {
          context.read<MeetingDetailsCubit>().loadMeeting();
          return Scaffold(
            appBar: const AppAppBar(title: "Detalhes da Reunião"),
            body: const AppLoading(),
          );
        }

        if (state is MeetingDetailsLoading) {
          return Scaffold(
            appBar: const AppAppBar(title: "Detalhes da Reunião"),
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

          // Load presences if not loaded yet
          if (state.presencesStatus == PresencesStatus.initial) {
            context.read<MeetingDetailsCubit>().loadPresences();
          }

          final meetingDateTime = meeting.meetingDateTime != null
              ? DateTime.parse(meeting.meetingDateTime!)
              : null;

          return Scaffold(
            appBar: AppAppBar(
              title: meeting.name ?? "Detalhes da Reunião",
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
                    ),
                    const SizedBox(height: Spacing.space_md),
                    // Presences Section
                    AppSectionHeader(
                      title: "Lista de Presença",
                      action: TextButton(
                        onPressed: () =>
                            context.read<MeetingDetailsCubit>().loadPresences(),
                        child: const Text("Atualizar"),
                      ),
                    ),
                    const SizedBox(height: Spacing.space_2xs),
                    _PresencesSection(
                      state: state,
                      onRetry: () =>
                          context.read<MeetingDetailsCubit>().loadPresences(),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: _PresenceFABs(
              isLoading:
                  state.markingPresenceStatus == MarkingPresenceStatus.loading,
              onMarkPresent: () => context
                  .read<MeetingDetailsCubit>()
                  .markPresence(isPresent: true),
              onMarkAbsent: () => context
                  .read<MeetingDetailsCubit>()
                  .markPresence(isPresent: false),
            ),
          );
        }

        return Scaffold(
          appBar: const AppAppBar(title: "Detalhes da Reunião"),
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
        tooltip: "Excluir reunião",
        onPressed: () => _showDeleteDialog(context),
      ),
    ];
  }

  void _showDeleteDialog(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: "Excluir reunião",
      message:
          "Tem certeza que deseja excluir esta reunião? Esta ação não pode ser desfeita.",
      confirmLabel: "Excluir",
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<MeetingDetailsCubit>().deleteMeeting();
    }
  }
}

class _MeetingInfoCard extends StatelessWidget {
  const _MeetingInfoCard({required this.meeting, this.meetingDateTime});

  final MeetingsEntity meeting;
  final DateTime? meetingDateTime;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
                child: Text(
                  meeting.name ?? "",
                  style: AppTypography.headlineSmall,
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
          // Location
          if (meeting.location != null && meeting.location!.isNotEmpty)
            _InfoRow(
              icon: Icons.location_on_rounded,
              text: meeting.location!,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (meetingDateTime != null) ...[
            const SizedBox(height: Spacing.space_xs),
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              text: DateFormat(
                "EEEE, dd/MM/yyyy",
                "pt_BR",
              ).format(meetingDateTime!),
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: Spacing.space_xs),
            _InfoRow(
              icon: Icons.access_time_rounded,
              text: DateFormat("HH:mm").format(meetingDateTime!),
              color: Theme.of(context).colorScheme.tertiary,
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

class _PresencesSection extends StatelessWidget {
  const _PresencesSection({required this.state, required this.onRetry});

  final MeetingDetailsLoaded state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.presencesStatus == PresencesStatus.loading) {
      return AppCard(
        child: Padding(
          padding: EdgeInsets.all(Spacing.space_lg),
          child: Column(
            children: [
              AppLoadingIndicator(size: 32),
              const SizedBox(height: Spacing.space_sm),
              Text(
                "Carregando presenças...",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.presences.isEmpty) {
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

    final presentMembers = state.presences.where((p) => p.isPresent).toList();
    final absentMembers = state.presences.where((p) => !p.isPresent).toList();

    return Column(
      children: [
        if (presentMembers.isNotEmpty) ...[
          _PresenceGroup(
            title: "Presentes",
            presences: presentMembers,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.check_circle_rounded,
          ),
          const SizedBox(height: Spacing.space_xs),
        ],
        if (absentMembers.isNotEmpty)
          _PresenceGroup(
            title: "Ausentes",
            presences: absentMembers,
            color: Theme.of(context).colorScheme.error,
            icon: Icons.cancel_rounded,
          ),
      ],
    );
  }
}

class _PresenceGroup extends StatelessWidget {
  const _PresenceGroup({
    required this.title,
    required this.presences,
    required this.color,
    required this.icon,
  });

  final String title;
  final List<MeetingPresencesEntity> presences;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: AppCardElevation.none,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.space_sm,
              vertical: Spacing.space_xs,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Radii.radiusMd.topLeft.x),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: Spacing.space_2xs),
                Text(
                  "$title (${presences.length})",
                  style: AppTypography.titleSmall.copyWith(color: color),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: presences.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            itemBuilder: (context, index) {
              final presence = presences[index];
              // Build a synthetic MembersEntity for MemberCard
              final member = MembersEntity(
                id: presence.memberId,
                name: "Membro #${presence.memberId}",
              );
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.space_2xs,
                  vertical: Spacing.space_3xs,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MemberCard(member: member, showEmail: false),
                    ),
                    const SizedBox(width: Spacing.space_2xs),
                    presence.isPresent
                        ? PresenceChip.present()
                        : PresenceChip.absent(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PresenceFABs extends StatelessWidget {
  const _PresenceFABs({
    required this.isLoading,
    required this.onMarkPresent,
    required this.onMarkAbsent,
  });

  final bool isLoading;
  final VoidCallback onMarkPresent;
  final VoidCallback onMarkAbsent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Spacing.space_sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Deny FAB
          AppFAB(
            icon: Icons.close_rounded,
            onPressed: isLoading ? () {} : onMarkAbsent,
          ),
          const SizedBox(width: Spacing.space_sm),
          // Confirm FAB
          AppFAB(
            icon: Icons.check_rounded,
            onPressed: isLoading ? () {} : onMarkPresent,
          ),
        ],
      ),
    );
  }
}
