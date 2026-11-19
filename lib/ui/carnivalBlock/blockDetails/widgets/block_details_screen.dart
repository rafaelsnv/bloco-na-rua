import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart";
import "package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/carnivalBlock/block_error.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart";
import "package:bloco_na_rua/ui/core/theme/app_text_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_icon_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_list_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_avatar.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_icon_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/display/image_url_validator.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_loading_indicator.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class BlockDetailsScreen extends StatefulWidget {
  const BlockDetailsScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<BlockDetailsScreen> createState() => _BlockDetailsScreenState();
}

class _BlockDetailsScreenState extends State<BlockDetailsScreen>
    with RouteAware {
  List<CarnivalBlockMembersEntity> _members = [];
  List<MeetingsEntity> _meetings = [];
  Map<int, MembersEntity> _memberEntities = {};
  bool _loadingMembers = false;
  bool _loadingMeetings = false;
  BlockError? _membersError;
  BlockError? _meetingsError;
  int? _deletingMemberId;
  bool _subscribedToRoute = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadMeetings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_subscribedToRoute) {
      _subscribedToRoute = true;
      final route = ModalRoute.of(context);
      if (route != null) {
        Routes.routeObserver.subscribe(this, route);
      }
    }
  }

  @override
  void dispose() {
    Routes.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
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

    final blockId = int.tryParse(widget.carnivalBlockId);
    if (blockId == null) {
      setState(() {
        _membersError = const BlockError(BlockErrorKind.invalidId);
        _loadingMembers = false;
      });
      return;
    }

    final result = await repo.getByBlockIdAsync(blockId);

    result.fold(
      (members) async {
        // Single batch fetch: GET /Members?ids=1,2,3 (backend-supported).
        final ids = members.map((m) => m.memberId).toList();
        final entitiesResult = await membersRepo.getByIdsAsync(ids);

        final entities = <int, MembersEntity>{};
        var failedCount = 0;

        entitiesResult.fold(
          (fetched) {
            final byId = {for (final e in fetched) e.id: e};
            for (final member in members) {
              final entity = byId[member.memberId];
              if (entity != null) {
                entities[member.memberId] = entity;
              } else {
                // Member row exists but entity missing (deleted?) — placeholder.
                // The name stays null so the row can localize the fallback.
                failedCount++;
                entities[member.memberId] = MembersEntity(
                  id: member.memberId,
                  name: null,
                  email: null,
                  profileImage: null,
                );
              }
            }
          },
          (_) {
            // Batch failed entirely — placeholder for all, same as before.
            failedCount = members.length;
            for (final member in members) {
              entities[member.memberId] = MembersEntity(
                id: member.memberId,
                name: null,
                email: null,
                profileImage: null,
              );
            }
          },
        );

        if (failedCount > 0 && mounted) {
          AppSnackbar.error(
            context,
            message: AppLocalizations.of(
              context,
            )!.blocksMembersLoadFailed(failedCount),
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
          _membersError = BlockError(BlockErrorKind.request, failure);
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

    final blockId = int.tryParse(widget.carnivalBlockId);
    if (blockId == null) {
      setState(() {
        _meetingsError = const BlockError(BlockErrorKind.invalidId);
        _loadingMeetings = false;
      });
      return;
    }

    final result = await repo.getAllByBlockId(blockId);

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
          _meetingsError = BlockError(BlockErrorKind.request, failure);
          _loadingMeetings = false;
        });
      },
    );
  }

  Future<void> _deleteMember(CarnivalBlockMembersEntity member) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.blocksRemoveMemberTitle,
      message: l10n.blocksRemoveMemberConfirm,
      confirmLabel: l10n.blocksRemoveMemberAction,
      cancelLabel: l10n.blocksCancel,
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
        AppSnackbar.success(
          context,
          message: AppLocalizations.of(context)!.blocksRemoveMemberSuccess,
        );
      },
      (failure) {
        if (!mounted) return;
        setState(() {
          _deletingMemberId = null;
        });
        AppSnackbar.error(
          context,
          message: AppLocalizations.of(
            context,
          )!.blocksRemoveMemberError(extractUserMessage(failure, context)),
        );
      },
    );
  }

  Color _roleColor(int role) {
    switch (role) {
      case 1:
        return Theme.of(context).colorScheme.primary;
      case 2:
        // Semantic "info" role: deeper cyan in light mode, lighter in dark.
        return Theme.of(context).extension<AppTextColors>()!.info;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _roleLabel(int role) {
    final l10n = AppLocalizations.of(context)!;
    switch (role) {
      case 1:
        return l10n.blocksRoleAdmin;
      case 2:
        return l10n.blocksRoleModerator;
      default:
        return l10n.blocksRoleMember;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<BlockDetailsCubit, BlockDetailsState>(
      listener: (context, state) {
        if (state is BlockDetailsError) {
          AppSnackbar.error(
            context,
            message: localizeBlockError(context, state.error),
          );
        }
      },
      builder: (context, state) {
        if (state is BlockDetailsLoading || state is BlockDetailsInitial) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.blocksDetailsTitle),
            body: const AppLoading(),
          );
        }

        if (state is BlockDetailsError) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.blocksDetailsTitle),
            body: AppError(
              message: localizeBlockError(context, state.error),
              onRetry: () => context.read<BlockDetailsCubit>().loadBlock(),
            ),
          );
        }

        if (state is BlockDetailsLoaded) {
          final carnivalBlock = state.carnivalBlock;
          final canManageMembers = state.canManageMembers;

          return Scaffold(
            appBar: AppAppBar(
              title: l10n.blocksDetailsTitle,
              titleStyle: AppTypography.headlineSmall,
              actions: [
                if (canManageMembers) ...[
                  Semantics(
                    label: l10n.blocksCreateMeeting,
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.event_available_rounded),
                      tooltip: l10n.blocksCreateMeeting,
                      onPressed: () => context.push(
                        Routes.createMeetingFor(widget.carnivalBlockId),
                      ),
                    ),
                  ),
                  Semantics(
                    label: l10n.blocksEditBlock,
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      tooltip: l10n.blocksEditBlock,
                      onPressed: () => context.push(
                        Routes.editBlockFor(widget.carnivalBlockId),
                      ),
                    ),
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
                child: ContentWidthLimiter(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.pagePaddingFor(context),
                      vertical: Spacing.pagePaddingMobile,
                    ),
                    children: [
                      // Block info card
                      _BlockInfoCard(
                        carnivalBlock: carnivalBlock,
                        canManageMembers: canManageMembers,
                      ),
                      const SizedBox(height: Spacing.sectionGap),

                      // Meetings section
                      AppSectionHeader(
                        title: l10n.blocksMeetingsSection,
                        leading: Icon(
                          Icons.event_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: AppIconSizes.lg,
                        ),
                        action: canManageMembers
                            ? TextButton(
                                onPressed: () => context.push(
                                  Routes.createMeetingFor(
                                    widget.carnivalBlockId,
                                  ),
                                ),
                                child: Text(l10n.blocksCreate),
                              )
                            : null,
                      ),
                      _MeetingsSection(
                        meetings: _meetings,
                        isLoading: _loadingMeetings,
                        error: _meetingsError,
                        onRetry: _loadMeetings,
                      ),
                      const SizedBox(height: Spacing.sectionGap),

                      // Members section
                      AppSectionHeader(
                        title: l10n.blocksMembersSection,
                        leading: Icon(
                          Icons.people_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: AppIconSizes.lg,
                        ),
                        action: canManageMembers
                            ? TextButton(
                                onPressed: () => context.push(
                                  Routes.addMemberFor(widget.carnivalBlockId),
                                ),
                                child: Text(l10n.blocksAdd),
                              )
                            : null,
                      ),
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
            ),
          );
        }

        return Scaffold(
          appBar: AppAppBar(title: l10n.blocksDetailsTitle),
          body: AppEmpty(
            title: l10n.blocksNotFound,
            message: l10n.blocksNotFoundMessage,
          ),
        );
      },
    );
  }
}

