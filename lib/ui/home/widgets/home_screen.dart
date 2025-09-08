import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/view_model/logout_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainScreen'),
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(authRepository: context.read()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            if (widget.viewModel.load.isExecuting.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.load.results.value.hasError) {
              return ErrorWidget(widget.viewModel.load.results.value.error!);
            }

            return child!;
          },
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                context.go(Routes.carnivalBlock);
              },
              child: const Text('toBlockPage'),
            ),
          ),
        ),
      ),
    );
  }
}
