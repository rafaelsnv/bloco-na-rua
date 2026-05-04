import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart';
import 'package:bloco_na_rua/ui/core/widgets/avatar_member.dart';
import 'package:bloco_na_rua/ui/core/widgets/copy_code_card.dart';
import 'package:bloco_na_rua/ui/core/widgets/empty_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/error_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlockDetailsScreen extends StatefulWidget {
  const BlockDetailsScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<BlockDetailsScreen> createState() => _BlockDetailsScreenState();
}

class _BlockDetailsScreenState extends State<BlockDetailsScreen> {
  List<CarnivalBlockMembersEntity> _members = [];
  bool _loadingMembers = false;
  String? _membersError;
  int? _deletingMemberId;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final repo = context.read<ICarnivalBlockMembersRepository>();
    setState(() {
      _loadingMembers = true;
      _membersError = null;
    });

    final result = await repo.getByBlockIdAsync(
      int.parse(widget.carnivalBlockId),
    );

    result.fold(
      (members) => setState(() {
        _members = members;
        _loadingMembers = false;
      }),
      (failure) => setState(() {
        _membersError = failure.toString();
        _loadingMembers = false;
      }),
    );
  }

  Future<void> _deleteMember(CarnivalBlockMembersEntity member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.person_remove, color: Colors.red),
            SizedBox(width: 8),
            Text('Remover membro'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade700,
            ),
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
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Membro removido com sucesso'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
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
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Erro ao remover membro: $failure')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Bloco"),
        backgroundColor: Colors.grey.shade900,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_alert,
                color: Colors.purpleAccent.shade700,
              ),
            ),
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
      ),
      body: SafeArea(
        child: BlocConsumer<BlockDetailsCubit, BlockDetailsState>(
          listener: (context, state) {
            if (state is BlockDetailsError) {
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
                onRefresh: _loadMembers,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Block info card
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
                            // Block name
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.purpleAccent.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.celebration,
                                    color: Colors.purpleAccent.shade700,
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
                            // Block image
                            if (carnivalBlock.carnivalBlockImage.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  carnivalBlock.carnivalBlockImage,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            // Invite codes
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Members section
                    SectionHeader(
                      title: 'Membros',
                      action: state.canManageMembers ? 'Adicionar' : null,
                      onAction: state.canManageMembers
                          ? () => context.push('/add-member/${widget.carnivalBlockId}')
                          : null,
                    ),
                    _buildMembersSection(state.canManageMembers),
                  ],
                ),
              );
            }

            return const EmptyStateWidget(
              icon: Icons.block,
              message: 'Bloco não encontrado',
            );
          },
        ),
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
                  style: TextStyle(color: Colors.grey.shade600),
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
        icon: Icons.people_outline,
        message: 'Nenhum membro ainda',
        subtitle: 'Adicione membros ao seu bloco',
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _members.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),
        itemBuilder: (context, index) {
          final member = _members[index];
          final isDeleting = _deletingMemberId == member.id;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: AvatarMember(
              memberId: member.memberId,
              role: _roleToString(member.role),
            ),
            title: Text(
              'Membro #${member.memberId}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(_roleToString(member.role)).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _roleToString(member.role),
                style: TextStyle(
                  color: _getRoleColor(_roleToString(member.role)),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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
                        icon: Icon(Icons.delete, color: Colors.red.shade400),
                        onPressed: () => _deleteMember(member),
                      )
                    : null,
          );
        },
      ),
    );
  }

  Color _getRoleColor(String? role) {
    final r = role?.toLowerCase() ?? '';
    if (r == 'admin' || r == 'gerente') {
      return Colors.amber.shade700;
    } else if (r == 'moderador') {
      return Colors.blue;
    }
    return Colors.purple;
  }

  String _roleToString(int role) {
    // Role is stored as int: 1 = admin, 2 = moderator, 3 = member, etc.
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
