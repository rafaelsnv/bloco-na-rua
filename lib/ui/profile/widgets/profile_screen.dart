import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_list_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_avatar.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(Routes.login);
        }
      },
      child: Scaffold(
        appBar: AppAppBar(
          title: "Perfil",
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => context.push(Routes.settings),
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const AppLoading(),
              error: (message) => AppError(
                message: message,
                onRetry: () => context.read<ProfileCubit>().loadProfile(),
              ),
              loaded: (member) => _buildContent(context, member),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MembersEntity member) {
    final name = member.name ?? "";
    final email = member.email ?? "";
    final phone = member.phone ?? "";
    final createdAt = member.createdAt;
    final profileImage = member.profileImage;

    return ListView(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      children: [
        // Hero section with edit button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.space_xs),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  AppAvatar(
                    imageUrl: profileImage,
                    name: name,
                    size: AvatarSize.xl,
                    imageCacheVersion: member.updatedAt,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppSnackbar.info(
                        context,
                        message: "Editar perfil em breve",
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.space_2xs),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.space_sm),
              Text(name, style: AppTypography.headlineSmall),
              const SizedBox(height: Spacing.space_4xs),
              Text(
                email,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Appearance section
        const SizedBox(height: Spacing.space_md),
        const AppSectionHeader(title: "Aparência"),
        _buildThemeDropdown(context),

        // Information section
        const SizedBox(height: Spacing.space_md),
        const AppSectionHeader(title: "Informações"),
        AppCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, index) {
              if (index == 0) {
                return AppListTile(
                  leading: const Icon(Icons.phone_rounded),
                  title: "Telefone",
                  subtitle: phone.isNotEmpty ? phone : "Não informado",
                );
              }
              return AppListTile(
                leading: const Icon(Icons.calendar_today_rounded),
                title: "Membro desde",
                subtitle: createdAt != null
                    ? DateFormat("MMMM/yyyy", "pt_BR").format(createdAt)
                    : "Não disponível",
              );
            },
          ),
        ),

        // Account section
        const SizedBox(height: Spacing.space_md),
        const AppSectionHeader(title: "Conta"),
        AppButton(
          variant: AppButtonVariant.secondary,
          label: "Sair da conta",
          icon: const Icon(Icons.logout_rounded, size: 20),
          isFullWidth: true,
          onPressed: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildThemeDropdown(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final themeLabel = switch (themeMode) {
          ThemeMode.light => "Claro",
          ThemeMode.dark => "Escuro",
          ThemeMode.system => "Sistema",
        };

        return AppCard(
          padding: EdgeInsets.zero,
          child: AppListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            title: "Tema",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  themeLabel,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Spacing.space_2xs),
                PopupMenuButton<ThemeMode>(
                  initialValue: themeMode,
                  onSelected: (mode) {
                    context.read<ThemeCubit>().setMode(mode);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: ThemeMode.system,
                      child: Row(
                        children: [
                          Icon(Icons.brightness_auto_rounded, size: 20),
                          SizedBox(width: Spacing.space_xs),
                          Text("Sistema"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: ThemeMode.light,
                      child: Row(
                        children: [
                          Icon(Icons.light_mode_rounded, size: 20),
                          SizedBox(width: Spacing.space_xs),
                          Text("Claro"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: ThemeMode.dark,
                      child: Row(
                        children: [
                          Icon(Icons.dark_mode_rounded, size: 20),
                          SizedBox(width: Spacing.space_xs),
                          Text("Escuro"),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Sair"),
        content: const Text("Tem certeza que deseja sair da sua conta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: const Text("Sair", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
