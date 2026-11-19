<!-- Context: development/concepts/flutter-ui-patterns | Priority: medium | Version: 2.0 | Updated: 2026-07-03 -->

# Pattern: Two-Phase Commit for User Actions

> Universal Flutter UI pattern — applicable across any Flutter project where the user previews an operation before committing (region selection, photo crop, multi-edit forms, etc.).

## Quick Reference

| Action | Visual | Data | Overlay |
|--------|--------|------|---------|
| **Cut** | Updates view | Pending | stays |
| **Apply** | Confirmed | Commits all | dismisses |
| **Cancel** | Restores | Discards | dismisses |

---

## Core Idea

Separate visual feedback from data commit, allowing the user to review effects before finalizing.

**Use Case**: Region selection on a chart, photo crop in an editor, multi-item selection in a list — any operation where the user wants to preview the effect before persisting.

## Three-Phase Flow

| Action | Visual | Data | Overlay |
|--------|--------|------|---------|
| **Cut** | Updates view | Pending | stays |
| **Apply** | Confirmed | Commits all | dismisses |
| **Cancel** | Restores | Discards | dismisses |

## State Tracking

```dart
// Pending operations awaiting finalization
List<(int start, int end)> _pendingActions;

// Backup for restore on cancel
List<Item> _originalItems;
```

## Button Handlers

```dart
void onCut() {
  _pendingActions.add(change);
  _applyVisualState(change);  // Visual only
  // Overlay stays open for more cuts
}

void onApply() {
  _commitAllChanges(_pendingActions);  // Data commit
  _pendingActions.clear();
  _dismissOverlay();
}

void onCancel() {
  _restoreOriginal(_originalItems);  // Visual restore
  _pendingActions.clear();
  _dismissOverlay();
}
```

**Benefits**:
- User can preview multiple operations before committing
- Cancel always restores original state
- Clear separation between visual and data operations

---

## Variations

- **Single-action preview**: Skip the pending list; commit immediately on Apply (e.g., crop a photo).
- **Live preview**: Commit on every Cut (no Apply needed) — simpler state but harder to cancel.
- **Multi-step wizard**: Each step applies the pattern; final Apply commits to data layer.

---

## Related Files

- State management patterns: `flutter-state-management.md`
- Cubit partial updates: `../guides/flutter-bloc-patterns.md`
