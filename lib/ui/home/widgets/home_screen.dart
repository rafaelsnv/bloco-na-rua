import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/view_model/logout_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/profile_button.dart';
import 'package:bloco_na_rua/ui/home/view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onResult() {
    final result = widget.viewModel.load.results.value.data;

    if (result == null) {
      return;
    }

    if (result.isError()) {
      widget.viewModel.load.clearErrors();
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
    widget.viewModel.load.addListener(_onResult);
    widget.viewModel.load();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.load.removeListener(_onResult);
    widget.viewModel.load.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.load.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ProfileButton(),
        title: const Text('Bloco Na Rua'),
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(authRepository: context.read()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.isExecuting.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (widget.viewModel.load.results.value.hasError) {
                  return ErrorWidget(
                    widget.viewModel.load.results.value.error!,
                  );
                }

                var blockMembersList = widget.viewModel.load.results.value.data
                    ?.getOrNull();
                if (blockMembersList == null || blockMembersList.isEmpty) {
                  return const Center(child: Text('Nenhum bloco encontrado'));
                }

                return Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: CarouselView.weighted(
                        flexWeights: const <int>[3, 3, 3, 2, 1],
                        children: blockMembersList.map((blockMember) {
                          return ColoredBox(
                            color: Colors.grey,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.casino, size: 50.0),
                                  Text(
                                    blockMember.carnivalBlock!.name,
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
            Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () => context.push(Routes.carnivalBlock),
                    child: const Text('Block Page'),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => context.push(Routes.members),
                    child: const Text('Members Page'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
