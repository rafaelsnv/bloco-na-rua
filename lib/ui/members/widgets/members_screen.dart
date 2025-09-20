import 'package:bloco_na_rua/domain/entities/members_entity.dart';
import 'package:bloco_na_rua/ui/members/view_models/members_viewmodel.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key, required this.viewModel});

  final MembersViewModel viewModel;

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  void _onResult() {
    final result = widget.viewModel.loadMembers.results.value.data;

    if (result == null) {
      return;
    }

    if (result.isError()) {
      widget.viewModel.loadMembers.clearErrors();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.exceptionOrNull().toString().replaceAll("Exception: ", ""),
            ),
            showCloseIcon: true,
          ),
        );
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadMembers.addListener(_onResult);
    widget.viewModel.loadMembers();
  }

  @override
  void didUpdateWidget(covariant MembersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadMembers.removeListener(_onResult);
    widget.viewModel.loadMembers.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadMembers.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Membros')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.loadMembers,
          builder: (context, child) {
            if (widget.viewModel.loadMembers.isExecuting.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final result = widget.viewModel.loadMembers.results.value.data;
            if (result == null || result.isError()) {
              return const Center(child: Text('Erro ao carregar membros'));
            }

            final membersList = result.getOrNull();
            if (membersList == null || membersList.isEmpty) {
              return const Center(child: Text('Nenhum membro encontrado'));
            }

            return ListView.builder(
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
            );
          },
        ),
      ),
    );
  }
}
