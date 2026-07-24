<!-- Context: standards/flutter-ui-patterns | Priority: medium | Version: 2.0 | Updated: 2026-07-13 -->

# Pattern: Two-Phase Commit for User Actions

> Universal Flutter UI pattern — applicable across any Flutter project.

## Quick Reference

| Action | Visual | Data | Overlay |
|--------|--------|------|---------|
| **Cut** | ✅ Updates view | ❌ Pending | stays |
| **Apply** | ✅ Confirmed | ✅ Commits all | dismisses |
| **Cancel** | ❌ Restores | ❌ Discards | dismisses |

---

## Pattern: Two-Phase Commit for User Actions

**Core Idea**: Separate visual feedback from data commit, allowing user to review before finalizing.

**Use Case**: Region selection, photo crop, or any visual preview-then-commit operation.

## Three-Phase Flow

| Action | Visual | Data | Overlay |
|--------|--------|------|---------|
| **Cut** | ✅ Updates view | ❌ Pending | stays |
| **Apply** | ✅ Confirmed | ✅ Commits all | dismisses |
| **Cancel** | ❌ Restores | ❌ Discards | dismisses |

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

## Pattern: Native Widget Migration (Default Behavior)

**Core Idea**: Prefer Flutter's native Material widgets over manual Container/GestureDetector/BoxDecoration stacks. Preserve public APIs while modernizing internals.

**Migration Table**:

| Custom Stack                                | Native Widget                              |
| ------------------------------------------- | ------------------------------------------ |
| Container + GestureDetector + BoxDecoration | FilledButton / OutlinedButton / TextButton |
| Custom icon button                          | IconButton                                 |
| Custom chip widget                          | RawChip / ActionChip / InputChip           |
| Custom avatar                               | CircleAvatar                              |
| Custom dialog                               | AlertDialog                                |
| AnimationController (pulse)                 | TweenAnimationBuilder                      |

**Theme additions** (add to app_theme.dart):
```dart
chipTheme: ChipThemeData(...),
progressIndicatorTheme: ProgressIndicatorThemeData(...),
snackBarTheme: SnackBarThemeData(...),
```

**Rules**:
- Public API must not change (preserve `variant`, `size`, etc.)
- Animations must respect `MediaQuery.disableAnimationsOf(context)` via TweenAnimationBuilder
- Use design tokens (Spacing.*, Radii.*, AppColors.*) — no hardcoded values
- No new packages required

**Example**: AppButton → FilledButton/OutlinedButton/TextButton
```dart
// ❌ Before: manual stack
Container(
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(Radii.md),
  ),
  child: GestureDetector(
    onTap: onPressed,
    child: Padding(
      padding: EdgeInsets.all(Spacing.md),
      child: Text(label),
    ),
  ),
);

// ✅ After: native widget
FilledButton(
  onPressed: onPressed,
  style: FilledButton.styleFrom(
    padding: EdgeInsets.all(Spacing.md),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
  ),
  child: Text(label),
);
```

---

## Related Files

- `standards/flutter-state-management.md`
- `~/.config/opencode/context/development/concepts/flutter-ui-patterns.md`
