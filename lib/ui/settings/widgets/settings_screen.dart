// lib/ui/settings/widgets/settings_screen.dart
//
// Bloco na Rua design system settings screen.
//
// Rewritten to use design system primitives:
//   - AppAppBar, AppCard, AppListTile, AppSectionHeader
//   - AppDialog.confirm for logout confirmation
//   - AppSnackbar for feedback
//   - BlocBuilder<AuthCubit, AuthState> for logout loading state
//   - BlocBuilder<ThemeCubit, ThemeMode> for live theme mode
//   - Theme persistence delegated to ThemeCubit (SharedPreferences)
//
// All colors/spacings/radii via design system tokens.

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_list_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => "Sistema",
      ThemeMode.light => "Claro",
      ThemeMode.dark => "Escuro",
    };
  }

  void _showThemeSnackbar(BuildContext context, ThemeMode mode) {
    AppSnackbar.info(
      context,
      message: "Tema alterado para ${_themeModeLabel(mode)}",
    );
  }

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
          // Secao Aparencia
          const AppSectionHeader(title: "Aparencia"),
          AppCard(
            child: Column(
              children: [
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return AppListTile(
                      leading: const Icon(Icons.brightness_6_rounded),
                      title: "Tema",
                      trailing: PopupMenuButton<ThemeMode>(
                        initialValue: themeMode,
                        onSelected: (mode) {
                          context.read<ThemeCubit>().setMode(mode);
                          _showThemeSnackbar(context, mode);
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: ThemeMode.system,
                            child: Row(
                              children: const [
                                Icon(Icons.brightness_auto_rounded, size: 20),
                                SizedBox(width: Spacing.space_xs),
                                Text("Sistema"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: ThemeMode.light,
                            child: Row(
                              children: const [
                                Icon(Icons.light_mode_rounded, size: 20),
                                SizedBox(width: Spacing.space_xs),
                                Text("Claro"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: ThemeMode.dark,
                            child: Row(
                              children: const [
                                Icon(Icons.dark_mode_rounded, size: 20),
                                SizedBox(width: Spacing.space_xs),
                                Text("Escuro"),
                              ],
                            ),
                          ),
                        ],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _themeModeLabel(themeMode),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: Spacing.space_4xs),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Gap between sections
          const SizedBox(height: Spacing.sectionGap),

          // Secao Conta
          const AppSectionHeader(title: "Conta"),
          AppCard(
            child: Column(
              children: [
                AppListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: "Editar perfil",
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppSnackbar.info(
                      context,
                      message: "Editar perfil em breve",
                    );
                  },
                ),
                const Divider(height: 1, indent: Spacing.space_sm),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      AppSnackbar.error(
                        context,
                        message: state.message.replaceAll("Exception: ", ""),
                      );
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
