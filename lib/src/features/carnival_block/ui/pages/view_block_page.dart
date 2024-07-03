import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/events/carnival_block_event.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/states/carnival_block_state.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ViewBlockPage extends StatefulWidget {
  const ViewBlockPage({super.key});

  @override
  State<ViewBlockPage> createState() => _ViewBlockPageState();
}

class _ViewBlockPageState extends State<ViewBlockPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<CarnivalBlockBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloco'),
        leading: BackButton(
          onPressed: () {
            Modular.to.navigate('/');
          },
        ),
      ),
      body: _buildBody(bloc: bloc),
    );
  }

  Widget _buildBody({
    required CarnivalBlockBloc bloc,
  }) {
    final createBlockButton = FilledButton.tonalIcon(
      icon: const Icon(Icons.add),
      onPressed: () {
        Modular.to.navigate('/block/create_block');
      },
      label: const Text('Criar bloco'),
    );

    var body = ListView(
      children: [
        Center(
          child: Column(
            children: [
              const Text('Você não possui blocos'),
              createBlockButton,
            ],
          ),
        ),
      ],
    );

    final state = bloc.state;

    if (state is LoadedCarnivalBlockState) {
      final blockList = state.blockList;
      final sessionEmail = state.sessionEmail;

      final filledBlocks = List<Widget>.from(
        _buildBlocksList(
          bloc: bloc,
          blockList: blockList,
          sessionEmail: sessionEmail,
        ),
      )..add(createBlockButton);

      body = ListView(
        children: [
          Center(
            child: Column(
              children: filledBlocks,
            ),
          ),
        ],
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
      final isOwner = block.owner == sessionEmail;
      final isManager = isOwner ||
          block.managers.any((element) => element.containsValue(sessionEmail));

      final widget = Card(
        color: Colors.grey.shade200,
        elevation: 10,
        child: Center(
          child: Column(
            children: [
              Text(
                block.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                'Dono: ${block.owner}',
                style: const TextStyle(fontSize: 16),
              ),
              if (isOwner)
                _buildExcludeButton(
                  bloc: bloc,
                  carnivalBlock: block,
                  sessionEmail: sessionEmail,
                ),
              _buildSectionList(
                title: const Text(
                  'Organizadores',
                  style: titleStyle,
                ),
                sectionList: block.managers,
              ),
              if (isManager)
                _buildInviteManagerButton(carnivalBlock: block, bloc: bloc),
              _buildSectionList(
                title: const Text(
                  'Encontros',
                  style: titleStyle,
                ),
                sectionList: block.meetings,
              ),
              _buildSectionList(
                title: const Text(
                  'Membros da bateria',
                  style: titleStyle,
                ),
                sectionList: block.percussion,
              ),
              if (isManager)
                _buildInviteMemberButton(bloc: bloc, carnivalBlock: block),
            ],
          ),
        ),
      );
      widgetList.add(widget);
    }
    return widgetList;
  }

  Center _buildSectionList({
    required Widget title,
    required List<Map<String, dynamic>> sectionList,
  }) {
    final listText = List<Text>.empty(growable: true);
    for (final element in sectionList) {
      late MapEntry<String, Text> mapEntry;
      final actualList = element.map((key, value) {
        switch (value.runtimeType) {
          case String:
            mapEntry = MapEntry(key, Text(value));
            break;
          default:
            break;
        }

        return mapEntry;
      }).values;
      listText.addAll(actualList);
    }

    return Center(
      child: ExpansionTile(
        dense: true,
        visualDensity: VisualDensity.comfortable,
        title: title,
        children: listText,
      ),
    );
  }

  FilledButton _buildInviteMemberButton({
    required CarnivalBlockEntity carnivalBlock,
    required CarnivalBlockBloc bloc,
  }) {
    return FilledButton.icon(
      icon: const Icon(Icons.person_add),
      label: const Text('Convidar membros'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            bloc.add(
              InviteCarnivalBlockEvent(
                carnivalBlock: carnivalBlock,
              ),
            );
            return AlertDialog(
              title: const Text('Código para convite de membros'),
              content: Text(carnivalBlock.inviteCode),
              actions: [
                FilledButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: carnivalBlock.inviteCode,
                      ),
                    ).then((_popSnackBar) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Código copiado',
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
                    });
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  FilledButton _buildInviteManagerButton({
    required CarnivalBlockEntity carnivalBlock,
    required CarnivalBlockBloc bloc,
  }) {
    return FilledButton.icon(
      icon: const Icon(Icons.person_add),
      label: const Text('Convidar organizador'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            bloc.add(
              InviteCarnivalBlockEvent(
                carnivalBlock: carnivalBlock,
              ),
            );
            return AlertDialog(
              title: const Text('Código para convidar organizadores'),
              content: Text(carnivalBlock.managersCode),
              actions: [
                FilledButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: carnivalBlock.managersCode,
                      ),
                    ).then((_popSnackBar) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Código copiado',
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
                    });
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  FilledButton _buildExcludeButton({
    required String sessionEmail,
    required CarnivalBlockEntity carnivalBlock,
    required CarnivalBlockBloc bloc,
  }) {
    final blockName = carnivalBlock.name;

    if (blockName.isEmpty) {}

    return FilledButton(
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
              actions: [
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
                        email: sessionEmail,
                        carnivalBlock: carnivalBlock,
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
    );
  }
}
