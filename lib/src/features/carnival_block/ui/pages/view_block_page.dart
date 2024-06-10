import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/events/carnival_block_event.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/states/carnival_block_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ViewBlockPage extends StatefulWidget {
  const ViewBlockPage({super.key});

  @override
  State<ViewBlockPage> createState() => _ViewBlockPageState();
}

class _ViewBlockPageState extends State<ViewBlockPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CarnivalBlockBloc>();
    var state = bloc.state;
    if (state is LoadingCarnivalBlockState) {
      final email = state.storage.read('email');
      bloc.add(LoadCarnivalBlockEvent(email: email));
    }
    state = bloc.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloco'),
        leading: BackButton(
          onPressed: () {
            Modular.to.navigate('/');
          },
        ),
      ),
      body: _buildBody(bloc: bloc, state: state),
    );
  }

  Widget _buildBody({
    required CarnivalBlockBloc bloc,
    required CarnivalBlockState state,
  }) {
    Widget body = const Center(
      child: Text('Você não possui blocos'),
    );

    if (state is CreatedCarnivalBlockState) {
      final carnivalBlock = state.carnivalBlock;
      return body = ListView(
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  carnivalBlock.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dono: ${carnivalBlock.owner}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return body;
  }
}
