import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_cubit.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Membros')),
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
            if (state.status == MembersStatus.loading &&
                state.members.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == MembersStatus.error && state.members.isEmpty) {
              return const Center(child: Text('Erro ao carregar membros'));
            }

            final membersList = state.members;
            if (membersList.isEmpty && state.status == MembersStatus.success) {
              return const Center(child: Text('Nenhum membro encontrado'));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<MembersCubit>().loadMembers(),
              child: ListView.builder(
                itemCount: membersList.length,
                itemBuilder: (context, index) {
                  MembersEntity member = membersList[index];
                  return Card(
                    child: ListTile(
                      title: Text(member.name.toString()),
                      subtitle: Text(member.email.toString()),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
