import 'package:bloco_na_rua/ui/auth/logout/view_model/logout_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/home/view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';
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
            child: LogoutButton(
              viewModel: LogoutViewModel(authRepository: context.read()),
            ),
          ),
        ),
      ),
    );
  }
}
