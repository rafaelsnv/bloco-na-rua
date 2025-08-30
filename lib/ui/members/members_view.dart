import 'package:bloco_na_rua/ui/members/view_models/members_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  @override
  void initState() {
    super.initState();
    context.read<MembersViewModel>().onInit();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MembersViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.members.length,
              itemBuilder: (context, index) {
                final member = viewModel.members[index];
                return ListTile(
                  title: Text(member.name ?? 'No Name'),
                  subtitle: Text(member.id.toString()),
                );
              },
            ),
    );
  }
}
