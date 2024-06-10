import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/events/carnival_block_event.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/states/carnival_block_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateBlockPage extends StatefulWidget {
  const CreateBlockPage({super.key});

  @override
  State<CreateBlockPage> createState() => _CreateBlockPageState();
}

class _CreateBlockPageState extends State<CreateBlockPage> {
  String blockName = '';
  String ownerEmail = '';

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CarnivalBlockBloc>();
    final state = bloc.state;
    final isLoading = state is LoadingCarnivalBlockState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Bloco'),
        leading: BackButton(
          onPressed: () {
            Modular.to.navigate('/');
          },
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 5),
                TextFormField(
                  enabled: !isLoading,
                  onChanged: (value) {
                    blockName = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do bloco',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  enabled: !isLoading,
                  onChanged: (value) {
                    ownerEmail = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail do dono',
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final event = CreateCarnivalBlockEvent(
                      id: 2,
                      name: blockName,
                      owner: ownerEmail,
                    );
                    bloc.add(event);
                  },
                  child: const Text('Criar bloco'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
