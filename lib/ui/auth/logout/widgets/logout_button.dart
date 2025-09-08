import 'package:bloco_na_rua/ui/auth/logout/view_model/logout_viewmodel.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key, required this.viewModel});

  final LogoutViewModel viewModel;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.logout.removeListener(_onResult);
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onResult);
    super.dispose();
  }

  void _onResult() {
    if (widget.viewModel.logout.results.value.hasError) {
      widget.viewModel.logout.clearErrors();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("error logout")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () => widget.viewModel.logout.execute(),
    );
  }
}
