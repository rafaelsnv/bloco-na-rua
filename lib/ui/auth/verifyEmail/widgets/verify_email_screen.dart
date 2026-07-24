import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    _startListeningForVerification();
  }

  void _startListeningForVerification() {
    // Listen for auth state changes to detect email verification
    // The parent context's AuthListenable will notify when user is verified
  }

  void _resendVerification() {
    context.read<AuthCubit>().resendVerification(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(
            context,
            message: state.message.replaceAll("Exception: ", ""),
          );
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.message ?? "Sucesso!");
        } else if (state is AuthAuthenticated) {
          // User confirmed email and logged in - check onboarding status
          _navigateAfterVerification();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go(Routes.login),
          ),
          title: Text(
            "Bloco na Rua",
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(
                  Icons.mark_email_unread_rounded,
                  size: 100,
                  color: AppColors.primary,
                ),
                const SizedBox(height: Spacing.space_lg),
                Text(
                  "Verifique seu e-mail",
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_md),
                Text(
                  "Enviamos um link de confirmação para seu e-mail",
                  style: AppTypography.bodyLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_xs),
                Text(
                  widget.email,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_xl),
                AppCard(
                  child: Column(
                    children: [
                      Text(
                        "Não recebeu o e-mail?",
                        style: AppTypography.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.space_sm),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const AppButton(
                              label: "Reenviar e-mail",
                              isLoading: true,
                              isFullWidth: true,
                              variant: AppButtonVariant.secondary,
                            );
                          }
                          return AppButton(
                            label: "Reenviar e-mail",
                            onPressed: _resendVerification,
                            isFullWidth: true,
                            variant: AppButtonVariant.secondary,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  "Depois de confirmar, você será direcionado para o app",
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateAfterVerification() {
    // Navigate to onboarding on first login, or home on subsequent logins
    // For now, always go to home - onboarding check can be added later
    context.go(Routes.home);
  }
}
