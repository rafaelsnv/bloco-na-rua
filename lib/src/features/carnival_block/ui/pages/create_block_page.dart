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

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 6, vertical: 4);

    final bloc = context.watch<CarnivalBlockBloc>();
    final state = bloc.state;
    final isLoading = state is LoadingCarnivalBlockState;
    late String sessionEmail;
    if (state is LoadedCarnivalBlockState) {
      sessionEmail = state.sessionEmail;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Bloco'),
        leading: BackButton(
          onPressed: () {
            Modular.to.navigate('/block/view_block');
          },
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: padding,
                  child: TextFormField(
                    autofocus: true,
                    enabled: !isLoading,
                    onChanged: (value) {
                      blockName = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome do bloco*',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                FilledButton(
                  onPressed: () {
                    if (blockName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Preencha os campos obrigatórios',
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(1.2),
                          ),
                          duration: const Duration(milliseconds: 1500),
                          width: 250,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      return;
                    }
                    final event = CreateCarnivalBlockEvent(
                      id: 2,
                      name: blockName,
                      owner: sessionEmail,
                      // owner: ownerEmail,
                    );
                    bloc.add(event);
                    Modular.to.navigate('/block/view_block');
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
