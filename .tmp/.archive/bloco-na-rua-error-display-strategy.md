---
project: bloco-na-rua
feature: error-warning-display-strategy
created: 2026-07-19
updated: 2026-07-19
status: in_progress
current_stage: proposal
---

# Design Plan: Error & Warning Display Strategy

## User Requirements

Propose a comprehensive error/warning display strategy based on observed runtime
logs. Current behavior shows technical jargon (e.g. `DioException [bad response]`)
in user-facing snackbars; some errors fail silently; secure-storage / token
issues are logged at INFO with no user feedback.

## Design Goals

- Map every error category to a display pattern (snackbar / dialog / inline / full-screen)
- Centralize user-facing error formatting in one place
- Eliminate technical jargon from any message the user sees
- Make error recovery actions explicit (retry, login again, refresh)
- Don't rebuild what already exists — wire the existing infrastructure to the data layer

## Existing Infrastructure (audit, don't redesign)

| File                                       | Purpose                                | Status             |
| ------------------------------------------ | -------------------------------------- | ------------------ |
| `lib/core/error_types.dart`                | `ApiErrorType` enum                    | done               |
| `lib/core/error_messages.dart`             | pt_BR copy catalog                     | done               |
| `lib/core/api_error.dart`                  | `ApiError` + `fromDioException`        | done, **unused**   |
| `lib/core/errors/user_message.dart`        | `extractUserMessage()`                 | done, **bypasses** |
| `lib/ui/core/widgets/feedback/app_snackbar.dart` | `AppSnackbar.{success,error,warning,info}` | done         |
| `lib/ui/core/widgets/feedback/app_dialog.dart`   | `AppDialog.{confirm,alert}`            | done               |
| `lib/ui/core/widgets/state/app_error.dart`        | full-screen retry state               | done               |
| `lib/ui/error/widgets/error_screen.dart`          | route-level error                     | done               |

## Stage 1–3: Layout / Theme / Animation

Inline in proposal doc — no new visual design needed; the widgets above cover
all required patterns.

## Stage 4: Implementation

Single-file diffs at the **data-layer boundary** — see proposal. Do NOT
rebuild the error system; the work is in `carnival_block_members_api_client.dart`
+ similar API clients + `BaseApiClient` + cubit `catch` paths.

## Output Files

- Proposal: this file (delivered inline in chat)
- Code changes: applied to existing files; no new files required for MVP
