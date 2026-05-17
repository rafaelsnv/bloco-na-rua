import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart';
import 'package:bloco_na_rua/ui/core/colors/app_colors.dart';
import 'package:bloco_na_rua/ui/core/widgets/avatar_member.dart';
import 'package:bloco_na_rua/ui/core/widgets/copy_code_card.dart';
import 'package:bloco_na_rua/ui/core/widgets/empty_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/error_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/section_header.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BlockDetailsScreen extends StatefulWidget {
  const BlockDetailsScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<BlockDetailsScreen> createState() => _BlockDetailsScreenState();
}

class _BlockDetailsScreenState extends State<BlockDetailsScreen> {
  List<CarnivalBlockMembersEntity> _members = [];
  List<MeetingsEntity> _meetings = [];
  bool _loadingMembers = false;
  bool _loadingMeetings = false;
  String? _membersError;
  String? _meetingsError;
  int? _deletingMemberId;
  Map<int, String> _memberNames = {};

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadMeetings();
  }

  Future<void> _loadMembers() async {
    final repo = context.read<ICarnivalBlockMembersRepository>();
    final membersRepo = context.read<IMembersRepository>();
    setState(() {
      _loadingMembers = true;
      _membersError = null;
    });

    final result = await repo.getByBlockIdAsync(
      int.parse(widget.carnivalBlockId),
    );

    result.fold(
      (members) async {
        // Fetch member names
        final memberNames = <int, String>{};
        for (final member in members) {
          final memberResult = await membersRepo.getByIdAsync(member.memberId);
          memberResult.fold(
            (m) => memberNames[member.memberId] = m.name ?? 'Membro',
            (_) => memberNames[member.memberId] = 'Membro',
          );
        }
        if (mounted) {
          setState(() {
            _members = members;
            _memberNames = memberNames;
            _loadingMembers = false;
          });
        }
      },
      (failure) => setState(() {
        _membersError = failure.toString();
        _loadingMembers = false;
      }),
    );
  }

  Future<void> _loadMeetings() async {
    final repo = context.read<IMeetingsRepository>();
    setState(() {
      _loadingMeetings = true;
      _meetingsError = null;
    });

    final result = await repo.getAllByBlockId(
      int.parse(widget.carnivalBlockId),
    );

    result.fold(
      (meetings) => setState(() {
        _meetings = meetings;
        _loadingMeetings = false;
      }),
      (failure) => setState(() {
        _meetingsError = failure.toString();
        _loadingMeetings = false;
      }),
    );
  }

  Future<void> _deleteMember(CarnivalBlockMembersEntity member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.person_remove, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Remover membro'),
          ],
        ),
        content: const Text('Remover este membro do bloco?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() {
      _deletingMemberId = member.id;
    });

    final repo = context.read<ICarnivalBlockMembersRepository>();
    final result = await repo.deleteAsync(member.id, member.memberId);

    if (!mounted) return;

    result.fold(
      (success) {
        if (!mounted) return;
        setState(() {
          _members = _members.where((m) => m.id != member.id).toList();
          _deletingMemberId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onError),
                const SizedBox(width: 8),
                const Text('Membro removido com sucesso'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      (failure) {
        if (!mounted) return;
        setState(() {
          _deletingMemberId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
                const SizedBox(width: 8),
                Expanded(child: Text('Erro ao remover membro: $failure')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlockDetailsCubit, BlockDetailsState>(
      buildWhen: (previous, current) =>
          current is BlockDetailsLoaded && previous != current,
      builder: (context, state) {
        final canManageMembers = state is BlockDetailsLoaded && state.canManageMembers;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Detalhes do Bloco"),
            actions: [
              if (canManageMembers) ...[
                IconButton(
                  icon: const Icon(Icons.add_alert),
                  tooltip: 'Criar Reunião',
                  onPressed: () =>
                      context.push('/create-meeting/${widget.carnivalBlockId}'),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar Bloco',
                  onPressed: () =>
                      context.push('/edit-block/${widget.carnivalBlockId}'),
                ),
              ],
            ],
          ),
          body: SafeArea(
            child: BlocConsumer<BlockDetailsCubit, BlockDetailsState>(
              listener: (context, state) {
                if (state is BlockDetailsError) {
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
                if (state is BlockDetailsLoading || state is BlockDetailsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BlockDetailsError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () => context.read<BlockDetailsCubit>().loadBlock(),
                  );
                }

                if (state is BlockDetailsLoaded) {
                  final carnivalBlock = state.carnivalBlock;
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _loadMembers();
                      await _loadMeetings();
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Block info card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Block name
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.celebration,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        carnivalBlock.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Block image - don't show on error
                                if (carnivalBlock.carnivalBlockImage.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      carnivalBlock.carnivalBlockImage,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                if (carnivalBlock.carnivalBlockImage.isNotEmpty)
                                  const SizedBox(height: 16),
                                // Invite codes - only visible to owner/manager
                                if (canManageMembers) ...[
                                  CopyCodeCard(
                                    code: carnivalBlock.inviteCode,
                                    label: 'Código de convite',
                                  ),
                                  const SizedBox(height: 8),
                                  CopyCodeCard(
                                    code: carnivalBlock.managersInviteCode,
                                    label: 'Código gerente',
                                    isManager: true,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Meetings section
                        SectionHeader(
                          title: 'Encontros',
                          action: canManageMembers ? 'Criar' : null,
                          onAction: canManageMembers
                              ? () => context.push('/create-meeting/${widget.carnivalBlockId}')
                              : null,
                        ),
                        _buildMeetingsSection(),
                        const SizedBox(height: 24),
                        // Members section
                        SectionHeader(
                          title: 'Membros',
                          action: canManageMembers ? 'Adicionar' : null,
                          onAction: canManageMembers
                              ? () => context.push('/add-member/${widget.carnivalBlockId}')
                              : null,
                        ),
                        _buildMembersSection(canManageMembers),
                      ],
                    ),
                  );
                }

                return const EmptyStateWidget(
                  message: 'Bloco não encontrado',
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeetingsSection() {
    if (_loadingMeetings) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Carregando encontros...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_meetingsError != null) {
      return ErrorStateWidget(
        message: _meetingsError!,
        onRetry: _loadMeetings,
      );
    }

    if (_meetings.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.event_busy,
                color: Theme.of(context).colorScheme.outline,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Nenhum encontro ainda',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _meetings.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final meeting = _meetings[index];
          final meetingDateTime = meeting.meetingDateTime != null
              ? DateTime.parse(meeting.meetingDateTime!)
              : null;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.event,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              meeting.name ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: meetingDateTime != null
                ? Text(
                    DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR').format(meetingDateTime),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.outline,
            ),
            onTap: () => context.push('${Routes.meeting}/${meeting.id}'),
          );
        },
      ),
    );
  }

  Widget _buildMembersSection(bool canManageMembers) {
    if (_loadingMembers) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Carregando membros...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_membersError != null) {
      return ErrorStateWidget(
        message: _membersError!,
        onRetry: _loadMembers,
      );
    }

    if (_members.isEmpty) {
      return const EmptyStateWidget(
        message: 'Nenhum membro ainda',
        subtitle: 'Adicione membros ao seu bloco',
      );
    }

    // Group members by role
    final admins = _members.where((m) => m.role == 1).toList();
    final moderators = _members.where((m) => m.role == 2).toList();
    final members = _members.where((m) => m.role != 1 && m.role != 2).toList();

    return Card(
      child: Column(
        children: [
          if (admins.isNotEmpty) ...[
            _buildMemberGroup('Admins', admins, canManageMembers, AppColors.admin),
            if (moderators.isNotEmpty || members.isNotEmpty)
              const Divider(height: 1),
          ],
          if (moderators.isNotEmpty) ...[
            _buildMemberGroup('Moderadores', moderators, canManageMembers, AppColors.info),
            if (members.isNotEmpty)
              const Divider(height: 1),
          ],
          if (members.isNotEmpty)
            _buildMemberGroup('Membros', members, canManageMembers, Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildMemberGroup(String title, List<CarnivalBlockMembersEntity> members, bool canManageMembers, Color roleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            '$title (${members.length})',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: roleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final member = members[index];
            final isDeleting = _deletingMemberId == member.id;
            final memberName = _memberNames[member.memberId] ?? 'Membro';
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: AvatarMember(
                memberId: member.memberId,
                name: memberName,
                role: _roleToString(member.role),
              ),
              title: Text(
                memberName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: isDeleting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : canManageMembers
                      ? IconButton(
                          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                          onPressed: () => _deleteMember(member),
                        )
                      : null,
            );
          },
        ),
      ],
    );
  }

  Color _getRoleColor(String? role) {
    final r = role?.toLowerCase() ?? '';
    if (r == 'admin' || r == 'gerente') {
      return AppColors.admin;
    } else if (r == 'moderador') {
      return AppColors.info;
    }
    return Theme.of(context).colorScheme.primary;
  }

  String _roleToString(int role) {
    switch (role) {
      case 1:
        return 'Admin';
      case 2:
        return 'Moderador';
      default:
        return 'Membro';
    }
  }
}
