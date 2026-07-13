// lib/ui/auth/logout/widgets/logout_button.dart
//
// Design-system-compliant logout button with confirmation dialog.

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    this.variant = AppButtonVariant.ghost,
    this.label = "Sair",
  });

  final AppButtonVariant variant;
  final String label;

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: "Sair da conta?",
      message: "Voce precisara fazer login novamente para acessar o app.",
      confirmLabel: "Sair",
      cancelLabel: "Cancelar",
      isDestructive: true,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(
            context,
            message: state.message.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return AppButton(
          label: label,
          variant: variant,
          icon: const Icon(Icons.logout_rounded),
          isLoading: state is AuthLoading,
          onPressed: state is AuthLoading ? null : () => _handleLogout(context),
        );
      },
    );
  }
}
