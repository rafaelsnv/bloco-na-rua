import 'package:equatable/equatable.dart';

import 'package:bloco_na_rua/l10n/app_localizations.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

/// What the user just completed successfully.
enum AuthSuccessKind {
  /// The verification e-mail was sent again.
  verificationEmailSent,

  /// The password recovery e-mail was sent.
  recoveryEmailSent,
}

final class AuthSuccess extends AuthState {
  final AuthSuccessKind kind;
  const AuthSuccess(this.kind);

  @override
  List<Object?> get props => [kind];
}

/// The localized confirmation for a successful auth action.
extension AuthSuccessL10n on AuthSuccess {
  String localizedMessage(AppLocalizations l10n) => switch (kind) {
    AuthSuccessKind.verificationEmailSent => l10n.authVerifyEmailSent,
    AuthSuccessKind.recoveryEmailSent => l10n.authRecoveryEmailSent,
  };
}

final class AuthAuthenticated extends AuthState {}

final class AuthUnauthenticated extends AuthState {}

/// A failed auth operation carrying the raw failure for render-time localization.
final class AuthFailure extends AuthState {
  final Object? error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class AuthEmailVerificationSent extends AuthState {
  final String email;
  const AuthEmailVerificationSent({required this.email});

  @override
  List<Object?> get props => [email];
}
