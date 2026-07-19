import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/add_block_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/block_card.dart";
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
    return BlocProvider<BlockListCubit>(
      create: (context) => context.read<BlockListCubit>()..loadBlocks(),
      child: const _BlockListScreenContent(),
    );
  }
}

class _BlockListScreenContent extends StatefulWidget {
  const _BlockListScreenContent();

  @override
  State<_BlockListScreenContent> createState() => _BlockListScreenContentState();
}

class _BlockListScreenContentState extends State<_BlockListScreenContent> {
  final _fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FabStateCubit, FabState>(
      builder: (context, fabState) {
        return BlocConsumer<BlockListCubit, BlockListState>(
          listener: (context, state) {
            if (state.status == BlockListStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage!.replaceAll("Exception: ", ""),
                  ),
                  showCloseIcon: true,
                ),
              );
            }
          },
          builder: (context, state) {
            return Listener(
              onPointerDown: (event) {
                if (!fabState.expanded) return;
                final fabBox = _fabKey.currentContext?.findRenderObject() as RenderBox?;
                if (fabBox == null) return;
                final localPos = fabBox.globalToLocal(event.position);
                if (localPos.dx >= 0 &&
                    localPos.dy >= 0 &&
                    localPos.dx <= fabBox.size.width &&
                    localPos.dy <= fabBox.size.height) {
                  return; // Tap on FAB — its onPressed handles toggle
                }
                context.read<FabStateCubit>().dismiss();
              },
              child: Scaffold(
                appBar: const AppAppBar(title: "Blocos", showBackButton: false),
                body: SafeArea(
                  child: _buildBody(context, state),
                ),
                floatingActionButton: AddBlockFab(
                  key: _fabKey,
                  isExpanded: fabState.expanded,
                  shouldAnimate: fabState.shouldAnimate,
                  onFabPressed: () => context.read<FabStateCubit>().toggle(),
                  onExpandedChanged: (expanded) {
                    if (!expanded) {
                      context.read<FabStateCubit>().dismiss();
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BlockListState state) {
    switch (state.status) {
      case BlockListStatus.initial:
      case BlockListStatus.loading:
        if (state.blocks.isEmpty) {
          return const AppLoading(message: "Carregando blocos...");
        }
        return _BlockListView(blocks: state.blocks);

      case BlockListStatus.failure:
        if (state.blocks.isEmpty) {
          return AppError(
            message: state.errorMessage,
            onRetry: () => context.read<BlockListCubit>().loadBlocks(),
          );
        }
        return _BlockListView(blocks: state.blocks);

      case BlockListStatus.success:
        if (state.blocks.isEmpty) {
          return AppEmpty(
            title: "Nenhum bloco ainda",
            message: "Crie um bloco para comecar a organizar seu carnaval",
            icon: Icons.celebration_outlined,
            actionLabel: "Criar bloco",
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
      child: ListView.builder(
        padding: const EdgeInsets.all(Spacing.space_sm),
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          final block = blocks[index];
          return Padding(
            padding: EdgeInsets.only(bottom: Spacing.space_xs),
            child: BlockCard(
              block: block,
              onTap: () => context.push("${Routes.carnivalBlock}/${block.id}"),
            ),
          );
        },
      ),
    );
  }
}
