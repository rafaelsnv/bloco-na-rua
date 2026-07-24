import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/add_block_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/block_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/meeting_card.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FabStateCubit, FabState>(
      builder: (context, fabState) {
        return BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              current.status == HomeStatus.failure &&
              previous.status != HomeStatus.failure,
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                      const SizedBox(width: Spacing.space_2xs),
                      Expanded(child: Text(state.errorMessage!)),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Listener(
            onPointerDown: (event) {
              if (!fabState.expanded) return;
              // Dismiss only if tap is outside the FAB bounds
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
              appBar: AppAppBar(
                title: "Bloco na Rua",
                centerTitle: false,
                showBackButton: false,
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeCubit>().loadHomeData();
                  },
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case HomeStatus.initial:
                        case HomeStatus.loading:
                          return const AppLoading(message: "Carregando...");

                        case HomeStatus.failure:
                          return AppError(
                            message: state.errorMessage,
                            onRetry: () =>
                                context.read<HomeCubit>().loadHomeData(),
                          );

                        case HomeStatus.success:
                          return _buildContent(context, state);
                      }
                    },
                  ),
                ),
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    final blocks = state.blocks;
    final meetings = state.meetings.take(3).toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: Spacing.space_3xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero greeting section
          Padding(
            padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ola!",
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: Spacing.space_4xs),
                Text(
                  "Veja seus blocos e reuniões",
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Meus blocos section
          AppSectionHeader(
            title: "Meus blocos",
            action: TextButton(
              onPressed: () {
                final shell = StatefulNavigationShell.of(context);
                shell.goBranch(1, initialLocation: true);
              },
              child: Text(
                "Ver todos",
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // Blocks horizontal list
          if (blocks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.pagePaddingMobile,
              ),
              child: AppEmpty(
                icon: Icons.celebration,
                message: "Nenhum bloco ainda",
                actionLabel: "Criar bloco",
                onAction: () => context.push(Routes.createBlock),
              ),
            )
          else
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.pagePaddingMobile,
                ),
                itemCount: blocks.length,
                separatorBuilder: (context, index) =>
                    Container(width: Spacing.space_2xs),
                itemBuilder: (context, i) {
                  final block = blocks[i];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.775,
                    child: BlockCard(
                      block: block,
                      onTap: () =>
                          context.push("${Routes.carnivalBlock}/${block.id}"),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: Spacing.space_md),

          // Próximas reuniões section
          AppSectionHeader(
            title: "Próximas reuniões",
            action: TextButton(
              onPressed: () {
                final shell = StatefulNavigationShell.of(context);
                shell.goBranch(2, initialLocation: true);
              },
              child: Text(
                "Ver todos",
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // Meetings list
          if (meetings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.pagePaddingMobile,
              ),
              child: AppEmpty(message: "Nenhuma reuniao esta semana"),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.pagePaddingMobile,
              ),
              child: Column(
                children: meetings.map((meeting) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.space_sm),
                    child: MeetingCard(
                      meeting: meeting,
                      totalPresences: null,
                      confirmedPresences: null,
                      showDescription: false,
                      onTap: () =>
                          context.push("${Routes.meeting}/${meeting.id}"),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
