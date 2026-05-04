import 'package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state.status == AddMemberStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membro adicionado com sucesso')),
          );
          if (context.mounted) {
            context.pop();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Adicionar Membro',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.grey[850],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          backgroundColor: Colors.grey[900],
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome ou email',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    context.read<AddMemberCubit>().searchMembers(value);
                  },
                ),
              ),
              if (state.status == AddMemberStatus.loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.filteredMembers.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Nenhum membro encontrado',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = state.filteredMembers[index];
                      return ListTile(
                        title: Text(
                          member.name ?? 'Sem nome',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          member.email ?? 'Sem email',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        onTap: () {
                          context.read<AddMemberCubit>().addMember(
                            member.id,
                            int.parse(widget.carnivalBlockId),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
