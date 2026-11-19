import "dart:async";

import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/onboarding/onboarding_prefs.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:supabase_flutter/supabase_flutter.dart" hide AuthState;

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  StreamSubscription<dynamic>? _authSubscription;
  bool _didRoute = false;

  @override
  void initState() {
    super.initState();
    _startListeningForVerification();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _startListeningForVerification() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      response,
    ) {
      if (response.event == AuthChangeEvent.signedIn &&
          response.session != null) {
        // Verify the session has a recent email confirmation timestamp
        // to ensure this is from email verification, not just any sign-in
        final session = response.session!;
        if (session.user.emailConfirmedAt != null) {
          _navigateAfterVerification();
        }
      }
    });
  }

  void _resendVerification() {
    context.read<AuthCubit>().resendVerification(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(
            context,
            message: extractUserMessage(state.error, context),
          );
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.localizedMessage(l10n));
        } else if (state is AuthAuthenticated) {
          // User confirmed email and logged in - check onboarding status
          _navigateAfterVerification();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Semantics(
            label: l10n.authBackButton,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: l10n.authBackButton,
              onPressed: () => context.pop(),
            ),
          ),
          title: Text(l10n.authAppTitle),
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
                  size: AppIconSizes.illustrationLarge,
                  color: colors.primary,
                ),
                const SizedBox(height: Spacing.space_lg),
                Text(
                  l10n.verifyEmailTitle,
                  style: AppTypography.headlineMedium.copyWith(
                    color: colors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_md),
                Text(
                  l10n.verifyEmailMessage,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_xs),
                Text(
                  widget.email,
                  style: AppTypography.titleMedium.copyWith(
                    color: colors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.space_xl),
                AppCard(
                  child: Column(
                    children: [
                      Text(
                        l10n.verifyEmailNotReceived,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.space_sm),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return AppButton(
                              label: l10n.verifyEmailResendButton,
                              isLoading: true,
                              isFullWidth: true,
                              variant: AppButtonVariant.secondary,
                            );
                          }
                          return AppButton(
                            label: l10n.verifyEmailResendButton,
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
                  l10n.verifyEmailFooter,
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

  /// Sends the user to the onboarding on the first authenticated entry, to
  /// home on every later one.
  Future<void> _navigateAfterVerification() async {
    if (_didRoute) return;
    _didRoute = true;
    var hasSeenOnboarding = true;
    try {
      hasSeenOnboarding = await OnboardingPrefs.hasSeenOnboarding();
    } catch (_) {
      // A storage failure must not block the entry — go home.
    }
    if (!mounted) return;
    context.go(hasSeenOnboarding ? Routes.home : Routes.onboarding);
  }
}
