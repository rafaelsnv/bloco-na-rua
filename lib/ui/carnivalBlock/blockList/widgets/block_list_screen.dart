import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/add_block_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/block_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

/// Screen widget for the Blocks tab.
///
/// Wraps its content in a [BlocProvider] that creates a [BlockListCubit]
/// and immediately triggers a load. The cubit is obtained from the
/// surrounding scope via [context.read].
///
/// The [Scaffold] uses [AppAppBar] for the title bar and [AppFAB] for the
/// create-block CTA. Body content is driven by [BlocConsumer] which routes
/// [BlockListStatus] to the appropriate design system widget.
class BlockListScreen extends StatelessWidget {
  const BlockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BlockListScreenContent();
  }
}

class _BlockListScreenContent extends StatefulWidget {
  const _BlockListScreenContent();

  @override
  State<_BlockListScreenContent> createState() =>
      _BlockListScreenContentState();
}

class _BlockListScreenContentState extends State<_BlockListScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<BlockListCubit>().loadBlocks();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<FabStateCubit, FabState>(
      builder: (context, fabState) {
        return BlocConsumer<BlockListCubit, BlockListState>(
          listener: (context, state) {
            if (state.status == BlockListStatus.failure &&
                state.error != null) {
              AppSnackbar.error(
                context,
                message: extractUserMessage(state.error, context),
                showCloseIcon: true,
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  appBar: AppAppBar(
                    title: l10n.blocksListTitle,
                    showBackButton: false,
                  ),
                  body: SafeArea(child: _buildBody(context, state)),
                ),
                if (fabState.expanded)
                  ModalBarrier(
                    onDismiss: () => context.read<FabStateCubit>().dismiss(),
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.space_sm),
                      child: AddBlockFab(
                        isExpanded: fabState.expanded,
                        shouldAnimate: fabState.shouldAnimate,
                        onFabPressed: () =>
                            context.read<FabStateCubit>().toggle(),
                        onExpandedChanged: (expanded) {
                          if (!expanded) {
                            context.read<FabStateCubit>().dismiss();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BlockListState state) {
    final l10n = AppLocalizations.of(context)!;
    switch (state.status) {
      case BlockListStatus.initial:
      case BlockListStatus.loading:
        if (state.blocks.isEmpty) {
          return AppLoading(message: l10n.blocksLoadingList);
        }
        return _BlockListView(blocks: state.blocks);

      case BlockListStatus.failure:
        if (state.blocks.isEmpty) {
          return AppError(
            message: extractUserMessage(state.error, context),
            onRetry: () => context.read<BlockListCubit>().loadBlocks(),
          );
        }
        return _BlockListView(blocks: state.blocks);

      case BlockListStatus.success:
        if (state.blocks.isEmpty) {
          return AppEmpty(
            title: l10n.blocksEmptyTitle,
            message: l10n.blocksEmptyMessage,
            icon: Icons.celebration_outlined,
            actionLabel: l10n.blocksCreateAction,
            onAction: () => context.push(Routes.createBlock),
          );
        }
        return _BlockListView(blocks: state.blocks);
    }
  }
}

class _BlockListView extends StatelessWidget {
  const _BlockListView({required this.blocks});

  final List<CarnivalBlocksEntity> blocks;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<BlockListCubit>().loadBlocks(),
      child: ContentWidthLimiter(
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(
            Spacing.pagePaddingFor(context),
            Spacing.space_sm,
            Spacing.pagePaddingFor(context),
            Spacing.space_2xl,
          ),
          itemCount: blocks.length,
          itemBuilder: (context, index) {
            final block = blocks[index];
            return Padding(
              padding: EdgeInsets.only(bottom: Spacing.space_xs),
              child: BlockCard(
                block: block,
                onTap: () =>
                    context.push("${Routes.carnivalBlock}/${block.id}"),
              ),
            );
          },
        ),
      ),
    );
  }
}
