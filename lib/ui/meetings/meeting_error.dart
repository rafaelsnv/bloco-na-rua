import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:equatable/equatable.dart";
import "package:flutter/widgets.dart";

/// The kind of failure a meetings cubit can report.
///
/// The cubits have no [BuildContext], so they never build a user-facing
/// string themselves: they carry the [kind] (plus the raw [failure] when
/// there is one) and the screens map it to localized text through
/// [localizeMeetingError].
enum MeetingErrorKind {
  /// The meeting id could not be parsed.
  invalidId,

  /// The current member could not be resolved.
  notAuthenticated,

  /// The request itself failed (the raw failure carries the reason).
  request,
}

/// A failure carried by a meetings cubit state.
class MeetingError extends Equatable {
  const MeetingError(this.kind, [this.failure]);

  /// What went wrong.
  final MeetingErrorKind kind;

  /// The raw failure, when the kind depends on one.
  final Object? failure;

  @override
  List<Object?> get props => [kind, failure];
}

/// Maps [error] to a localized, user-facing message.
///
/// [context] is required so the raw failure can be translated by
/// [extractUserMessage] when the failure is an API error.
String localizeMeetingError(BuildContext context, MeetingError error) {
  final l10n = AppLocalizations.of(context)!;

  switch (error.kind) {
    case MeetingErrorKind.invalidId:
      return l10n.meetingsInvalidMeetingId;
    case MeetingErrorKind.notAuthenticated:
      return l10n.meetingsNotAuthenticated;
    case MeetingErrorKind.request:
      return error.failure == null
          ? l10n.unknown
          : extractUserMessage(error.failure, context);
  }
}
