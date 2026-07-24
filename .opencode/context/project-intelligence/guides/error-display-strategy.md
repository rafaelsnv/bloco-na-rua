<!-- Context: guides/error-display-strategy | Priority: medium | Version: 1.0 | Created: 2026-07-19 -->

# Error & Warning Display Strategy

**Core Idea**: Map every error category to a display pattern (snackbar/dialog/inline/full-screen) and centralize user-facing error formatting to eliminate technical jargon.

**Key Points**:
- Use existing widgets: `AppSnackbar`, `AppDialog`, `AppError` full-screen retry state
- Centralize formatting in data-layer boundary (API clients + cubit `catch` paths)
- Don't rebuild infrastructure; wire existing error system to data layer
- Map: snackbar (minor), dialog (confirm), inline (validation), full-screen (critical)

**Existing Infrastructure** (audit before adding):
| File | Purpose | Status |
|------|---------|--------|
| `lib/core/error_types.dart` | ApiErrorType enum | done |
| `lib/core/error_messages.dart` | pt_BR copy catalog | done |
| `lib/core/api_error.dart` | ApiError + fromDioException | done, unused |
| `lib/core/errors/user_message.dart` | extractUserMessage() | done, bypasses |
| `lib/ui/core/widgets/feedback/app_snackbar.dart` | AppSnackbar.{success,error,warning,info} | done |
| `lib/ui/core/widgets/feedback/app_dialog.dart` | AppDialog.{confirm,alert} | done |
| `lib/ui/core/widgets/state/app_error.dart` | full-screen retry state | done |

**Implementation**: Single-file diffs at data-layer boundary in `carnival_block_members_api_client.dart` + similar API clients + BaseApiClient + cubit catch paths.

**Source**: `.tmp/design-plans/bloco-na-rua-error-display-strategy.md`
