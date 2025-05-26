import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/events/carnival_block_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_storage/get_storage.dart';

class JoinBlockPage extends StatefulWidget {
  const JoinBlockPage({super.key});

  @override
  State<JoinBlockPage> createState() => _JoinBlockPageState();
}

class _JoinBlockPageState extends State<JoinBlockPage> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 6, vertical: 4);

    final bloc = Modular.get<CarnivalBlockBloc>();
    final storage = Modular.get<GetStorage>();
    final sessionEmail = storage.read('email');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingressar em um Bloco'),
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
                Padding(
                  padding: padding,
                  child: TextFormField(
                    autofocus: true,
                    onChanged: (value) {
                      code = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Código de convite*',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                FilledButton(
                  onPressed: () {
                    if (code.isEmpty) {
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
                    final event = JoinCarnivalBlockEvent(
                      blockCode: code,
                      sessionEmail: sessionEmail,
                    );
                    bloc.add(event);
                    Modular.to.navigate('/block/view_block');
                  },
                  child: const Text('Ingressar em um bloco'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
