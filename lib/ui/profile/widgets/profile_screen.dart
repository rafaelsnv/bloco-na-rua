import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_list_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_avatar.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/routing/routes.dart";

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
        appBar: AppAppBar(title: "Perfil"),
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
        // Hero section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.space_lg),
          child: Column(
            children: [
              AppAvatar(
                imageUrl: profileImage,
                name: name,
                size: AvatarSize.xl,
                imageCacheVersion: member.updatedAt,
              ),
              const SizedBox(height: Spacing.space_md),
              Text(name, style: AppTypography.headlineSmall),
              const SizedBox(height: Spacing.space_xs),
              Text(
                email,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Info card
        AppCard(
          child: Column(
            children: [
              AppListTile(
                leading: const Icon(Icons.phone_rounded),
                title: "Telefone",
                subtitle: phone.isNotEmpty ? phone : "Não informado",
              ),
              const Divider(height: 1),
              AppListTile(
                leading: const Icon(Icons.calendar_today_rounded),
                title: "Membro desde",
                subtitle: createdAt != null
                    ? DateFormat("MMMM/yyyy", "pt_BR").format(createdAt)
                    : "Não disponível",
              ),
            ],
          ),
        ),

        const SizedBox(height: Spacing.space_lg),

        // Navigation card
        AppCard(
          child: Column(
            children: [
              AppListTile(
                leading: const Icon(Icons.settings_rounded),
                title: "Configurações",
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.settings),
              ),
              const Divider(height: 1),
              AppListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                ),
                title: "Sair",
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ],
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
