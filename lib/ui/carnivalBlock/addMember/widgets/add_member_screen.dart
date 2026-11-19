import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_icon_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_search_field.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AddMemberCubit>().loadMembers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AddMemberCubit, AddMemberState>(
      listener: (context, state) {
        if (state.status == AddMemberStatus.error && state.error != null) {
          AppSnackbar.error(
            context,
            message: extractUserMessage(state.error, context),
          );
        } else if (state.status == AddMemberStatus.success) {
          AppSnackbar.success(context, message: l10n.blocksMemberAddedSuccess);
          if (context.mounted) {
            context.pop();
          }
        }
      },
      builder: (context, state) {
        final pagePadding = Spacing.pagePaddingFor(context);

        return Scaffold(
          appBar: AppAppBar(
            title: l10n.blocksAddMemberTitle,
            showBackButton: true,
          ),
          body: ContentWidthLimiter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: pagePadding,
                    vertical: Spacing.space_sm,
                  ),
                  child: AppSearchField(
                    controller: _searchController,
                    hint: l10n.blocksMemberSearchHint,
                    autofocus: true,
                    onChanged: (value) {
                      context.read<AddMemberCubit>().searchMembers(value);
                    },
                  ),
                ),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AddMemberState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.status == AddMemberStatus.loading) {
      return const AppLoading();
    }

    if (state.status == AddMemberStatus.error &&
        state.error != null &&
        state.allMembers.isEmpty) {
      return AppError(
        message: extractUserMessage(state.error, context),
        onRetry: () => context.read<AddMemberCubit>().loadMembers(),
      );
    }

    if (state.filteredMembers.isEmpty) {
      if (state.searchQuery.isNotEmpty) {
        return AppEmpty(
          title: l10n.blocksMemberNotFoundTitle,
          message: l10n.blocksMemberNotFoundMessage,
          icon: Icons.search_off_rounded,
        );
      }
      return AppEmpty(
        title: l10n.blocksNoMemberTitle,
        message: l10n.blocksNoMemberMessage,
        icon: Icons.people_outline_rounded,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingFor(context),
      ),
      itemCount: state.filteredMembers.length,
      itemBuilder: (context, index) {
        final member = state.filteredMembers[index];

        return Padding(
          padding: EdgeInsets.only(bottom: Spacing.space_xs),
          child: MemberCard(
            member: member,
            showEmail: true,
            onTap: () {
              final blockId = int.tryParse(widget.carnivalBlockId);
              if (blockId != null) {
                context.read<AddMemberCubit>().addMember(member.id, blockId);
              }
            },
            trailing: AppIconButton(
              icon: Icons.person_add_rounded,
              onPressed: () {
                final blockId = int.tryParse(widget.carnivalBlockId);
                if (blockId != null) {
                  context.read<AddMemberCubit>().addMember(member.id, blockId);
                }
              },
              tooltip: l10n.blocksAddMemberTooltip(
                member.name ?? l10n.blocksMemberFallback,
              ),
            ),
          ),
        );
      },
    );
  }
}
