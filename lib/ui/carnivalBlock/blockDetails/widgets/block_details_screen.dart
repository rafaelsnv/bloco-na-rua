// lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart
//
// Block details screen — rewritten to the Bloco na Rua design system.
//
// Pattern: DETAIL with ownership + members list + actions.
// Uses design system primitives: AppAppBar, AppCard, AppSectionHeader,
// AppListTile, AppButton, AppFAB, MemberCard, AppDialog, AppSnackbar,
// AppLoading, AppError, AppEmpty.
//
// State: BlockDetailsInitial / BlockDetailsLoading / BlockDetailsLoaded /
// BlockDetailsError (sealed class, switch/is pattern).
//
// Navigation after action:
//   - Delete member -> AppDialog.confirm(isDestructive: true) -> AppSnackbar
//   - FAB "Nova Reuniao" -> /create-meeting/:blockId
//   - Edit Block button -> /edit-block/:blockId

import "package:cached_network_image/cached_network_image.dart";
import "package:bloco_na_rua/core/cache/app_cache_manager.dart";
import "package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart";
import "package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_list_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_avatar.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_chip.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/display/image_url_validator.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class BlockDetailsScreen extends StatefulWidget {
  const BlockDetailsScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<BlockDetailsScreen> createState() => _BlockDetailsScreenState();
}

class _BlockDetailsScreenState extends State<BlockDetailsScreen> {
  List<CarnivalBlockMembersEntity> _members = [];
  List<MeetingsEntity> _meetings = [];
  Map<int, MembersEntity> _memberEntities = {};
  bool _loadingMembers = false;
  bool _loadingMeetings = false;
  String? _membersError;
  String? _meetingsError;
  int? _deletingMemberId;

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
        // Fetch all member entities concurrently with Future.wait
        final entities = <int, MembersEntity>{};
        final memberFutures = members.map(
          (member) => membersRepo.getByIdAsync(member.memberId),
        );
        final memberResults = await Future.wait(memberFutures);

        for (var i = 0; i < members.length; i++) {
          final member = members[i];
          final memberResult = memberResults[i];
          memberResult.fold(
            (m) => entities[member.memberId] = m,
            (_) => entities[member.memberId] = MembersEntity(
              id: member.memberId,
              name: "Membro",
              email: null,
              profileImage: null,
            ),
          );
        }

