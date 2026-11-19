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
  /// The account was created; the user must log in.
  accountCreated,

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
    AuthSuccessKind.accountCreated => l10n.authAccountCreated,
    AuthSuccessKind.recoveryEmailSent => l10n.authRecoveryEmailSent,
  };
}

final class AuthAuthenticated extends AuthState {}

final class AuthUnauthenticated extends AuthState {}

/// A failed auth operation carrying the raw failure for render-time localization.
final class AuthFailure extends AuthState {
  final Object? error;
  final bool isSignup;
  const AuthFailure(this.error, {this.isSignup = false});

  @override
  List<Object?> get props => [error, isSignup];
}
