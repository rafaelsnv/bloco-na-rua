import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";

/// The single logout entry point shared by the profile and the settings
/// screens — one control, one dialog, one copy.
class LogoutAction extends StatelessWidget {
  const LogoutAction({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.logoutTitle,
      message: l10n.logoutMessage,
      confirmLabel: l10n.logoutConfirm,
      cancelLabel: l10n.logoutCancel,
      isDestructive: true,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(
            context,
            message: extractUserMessage(state.error, context),
          );
        }
      },
      builder: (context, state) {
        return AppButton(
          label: l10n.logoutTitle,
          variant: AppButtonVariant.error,
          icon: const Icon(Icons.logout_rounded, size: AppIconSizes.md),
          isFullWidth: true,
          isLoading: state is AuthLoading,
          onPressed: state is AuthLoading ? null : () => _handleLogout(context),
        );
      },
    );
  }
}
