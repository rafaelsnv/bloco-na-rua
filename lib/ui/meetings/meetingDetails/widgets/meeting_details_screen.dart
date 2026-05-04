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
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Presença atualizada com sucesso!'),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
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
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.markingPresenceError!)),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
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
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Erro ao excluir reunião'),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
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
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red.shade600,
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
              backgroundColor: Colors.grey.shade900,
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
                else
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade400),
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
                                    color: Colors.purpleAccent.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.event,
                                    color: Colors.purpleAccent.shade700,
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
                                Icons.location_on,
                                meeting.location!,
                                Colors.green,
                              ),
                            if (meetingDateTime != null) ...[
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.calendar_today,
                                DateFormat('EEEE, dd/MM/yyyy', 'pt_BR')
                                    .format(meetingDateTime),
                                Colors.blue,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.access_time,
                                DateFormat('HH:mm').format(meetingDateTime),
                                Colors.orange,
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
            icon: Icons.event_busy,
            message: 'Nenhum dado encontrado',
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
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
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
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
              backgroundColor: Colors.red.shade100,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                  : Icon(Icons.close, color: Colors.red.shade700),
              label: Text(
                'Não Vou',
                style: TextStyle(
                  color: Colors.red.shade700,
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
              backgroundColor: Colors.green.shade100,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green,
                      ),
                    )
                  : Icon(Icons.check, color: Colors.green.shade700),
              label: Text(
                'Eu Vou',
                style: TextStyle(
                  color: Colors.green.shade700,
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
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red),
            SizedBox(width: 8),
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
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade700,
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
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.presencesStatus == PresencesStatus.error) {
      return ErrorStateWidget(
        message: state.presencesError ?? 'Erro ao carregar presenças',
        onRetry: () => context.read<MeetingDetailsCubit>().loadPresences(),
      );
    }

    if (state.presences.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.people_outline,
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
            Colors.green,
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
            Colors.red,
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
      elevation: 2,
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
              color: Colors.grey.shade200,
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
                  color: presence.isPresent ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
