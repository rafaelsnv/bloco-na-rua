import "package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_icon_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_search_field.dart";
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
    return BlocConsumer<AddMemberCubit, AddMemberState>(
      listener: (context, state) {
        if (state.status == AddMemberStatus.error &&
            state.errorMessage != null) {
          AppSnackbar.error(context, message: state.errorMessage!);
        } else if (state.status == AddMemberStatus.success) {
          AppSnackbar.success(
            context,
            message: "Membro adicionado com sucesso",
          );
          if (context.mounted) {
            context.pop();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppAppBar(
            title: "Adicionar membro",
            showBackButton: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Spacing.space_sm),
                child: AppSearchField(
                  controller: _searchController,
                  hint: "Buscar por nome ou email",
                  autofocus: true,
                  onChanged: (value) {
                    context.read<AddMemberCubit>().searchMembers(value);
                  },
                ),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AddMemberState state) {
    if (state.status == AddMemberStatus.loading) {
      return const AppLoading();
    }

    if (state.status == AddMemberStatus.error &&
        state.errorMessage != null &&
        state.allMembers.isEmpty) {
      return AppError(
        message: state.errorMessage,
        onRetry: () => context.read<AddMemberCubit>().loadMembers(),
      );
    }

    if (state.filteredMembers.isEmpty) {
      if (state.searchQuery.isNotEmpty) {
        return const AppEmpty(
          title: "Nenhum membro encontrado",
          message: "Tente buscar por outro nome ou email.",
          icon: Icons.search_off_rounded,
        );
      }
      return const AppEmpty(
        title: "Nenhum membro disponível",
        message: "Não há membros para adicionar a este bloco.",
        icon: Icons.people_outline_rounded,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: Spacing.space_sm),
      itemCount: state.filteredMembers.length,
      itemBuilder: (context, index) {
        final member = state.filteredMembers[index];

        return Padding(
          padding: EdgeInsets.only(bottom: Spacing.space_xs),
          child: Row(
            children: [
              Expanded(
                child: MemberCard(
                  member: member,
                  showEmail: true,
                  onTap: () {
                    context.read<AddMemberCubit>().addMember(
                      member.id,
                      int.parse(widget.carnivalBlockId),
                    );
                  },
                ),
              ),
              SizedBox(width: Spacing.space_2xs),
              AppIconButton(
                icon: Icons.person_add_rounded,
                onPressed: () {
                  context.read<AddMemberCubit>().addMember(
                    member.id,
                    int.parse(widget.carnivalBlockId),
                  );
                },
                tooltip: "Adicionar membro",
              ),
            ],
          ),
        );
      },
    );
  }
}
