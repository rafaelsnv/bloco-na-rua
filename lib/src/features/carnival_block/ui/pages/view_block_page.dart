import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';
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
  late final String email;
  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<CarnivalBlockBloc>();
    var state = bloc.state;
    if (state is LoadingCarnivalBlockState) {
      email = state.storage.read('email');
      bloc.add(LoadCarnivalBlockEvent(email: email));
    }

    bloc = context.watch<CarnivalBlockBloc>();
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
      body: _buildBody(
        bloc: bloc,
      ),
    );
  }

  Widget _buildBody({
    required CarnivalBlockBloc bloc,
  }) {
    Widget body = Center(
      child: Column(
        children: [
          const Text('Você não possui blocos'),
          FilledButton.tonal(
            onPressed: () {
              Modular.to.navigate('/block/create_block');
            },
            child: const Text('Criar bloco'),
          ),
        ],
      ),
    );

    final state = bloc.state;

    if (state is LoadedCarnivalBlockState) {
      final blockList = state.blockList;
      final sessionEmail = state.sessionEmail;

      return body = ListView(
        children: _buildBlocksList(
          bloc: bloc,
          blockList: blockList,
          sessionEmail: sessionEmail,
        ),
      );
    }
    return body;
  }

  List<Widget> _buildBlocksList({
    required String sessionEmail,
    required CarnivalBlockBloc bloc,
    required List<CarnivalBlockEntity> blockList,
  }) {
    const titleStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    );
    late final widgetList = List<Widget>.empty(growable: true);

    for (final block in blockList) {
      final blockName = block.name;
      final managers = block.managers;
      final percussion = block.percussion;
      final widget = Card(
        color: Colors.grey.shade200,
        elevation: 10,
        child: Center(
          child: Column(
            children: [
              Text(
                blockName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                'Dono: ${block.owner}',
                style: const TextStyle(fontSize: 16),
              ),
              _buildSectionList(
                title: const Text(
                  'Organizadores',
                  style: titleStyle,
                ),
                sectionMap: managers,
              ),
              _buildSectionList(
                title: const Text(
                  'Membros da bateria',
                  style: titleStyle,
                ),
                sectionMap: percussion,
              ),
              if (block.owner == sessionEmail)
                // ||block.managers.containsValue(sessionEmail))
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromARGB(197, 244, 54, 54),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Excluir bloco $blockName'),
                          content: const Text(
                            'Tem certeza que deseja excluir o bloco?',
                          ),
                          actions: <Widget>[
                            FilledButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            FilledButton.tonal(
                              onPressed: () {
                                bloc.add(
                                  DeleteCarnivalBlockEvent(
                                    email: email,
                                    carnivalBlock: block,
                                  ),
                                );
                                Navigator.of(context).pop();
                                Modular.to.navigate('/');
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Excluir'),
                ),
              if (block.owner == sessionEmail ||
                  block.managers.containsValue(sessionEmail))
                FilledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        bloc.add(
                          InviteCarnivalBlockEvent(
                            carnivalBlock: block,
                          ),
                        );
                        return AlertDialog(
                          title: const Text('Código para convite'),
                          content: Text(block.inviteCode),
                        );
                      },
                    );
                  },
                  child: const Text('Convidar membros'),
                ),
            ],
          ),
        ),
      );
      widgetList.add(widget);
    }
    return widgetList;
  }

  Widget _buildSectionList({
    required Widget title,
    required Map<String, dynamic> sectionMap,
  }) {
    final listText = sectionMap
        .map((key, value) => MapEntry(key, Text(value)))
        .values
        .toList();

    return Center(
      child: ExpansionTile(
        dense: true,
        visualDensity: VisualDensity.comfortable,
        title: title,
        trailing: const SizedBox(),
        children: listText,
      ),
    );
  }
}
