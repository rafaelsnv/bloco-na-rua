import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockDetailsScreen extends StatelessWidget {
  const BlockDetailsScreen({
    super.key,
    required this.carnivalBlockId,
  });

  final String carnivalBlockId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blocos")),
      body: SafeArea(
        child: BlocConsumer<BlockDetailsCubit, BlockDetailsState>(
          listener: (context, state) {
            if (state is BlockDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is BlockDetailsLoading || state is BlockDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlockDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is BlockDetailsLoaded) {
              final carnivalBlock = state.carnivalBlock;
              return Center(
                child: Text(
                  carnivalBlock.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }

            return const Center(child: Text('Nenhum bloco encontrado'));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purpleAccent.shade100,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
