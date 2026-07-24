import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_list_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
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
    return Scaffold(
      appBar: const AppAppBar(title: "Configuracoes"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: Spacing.pagePaddingMobile),
        children: [
          AppCard(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  // Error handled by auth cubit
                }
              },
              builder: (context, state) {
                return AppListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                  ),
                  title: "Sair",
                  trailing: state is AuthLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  onTap: state is AuthLoading
                      ? null
                      : () => _confirmLogout(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