        if (!mounted) return;
        setState(() {
          _members = members;
          _memberEntities = entities;
          _loadingMembers = false;
        });
      },
      (failure) {
        if (!mounted) return;
        setState(() {
          _membersError = failure.toString();
          _loadingMembers = false;
        });
      },
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
      (meetings) {
        if (!mounted) return;
        setState(() {
          _meetings = meetings;
          _loadingMeetings = false;
        });
      },
      (failure) {
        if (!mounted) return;
        setState(() {
          _meetingsError = failure.toString();
          _loadingMeetings = false;
        });
      },
    );
  }

  Future<void> _deleteMember(CarnivalBlockMembersEntity member) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: "Remover membro",
      message: "Remover este membro do bloco?",
      confirmLabel: "Remover",
      cancelLabel: "Cancelar",
      isDestructive: true,
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
        AppSnackbar.success(context, message: "Membro removido com sucesso");
      },
      (failure) {
        if (!mounted) return;
        setState(() {
          _deletingMemberId = null;
        });
        AppSnackbar.error(context, message: "Erro ao remover membro: $failure");
      },
    );
  }

  Color _roleColor(int role) {
    switch (role) {
      case 1:
        return AppColors.primary;
      case 2:
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  String _roleLabel(int role) {
    switch (role) {
      case 1:
        return "Admin";
      case 2:
        return "Moderador";
      default:
        return "Membro";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlockDetailsCubit, BlockDetailsState>(
      listener: (context, state) {
        if (state is BlockDetailsError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is BlockDetailsLoading || state is BlockDetailsInitial) {
          return Scaffold(
            appBar: const AppAppBar(title: "Detalhes do Bloco"),
            body: const AppLoading(),
          );
        }

        if (state is BlockDetailsError) {
          return Scaffold(
            appBar: const AppAppBar(title: "Detalhes do Bloco"),
            body: AppError(
              message: state.message,
              onRetry: () => context.read<BlockDetailsCubit>().loadBlock(),
            ),
          );
        }

        if (state is BlockDetailsLoaded) {
          final carnivalBlock = state.carnivalBlock;
          final canManageMembers = state.canManageMembers;

          return Scaffold(
            appBar: AppAppBar(
              title: "Detalhes do Bloco",
              actions: [
                if (canManageMembers) ...[
                  IconButton(
                    icon: const Icon(Icons.add_alert_rounded),
                    tooltip: "Criar Reuniao",
                    onPressed: () => context.push(
                      "/create-meeting/${widget.carnivalBlockId}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: "Editar Bloco",
                    onPressed: () =>
                        context.push("/edit-block/${widget.carnivalBlockId}"),
                  ),
                ],
              ],
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadMembers();
                  await _loadMeetings();
                },
                child: ListView(
                  padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
                  children: [
                    // Block info card
                    _BlockInfoCard(
                      carnivalBlock: carnivalBlock,
                      canManageMembers: canManageMembers,
                    ),
                    const SizedBox(height: Spacing.sectionGap),

                    // Meetings section
                    AppSectionHeader(
                      title: "Encontros",
                      leading: Icon(
                        Icons.event_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      action: canManageMembers
                          ? AppButton(
                              label: "Criar",
                              variant: AppButtonVariant.ghost,
                              size: AppButtonSize.sm,
                              onPressed: () => context.push(
                                "/create-meeting/${widget.carnivalBlockId}",
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: Spacing.space_xs),
                    _MeetingsSection(
                      meetings: _meetings,
                      isLoading: _loadingMeetings,
                      error: _meetingsError,
                      onRetry: _loadMeetings,
                    ),
                    const SizedBox(height: Spacing.sectionGap),

                    // Members section
                    AppSectionHeader(
                      title: "Membros",
                      leading: Icon(
                        Icons.people_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      action: canManageMembers
                          ? AppButton(
                              label: "Adicionar",
                              variant: AppButtonVariant.ghost,
                              size: AppButtonSize.sm,
                              onPressed: () => context.push(
                                "/add-member/${widget.carnivalBlockId}",
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: Spacing.space_xs),
                    _MembersSection(
                      members: _members,
                      memberEntities: _memberEntities,
                      isLoading: _loadingMembers,
                      error: _membersError,
                      canManageMembers: canManageMembers,
                      deletingMemberId: _deletingMemberId,
                      onRetry: _loadMembers,
                      onDeleteMember: _deleteMember,
                      roleColor: _roleColor,
                      roleLabel: _roleLabel,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: canManageMembers
                ? AppFAB(
                    icon: Icons.event_rounded,
                    label: "Nova Reuniao",
                    onPressed: () => context.push(
                      "/create-meeting/${widget.carnivalBlockId}",
                    ),
                  )
                : null,
          );
        }

        return Scaffold(
          appBar: const AppAppBar(title: "Detalhes do Bloco"),
          body: const AppEmpty(
            title: "Bloco nao encontrado",
            message: "Este bloco nao esta disponivel.",
          ),
        );
      },
    );
  }
}

class _BlockInfoCard extends StatelessWidget {
  const _BlockInfoCard({
    required this.carnivalBlock,
    required this.canManageMembers,
  });

  final CarnivalBlocksEntity carnivalBlock;
  final bool canManageMembers;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: AppCardElevation.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block name row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.space_sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: Spacing.space_sm),
              Expanded(
                child: Text(
                  carnivalBlock.name,
                  style: AppTypography.headlineSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.space_md),

          // Cover image — guard with isValidImageUrl() so backend placeholders
          // (e.g. "img") don't crash CachedNetworkImageProvider.
          if (isValidImageUrl(carnivalBlock.carnivalBlockImage)) ...[
            ClipRRect(
              borderRadius: Radii.radiusMd,
              child: CachedNetworkImage(
                imageUrl: carnivalBlock.carnivalBlockImage,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheManager: AppCacheManager.instance,
                placeholder: (context, url) => Container(
                  height: 160,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 160,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.celebration_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.space_md),
          ],

          // Invite codes (only for managers)
          if (canManageMembers) ...[
            _InviteCodeRow(
              label: "Codigo de convite",
              code: carnivalBlock.inviteCode,
            ),
            const SizedBox(height: Spacing.space_2xs),
            _InviteCodeRow(
              label: "Codigo gerente",
              code: carnivalBlock.managersInviteCode,
            ),
          ],
        ],
      ),
    );
  }
}

class _InviteCodeRow extends StatelessWidget {
  const _InviteCodeRow({required this.label, required this.code});

  final String label;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.space_sm,
        vertical: Spacing.space_xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: Radii.radiusSm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.qr_code_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: Spacing.space_2xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          // Flexible allows the long invite/manager code
          // (e.g. "managers_invite_fulano_block") to ellipsize when the
          // available width is too tight. The copy icon still works since
          // it triggers the same code copy action.
          Flexible(
            child: Text(
              code,
              style: AppTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: Spacing.space_2xs),
          GestureDetector(
            onTap: () {
              AppSnackbar.info(context, message: "Codigo copiado");
            },
            child: Icon(
              Icons.copy_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingsSection extends StatelessWidget {
  const _MeetingsSection({
    required this.meetings,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  final List<MeetingsEntity> meetings;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppCard(
        elevation: AppCardElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_lg),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(strokeWidth: 2),
                const SizedBox(height: Spacing.space_sm),
                Text(
                  "Carregando encontros...",
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (error != null) {
      return AppCard(
        elevation: AppCardElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_lg),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: AppColors.error,
                ),
                const SizedBox(height: Spacing.space_sm),
                Text(
                  error!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_sm),
                AppButton(
                  label: "Tentar novamente",
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.sm,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (meetings.isEmpty) {
      return AppCard(
        elevation: AppCardElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_md),
          child: Row(
            children: [
              Icon(
                Icons.event_busy_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: 20,
              ),
              const SizedBox(width: Spacing.space_2xs),
              Text(
                "Nenhum encontro ainda",
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppCard(
      elevation: AppCardElevation.sm,
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: meetings.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          final meetingDateTime = meeting.meetingDateTime != null
              ? DateTime.parse(meeting.meetingDateTime!)
              : null;

          return AppListTile(
            leading: Container(
              padding: const EdgeInsets.all(Spacing.space_2xs),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: Radii.radiusSm,
              ),
              child: Icon(
                Icons.event_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            title: meeting.name ?? "Sem titulo",
            subtitle: meetingDateTime != null
                ? DateFormat(
                    "dd/MM/yyyy - HH:mm",
                    "pt_BR",
                  ).format(meetingDateTime)
                : null,
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.outline,
            ),
            onTap: () => context.push("${Routes.meeting}/${meeting.id}"),
          );
        },
      ),
    );
  }
}

class _MembersSection extends StatelessWidget {
  const _MembersSection({
    required this.members,
    required this.memberEntities,
    required this.isLoading,
    required this.error,
    required this.canManageMembers,
    required this.deletingMemberId,
    required this.onRetry,
    required this.onDeleteMember,
    required this.roleColor,
    required this.roleLabel,
  });

  final List<CarnivalBlockMembersEntity> members;
  final Map<int, MembersEntity> memberEntities;
  final bool isLoading;
  final String? error;
  final bool canManageMembers;
  final int? deletingMemberId;
  final VoidCallback onRetry;
  final void Function(CarnivalBlockMembersEntity) onDeleteMember;
  final Color Function(int) roleColor;
  final String Function(int) roleLabel;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppCard(
        elevation: AppCardElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_lg),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(strokeWidth: 2),
                const SizedBox(height: Spacing.space_sm),
                Text(
                  "Carregando membros...",
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (error != null) {
      return AppCard(
        elevation: AppCardElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_lg),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: AppColors.error,
                ),
                const SizedBox(height: Spacing.space_sm),
                Text(
                  error!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_sm),
                AppButton(
                  label: "Tentar novamente",
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.sm,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (members.isEmpty) {
      return AppCard(
        elevation: AppCardElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_md),
          child: Row(
            children: [
              Icon(
                Icons.people_outline_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: 20,
              ),
              const SizedBox(width: Spacing.space_2xs),
              Expanded(
                child: Text(
                  "Nenhum membro ainda",
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group members by role
    final admins = members.where((m) => m.role == 1).toList();
    final moderators = members.where((m) => m.role == 2).toList();
    final regularMembers = members
        .where((m) => m.role != 1 && m.role != 2)
        .toList();

    return AppCard(
      elevation: AppCardElevation.sm,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          if (admins.isNotEmpty) ...[
            _MemberGroup(
              title: "Admins",
              members: admins,
              memberEntities: memberEntities,
              canManageMembers: canManageMembers,
              deletingMemberId: deletingMemberId,
              onDeleteMember: onDeleteMember,
              roleColor: roleColor,
              roleLabel: roleLabel,
            ),
            if (moderators.isNotEmpty || regularMembers.isNotEmpty)
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
          ],
          if (moderators.isNotEmpty) ...[
            _MemberGroup(
              title: "Moderadores",
              members: moderators,
              memberEntities: memberEntities,
              canManageMembers: canManageMembers,
              deletingMemberId: deletingMemberId,
              onDeleteMember: onDeleteMember,
              roleColor: roleColor,
              roleLabel: roleLabel,
            ),
            if (regularMembers.isNotEmpty)
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
          ],
          if (regularMembers.isNotEmpty)
            _MemberGroup(
              title: "Membros",
              members: regularMembers,
              memberEntities: memberEntities,
              canManageMembers: canManageMembers,
              deletingMemberId: deletingMemberId,
              onDeleteMember: onDeleteMember,
              roleColor: roleColor,
              roleLabel: roleLabel,
            ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.roleLabel,
    required this.roleColor,
    required this.isDeleting,
    required this.canManageMembers,
    required this.onDelete,
  });

  final MembersEntity member;
  final String roleLabel;
  final Color roleColor;
  final bool isDeleting;
  final bool canManageMembers;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.space_sm,
        vertical: Spacing.space_2xs,
      ),
      child: AppCard(
        elevation: AppCardElevation.sm,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppAvatar(
              imageUrl: member.profileImage,
              name: member.name,
              size: AvatarSize.md,
              imageCacheVersion: member.updatedAt,
            ),
            const SizedBox(width: Spacing.space_md),
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
                  if (member.email != null) ...[
                    const SizedBox(height: Spacing.space_4xs),
                    Text(
                      member.email!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Spacing.space_sm),
            AppChip(
              label: roleLabel,
              variant: ChipVariant.filled,
              color: roleColor,
            ),
            if (isDeleting) ...[
              const SizedBox(width: Spacing.space_2xs),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ] else if (canManageMembers) ...[
              const SizedBox(width: Spacing.space_2xs),
              IconButton(
                icon: Icon(
                  Icons.delete_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MemberGroup extends StatelessWidget {
  const _MemberGroup({
    required this.title,
    required this.members,
    required this.memberEntities,
    required this.canManageMembers,
    required this.deletingMemberId,
    required this.onDeleteMember,
    required this.roleColor,
    required this.roleLabel,
  });

  final String title;
  final List<CarnivalBlockMembersEntity> members;
  final Map<int, MembersEntity> memberEntities;
  final bool canManageMembers;
  final int? deletingMemberId;
  final void Function(CarnivalBlockMembersEntity) onDeleteMember;
  final Color Function(int) roleColor;
  final String Function(int) roleLabel;

  @override
  Widget build(BuildContext context) {
    final groupRoleColor = roleColor(members.first.role);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_sm,
            vertical: Spacing.space_xs,
          ),
          child: Text(
            "$title (${members.length})",
            style: AppTypography.titleSmall.copyWith(color: groupRoleColor),
          ),
        ),
        ...members.map((member) {
          final isDeleting = deletingMemberId == member.id;
          final entity = memberEntities[member.memberId];

          if (entity != null) {
            return _MemberTile(
              member: entity,
              roleLabel: roleLabel(member.role),
              roleColor: roleColor(member.role),
              isDeleting: isDeleting,
              canManageMembers: canManageMembers,
              onDelete: () => onDeleteMember(member),
            );
          }

          // Fallback: display minimal member info
          return AppListTile(
            leading: AppAvatar(name: "Membro", size: AvatarSize.md),
            title: "Membro",
            trailing: isDeleting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : canManageMembers
                ? IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    onPressed: () => onDeleteMember(member),
                  )
                : null,
          );
        }),
      ],
    );
  }
}
