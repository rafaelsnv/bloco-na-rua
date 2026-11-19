import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:equatable/equatable.dart";
import "package:flutter/widgets.dart";

/// The kind of failure a carnivalBlock cubit can report.
///
/// The cubits have no [BuildContext], so they never build a user-facing
/// string themselves: they carry the [kind] (plus the raw [failure] when
/// there is one) and the screens map it to localized text through
/// [localizeBlockError].
enum BlockErrorKind {
  /// The block id could not be parsed.
  invalidId,

  /// The requested block does not exist.
  notFound,

  /// The invite code was empty.
  emptyInviteCode,

  /// The current user data could not be loaded.
  userData,

  /// Joining a block failed.
  joinFailed,

  /// An unexpected exception escaped the operation.
  unexpected,

  /// The request itself failed (the raw failure carries the reason).
  request,
}

/// A failure carried by a carnivalBlock cubit state.
class BlockError extends Equatable {
  const BlockError(this.kind, [this.failure]);

  /// What went wrong.
  final BlockErrorKind kind;

  /// The raw failure, when the kind depends on one.
  final Object? failure;

  @override
  List<Object?> get props => [kind, failure];
}

/// Maps [error] to a localized, user-facing message.
///
/// [context] is required so the raw failure can be translated by
/// [extractUserMessage] when the failure is an API error.
String localizeBlockError(BuildContext context, BlockError error) {
  final l10n = AppLocalizations.of(context)!;
  final detail = error.failure == null
      ? l10n.unknown
      : extractUserMessage(error.failure, context);

  switch (error.kind) {
    case BlockErrorKind.invalidId:
      return l10n.blocksInvalidId;
    case BlockErrorKind.notFound:
      return l10n.blocksNotFound;
    case BlockErrorKind.emptyInviteCode:
      return l10n.blocksEmptyInviteCode;
    case BlockErrorKind.userData:
      return l10n.blocksUserDataError(detail);
    case BlockErrorKind.joinFailed:
      return l10n.blocksJoinFailed(detail);
    case BlockErrorKind.unexpected:
      return l10n.blocksUnexpectedError(detail);
    case BlockErrorKind.request:
      return detail;
  }
}
