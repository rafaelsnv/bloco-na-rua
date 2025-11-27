import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/view_model/block_details_viewmodel.dart';
import 'package:flutter/material.dart';

class BlockDetailsScreen extends StatefulWidget {
  const BlockDetailsScreen({
    super.key,
    required this.viewModel,
    required this.carnivalBlockId,
  });

  final BlockDetailsViewModel viewModel;
  final String carnivalBlockId;

  @override
  State<BlockDetailsScreen> createState() => _BlockDetailsScreenState();
}

class _BlockDetailsScreenState extends State<BlockDetailsScreen> {
  void _onResult() {
    final result = widget.viewModel.loadCarnivalBlocks.results.value.data;

    if (result == null) {
      return;
    }

    if (result.isError()) {
      final error = result.exceptionOrNull().toString().replaceAll(
        "Exception: ",
        "",
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      widget.viewModel.loadCarnivalBlocks.clearErrors();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadCarnivalBlocks.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant BlockDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadCarnivalBlocks.removeListener(_onResult);
    widget.viewModel.loadCarnivalBlocks.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadCarnivalBlocks.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blocos")),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.loadCarnivalBlocks,
          builder: (context, child) {
            if (widget.viewModel.loadCarnivalBlocks.isExecuting.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.loadCarnivalBlocks.results.value.hasError) {
              return ErrorWidget(
                widget.viewModel.loadCarnivalBlocks.results.value.error!,
              );
            }

            var carnivalBlock = widget
                .viewModel
                .loadCarnivalBlocks
                .results
                .value
                .data
                ?.getOrNull();
            if (carnivalBlock == null) {
              return const Center(child: Text('Nenhum bloco encontrado'));
            }
            return Center(
              child: Text(
                carnivalBlock.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
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