class _BlockInfoCard extends StatefulWidget {
  const _BlockInfoCard({
    required this.carnivalBlock,
    required this.canManageMembers,
  });

  final CarnivalBlocksEntity carnivalBlock;
  final bool canManageMembers;

  @override
  State<_BlockInfoCard> createState() => _BlockInfoCardState();
}

class _BlockInfoCardState extends State<_BlockInfoCard> {
  bool _obscureInviteCode = true;
  bool _obscureManagerCode = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final carnivalBlock = widget.carnivalBlock;
    final canManageMembers = widget.canManageMembers;
    return AppCard(
      elevation: AppElevation.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block name row
          Row(
            children: [
              if (isValidImageUrl(carnivalBlock.carnivalBlockImage))
                CircleAvatar(
                  radius: AppIconSizes.displayLarge / 2,
                  backgroundImage: CachedNetworkImageProvider(
                    carnivalBlock.carnivalBlockImage,
                  ),
                )
              else
                AppIconTile(
                  icon: Icons.celebration_rounded,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  size: AppIconSizes.displayLarge,
                  radius: AppIconSizes.displayLarge / 2,
                  iconSize: AppIconSizes.xl,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
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

          // Invite code — managers/owner only
          if (canManageMembers) ...[
            _CodeCard(
              title: l10n.blocksInviteCodeTitle,
              code: carnivalBlock.inviteCode,
              icon: Icons.vpn_key_rounded,
              containerColor: Theme.of(context).colorScheme.secondaryContainer,
              onContainerColor: Theme.of(
                context,
              ).colorScheme.onSecondaryContainer,
              obscured: _obscureInviteCode,
              onToggleObscure: () =>
                  setState(() => _obscureInviteCode = !_obscureInviteCode),
              onCopy: () {
                Clipboard.setData(
                  ClipboardData(text: carnivalBlock.inviteCode),
                );
                AppSnackbar.success(context, message: l10n.blocksCodeCopied);
              },
            ),
            const SizedBox(height: Spacing.space_sm),
            _CodeCard(
              title: l10n.blocksManagerCodeTitle,
              code: carnivalBlock.managersInviteCode,
              icon: Icons.admin_panel_settings_rounded,
              containerColor: Theme.of(context).colorScheme.tertiaryContainer,
              onContainerColor: Theme.of(
                context,
              ).colorScheme.onTertiaryContainer,
              obscured: _obscureManagerCode,
              onToggleObscure: () =>
                  setState(() => _obscureManagerCode = !_obscureManagerCode),
              onCopy: () {
                Clipboard.setData(
                  ClipboardData(text: carnivalBlock.managersInviteCode),
                );
                AppSnackbar.success(context, message: l10n.blocksCodeCopied);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.title,
    required this.code,
    required this.icon,
    required this.containerColor,
    required this.onContainerColor,
    required this.obscured,
    required this.onToggleObscure,
    required this.onCopy,
  });

  final String title;
  final String code;
  final IconData icon;
  final Color containerColor;
  final Color onContainerColor;
  final bool obscured;
  final VoidCallback onToggleObscure;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    // The invite-code containers sit so close to the card surface in dark
    // mode (#3B1220 / #0E3540 on #1F2937) that the card needs an edge of
    // its own — `outline` gives it one. In light mode `outlineVariant` keeps
    // the edge invisible, so the cards do not get louder than before.
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? colorScheme.outline
        : colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.all(Spacing.space_sm),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: Radii.radiusSm,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: AppIconSizes.infoRow, color: onContainerColor),
              const SizedBox(width: Spacing.space_2xs),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: onContainerColor,
                  ),
                ),
              ),
              AppIconButton(
                icon: obscured
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: AppIconButtonSizeMetrics.between,
                color: onContainerColor,
                onPressed: onToggleObscure,
                tooltip: obscured
                    ? l10n.blocksShowCode(title)
                    : l10n.blocksHideCode(title),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  obscured ? "••••••••••••" : code,
                  style: AppTypography.titleLarge.copyWith(
                    color: onContainerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppIconButton(
                icon: Icons.copy_rounded,
                size: AppIconButtonSizeMetrics.between,
                color: onContainerColor,
                onPressed: onCopy,
                tooltip: l10n.blocksCopyCode(title),
              ),
            ],
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

  /// Raw failure captured from the repository, or null when the load
  /// succeeded. Converted to a user-facing message at render time.
  final BlockError? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return AppCard(
        elevation: AppElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_lg),
          child: Center(
            child: Column(
              children: [
                const AppSpinner(size: AppIconSizes.lg, strokeWidth: 2),
                const SizedBox(height: Spacing.space_sm),
                Text(
                  l10n.blocksLoadingMeetings,
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
        elevation: AppElevation.sm,
        child: AppError(
          compact: true,
          message: localizeBlockError(context, error!),
          onRetry: onRetry,
        ),
      );
    }

    if (meetings.isEmpty) {
      return AppCard(
        elevation: AppElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_md),
          child: Row(
            children: [
              Icon(
                Icons.event_busy_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: AppIconSizes.md,
              ),
              const SizedBox(width: Spacing.space_2xs),
              Text(
                l10n.blocksNoMeetingsYet,
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
      elevation: AppElevation.sm,
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
          final meetingDateTime = meeting.meetingDateTime;

          return AppListTile(
            leading: AppIconTile(
              icon: Icons.event_rounded,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              size: AppIconSizes.listTile,
              radius: Radii.sm,
              iconSize: AppIconSizes.md,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            title: meeting.name ?? l10n.blocksNoTitle,
            subtitle: meetingDateTime != null
                ? formatShortDateTime(meetingDateTime, context)
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

  /// Raw failure captured from the repository, or null when the load
  /// succeeded. Converted to a user-facing message at render time.
  final BlockError? error;
  final bool canManageMembers;
  final int? deletingMemberId;
  final VoidCallback onRetry;
  final void Function(CarnivalBlockMembersEntity) onDeleteMember;
  final Color Function(int) roleColor;
  final String Function(int) roleLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return AppCard(
        elevation: AppElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_lg),
          child: Center(
            child: Column(
              children: [
                const AppSpinner(size: AppIconSizes.lg, strokeWidth: 2),
                const SizedBox(height: Spacing.space_sm),
                Text(
                  l10n.blocksLoadingMembers,
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
        elevation: AppElevation.sm,
        child: AppError(
          compact: true,
          message: localizeBlockError(context, error!),
          onRetry: onRetry,
        ),
      );
    }

    if (members.isEmpty) {
      return AppCard(
        elevation: AppElevation.sm,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.space_md),
          child: Row(
            children: [
              Icon(
                Icons.people_outline_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: AppIconSizes.md,
              ),
              const SizedBox(width: Spacing.space_2xs),
              Expanded(
                child: Text(
                  l10n.blocksNoMembersYet,
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

    // Build flat list: group headers + member rows
    final List<Widget> items = [];

    if (admins.isNotEmpty) {
      items.add(
        _MemberGroupHeader(
          title: l10n.blocksAdminsGroup,
          count: admins.length,
          color: roleColor(1),
        ),
      );
      for (final member in admins) {
        items.add(
          _MemberRow(
            member: member,
            entity: memberEntities[member.memberId],
            isDeleting: deletingMemberId == member.id,
            canManageMembers: canManageMembers,
            onDelete: () => onDeleteMember(member),
          ),
        );
      }
      if (moderators.isNotEmpty || regularMembers.isNotEmpty) {
        items.add(
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        );
      }
    }

    if (moderators.isNotEmpty) {
      items.add(
        _MemberGroupHeader(
          title: l10n.blocksModeratorsGroup,
          count: moderators.length,
          color: roleColor(2),
        ),
      );
      for (final member in moderators) {
        items.add(
          _MemberRow(
            member: member,
            entity: memberEntities[member.memberId],
            isDeleting: deletingMemberId == member.id,
            canManageMembers: canManageMembers,
            onDelete: () => onDeleteMember(member),
          ),
        );
      }
      if (regularMembers.isNotEmpty) {
        items.add(
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        );
      }
    }

    if (regularMembers.isNotEmpty) {
      items.add(
        _MemberGroupHeader(
          title: l10n.blocksMembersSection,
          count: regularMembers.length,
          color: roleColor(0),
        ),
      );
      for (final member in regularMembers) {
        items.add(
          _MemberRow(
            member: member,
            entity: memberEntities[member.memberId],
            isDeleting: deletingMemberId == member.id,
            canManageMembers: canManageMembers,
            onDelete: () => onDeleteMember(member),
          ),
        );
      }
    }

    return AppCard(
      elevation: AppElevation.sm,
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox.shrink(),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}

class _MemberGroupHeader extends StatelessWidget {
  const _MemberGroupHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.space_sm,
        vertical: Spacing.space_xs,
      ),
      child: Text(
        l10n.blocksGroupCount(title, count),
        style: AppTypography.titleSmall.copyWith(color: color),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.entity,
    required this.isDeleting,
    required this.canManageMembers,
    required this.onDelete,
  });

  final CarnivalBlockMembersEntity member;
  final MembersEntity? entity;
  final bool isDeleting;
  final bool canManageMembers;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = entity?.name ?? l10n.blocksMemberFallback;
    final email = entity?.email;
    final profileImage = entity?.profileImage;
    final updatedAt = entity?.updatedAt;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.space_sm,
        vertical: Spacing.space_xs,
      ),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: profileImage,
            name: name,
            size: AvatarSize.md,
            imageCacheVersion: updatedAt,
          ),
          const SizedBox(width: Spacing.space_sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email != null) ...[
                  const SizedBox(height: Spacing.space_4xs),
                  Text(
                    email,
                    style: AppTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (isDeleting) ...[
            const AppSpinner(size: AppIconSizes.lg, strokeWidth: 2),
          ] else if (canManageMembers) ...[
            AppIconButton(
              icon: Icons.delete_rounded,
              color: Theme.of(context).colorScheme.error,
              size: AppIconButtonSizeMetrics.sm,
              onPressed: onDelete,
              tooltip: l10n.blocksRemoveMemberTooltip(name),
            ),
          ],
        ],
      ),
    );
  }
}
