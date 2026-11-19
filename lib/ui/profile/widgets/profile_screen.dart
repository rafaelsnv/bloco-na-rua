import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/auth/logout/widgets/logout_action.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(Routes.login);
        }
      },
      child: Scaffold(
        appBar: AppAppBar(title: l10n.profileTitle),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const AppLoading(),
              error: (message) => AppError(
                message: message == kProfileNotAuthenticated
                    ? l10n.profileNotAuthenticated
                    : message,
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
    final l10n = AppLocalizations.of(context)!;
    final name = member.name ?? "";
    final email = member.email ?? "";
    final phone = member.phone ?? "";
    final createdAt = member.createdAt;
    final profileImage = member.profileImage;
    final pagePadding = Spacing.pagePaddingFor(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        pagePadding,
        Spacing.pagePaddingMobile,
        pagePadding,
        Spacing.space_2xl,
      ),
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
                  Semantics(
                    label: l10n.profileChangePhotoLabel,
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        AppSnackbar.info(
                          context,
                          message: l10n.profileEditSoon,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.space_2xs),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: Radii.outlineWidth,
                          ),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: AppIconSizes.sm,
                          color: AppColors.inkFor(
                            Theme.of(context).colorScheme.surface,
                          ),
                        ),
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
        AppSectionHeader(title: l10n.profileAppearanceSection),
        _buildThemeDropdown(context),

        // Information section
        const SizedBox(height: Spacing.space_md),
        AppSectionHeader(title: l10n.profileInformationSection),
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
                  title: l10n.profilePhoneLabel,
                  subtitle: phone.isNotEmpty ? phone : l10n.profileNotInformed,
                );
              }
              return AppListTile(
                leading: const Icon(Icons.calendar_today_rounded),
                title: l10n.profileMemberSince,
                subtitle: createdAt != null
                    ? formatDatePattern("MMMM/yyyy", createdAt, context)
                    : l10n.profileNotAvailable,
              );
            },
          ),
        ),

        // Account section
        const SizedBox(height: Spacing.space_md),
        AppSectionHeader(title: l10n.profileAccountSection),
        const LogoutAction(),
      ],
    );
  }

  Widget _buildThemeDropdown(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return AppCard(
          padding: EdgeInsets.zero,
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode_rounded),
            title: Text(l10n.profileDarkMode, style: AppTypography.titleMedium),
            value: context.watch<ThemeCubit>().isDarkModeEnabled(context),
            onChanged: (v) => context.read<ThemeCubit>().setDarkMode(v),
          ),
        );
      },
    );
  }
}
