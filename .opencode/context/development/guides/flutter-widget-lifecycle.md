---
provenance: bilbos.Desktop.Main
contaminated: true
audit_date: 2026-07-01
---

<!-- Context: development/guides/flutter-widget-lifecycle | Priority: medium | Version: 1.0 | Updated: 2026-06-10 -->

# Guide: didUpdateWidget for State Reset on Prop Change

**Purpose**: Detect when widget props change and reset internal state accordingly.

**Use Case**: When `currentItem` changes (e.g., user switches between items in a list), internal widget state must be cleared to avoid stale data.

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.currentItem != widget.currentItem) {
    _pendingOperations.clear();
    _pendingComment = null;
    _isEditModeActive = false;
    _showSuccessCard = false;
    _visualChangeApplied = false;
    _originalDataPoints.clear();
  }
}
```

**Key Points**:
- `didUpdateWidget` called when widget's props change
- Compare `oldWidget.prop` vs `widget.prop` to detect changes
- Reset state variables that depend on prop values
- Call `super.didUpdateWidget()` first

**When to Use**:
- Widget has internal state tied to props
- Props are objects that may be replaced (not same reference)
- State needs clean slate when prop changes

**Example**: Edit overlay widget must reset `_pendingOperations` when the current item changes.
