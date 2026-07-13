// lib/ui/members/widgets/members_screen.dart
//
// Members screen - displays paginated list of all members.
// Uses design system primitives: AppAppBar, MemberCard, AppLoading,
// AppError, AppEmpty, AppSearchField (when search is active).
//
// Behavior: pull-to-refresh, exhaustive status switch via BlocBuilder,
// error snackbar via BlocConsumer listener.

import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/ui/members/cubit/members_cubit.dart";
import "package:bloco_na_rua/ui/members/cubit/members_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MembersCubit>(
      create: (context) => context.read<MembersCubit>()..loadMembers(),
      child: const _MembersScreenContent(),
    );
  }
}

class _MembersScreenContent extends StatelessWidget {
  const _MembersScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: "Membros", showBackButton: false),
      body: SafeArea(
        child: BlocConsumer<MembersCubit, MembersState>(
          listener: (context, state) {
            if (state.status == MembersStatus.error &&
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
            switch (state.status) {
              case MembersStatus.initial:
              case MembersStatus.loading:
                if (state.members.isEmpty) {
                  return const AppLoading(message: "Carregando membros...");
                }
                return _MembersListView(members: state.members);

              case MembersStatus.error:
                if (state.members.isEmpty) {
                  return AppError(
                    message: state.errorMessage,
                    onRetry: () => context.read<MembersCubit>().loadMembers(),
                  );
                }
                return _MembersListView(members: state.members);

              case MembersStatus.success:
                if (state.members.isEmpty) {
                  return const AppEmpty(
                    title: "Nenhum membro encontrado",
                    message: "Ainda não há membros cadastrados.",
                    icon: Icons.people_outline_rounded,
                  );
                }
                return _MembersListView(members: state.members);
            }
          },
        ),
      ),
    );
  }
}

class _MembersListView extends StatelessWidget {
  const _MembersListView({required this.members});

  final List<MembersEntity> members;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<MembersCubit>().loadMembers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(Spacing.space_sm),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Padding(
            padding: EdgeInsets.only(bottom: Spacing.space_xs),
            child: MemberCard(member: member),
          );
        },
      ),
    );
  }
}
