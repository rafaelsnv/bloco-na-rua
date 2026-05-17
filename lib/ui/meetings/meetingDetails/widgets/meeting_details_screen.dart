import 'package:bloco_na_rua/ui/core/colors/app_colors.dart';
import 'package:bloco_na_rua/ui/core/widgets/avatar_member.dart';
import 'package:bloco_na_rua/ui/core/widgets/empty_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/error_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/section_header.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MeetingDetailsScreen extends StatelessWidget {
  const MeetingDetailsScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeetingDetailsCubit, MeetingDetailsState>(
      listener: (context, state) {
        if (state is MeetingDetailsLoaded) {
          if (state.markingPresenceStatus == MarkingPresenceStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
                    const SizedBox(width: 8),
                    const Text('Presença atualizada com sucesso!'),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.markingPresenceStatus ==
                  MarkingPresenceStatus.error &&
              state.markingPresenceError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.markingPresenceError!)),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.deleteStatus == DeleteStatus.success) {
            context.pop();
          } else if (state.deleteStatus == DeleteStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
                    const SizedBox(width: 8),
                    const Text('Erro ao excluir reunião'),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
        if (state is MeetingDetailsError) {
ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is MeetingDetailsInitial) {
          context.read<MeetingDetailsCubit>().loadMeeting();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MeetingDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MeetingDetailsError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: ErrorStateWidget(
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
            appBar: AppBar(
              title: Text(meeting.name ?? 'Detalhes da Reunião'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              actions: [
                if (state.deleteStatus == DeleteStatus.deleting)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (state.canDeleteMeeting)
                  IconButton(
                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                    onPressed: () => _showDeleteDialog(context),
                  ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                final cubit = context.read<MeetingDetailsCubit>();
                await cubit.loadMeeting();
                await cubit.loadPresences();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meeting Info Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with icon
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.event,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    meeting.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            if (meeting.description != null &&
                                meeting.description!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                meeting.description!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            // Location
                            if (meeting.location != null &&
                                meeting.location!.isNotEmpty)
                              _buildInfoRow(
                                context,
                                Icons.location_on,
                                meeting.location!,
                                Theme.of(context).colorScheme.primary,
                              ),
                            if (meetingDateTime != null) ...[
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                context,
                                Icons.calendar_today,
                                DateFormat('EEEE, dd/MM/yyyy', 'pt_BR')
                                    .format(meetingDateTime),
                                Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                context,
                                Icons.access_time,
                                DateFormat('HH:mm').format(meetingDateTime),
                                Theme.of(context).colorScheme.tertiary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Presences Section
                    SectionHeader(
                      title: 'Lista de Presença',
                      action: 'Atualizar',
                      onAction: () =>
                          context.read<MeetingDetailsCubit>().loadPresences(),
                    ),
                    const SizedBox(height: 8),
                    _buildPresencesSection(context, state),
                  ],
                ),
              ),
            ),
            floatingActionButton: _buildPresenceFABs(context, state),
          );
        }

        return const Scaffold(
          body: EmptyStateWidget(
            message: 'Nenhum dado encontrado',
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildPresenceFABs(BuildContext context, MeetingDetailsLoaded state) {
    final isLoading = state.markingPresenceStatus == MarkingPresenceStatus.loading;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Deny FAB
          SizedBox(
            height: 56,
            child: FloatingActionButton.extended(
              heroTag: 'denyPresence',
              onPressed: isLoading
                  ? null
                  : () {
                      context
                          .read<MeetingDetailsCubit>()
                          .markPresence(isPresent: false);
                    },
              backgroundColor:
                  Theme.of(context).colorScheme.errorContainer,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : Icon(Icons.close,
                      color: Theme.of(context).colorScheme.onErrorContainer),
              label: Text(
                '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Confirm FAB
          SizedBox(
            height: 56,
            child: FloatingActionButton.extended(
              heroTag: 'confirmPresence',
              onPressed: isLoading
                  ? null
                  : () {
                      context
                          .read<MeetingDetailsCubit>()
                          .markPresence(isPresent: true);
                    },
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Icon(Icons.check,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
              label: Text(
                '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Text('Excluir reunião'),
          ],
        ),
        content: const Text('Tem certeza que deseja excluir esta reunião? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<MeetingDetailsCubit>().deleteMeeting();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Widget _buildPresencesSection(
    BuildContext context,
    MeetingDetailsLoaded state,
  ) {
    if (state.presencesStatus == PresencesStatus.loading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Carregando presenças...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.presences.isEmpty) {
      return const EmptyStateWidget(
        message: 'Ninguém confirmou presença ainda',
        subtitle: 'Seja o primeiro a confirmar!',
      );
    }

    final presentMembers =
        state.presences.where((p) => p.isPresent).toList();
    final absentMembers =
        state.presences.where((p) => !p.isPresent).toList();

    return Column(
      children: [
        // Present members
        if (presentMembers.isNotEmpty) ...[
          _buildPresenceGroup(
            context,
            'Presentes',
            presentMembers,
            Theme.of(context).colorScheme.primary,
            Icons.check_circle,
          ),
          const SizedBox(height: 12),
        ],
        // Absent members
        if (absentMembers.isNotEmpty)
          _buildPresenceGroup(
            context,
            'Ausentes',
            absentMembers,
            Theme.of(context).colorScheme.error,
            Icons.cancel,
          ),
      ],
    );
  }

  Widget _buildPresenceGroup(
    BuildContext context,
    String title,
    List presences,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$title (${presences.length})',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
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
              return ListTile(
                leading: AvatarMember(memberId: presence.memberId),
                title: Text(
                  'Membro #${presence.memberId}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  presence.isPresent ? Icons.check : Icons.close,
                  color: presence.isPresent
                      ? AppColors.success
                      : Theme.of(context).colorScheme.error,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
