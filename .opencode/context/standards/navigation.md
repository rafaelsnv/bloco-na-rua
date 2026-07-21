<!-- Context: standards/nav | Priority: high | Version: 1.0 | Updated: 2026-07-03 -->

# Standards Navigation

> Universal standards overlay — stable global references with local overrides. Start here.

## Quick Reference

| Need | File | What You Get |
|------|------|--------------|
| Understand this directory | `README.md` | Strategy, cadence, how to read |
| All global references | `references.md` | Link table to stable global standards |
| Local vs global decisions | `overrides.md` | Documented deviations from global defaults |
| Flutter state patterns | `flutter-state-management.md` | Sanitized state management guide |
| Flutter UI patterns | `flutter-ui-patterns.md` | Sanitized UI/component guide |
| Structure overview | `navigation.md` | This file — directory index |

## File Tree

```
standards/
├── navigation.md              # This file
├── README.md                 # Entry point + strategy
├── references.md             # Global standards link table
├── overrides.md              # Local decision overrides
├── flutter-state-management.md  # Sanitized Flutter state
└── flutter-ui-patterns.md    # Sanitized Flutter UI
```

## File Descriptions

| File | Purpose |
|------|---------|
| `README.md` | What this directory is; Option F merge strategy; update cadence |
| `references.md` | Stable global standards (referenced, not copied) |
| `overrides.md` | Local project decisions that diverge from global defaults |
| `flutter-state-management.md` | Flutter state patterns (sanitized copy from global) |
| `flutter-ui-patterns.md` | Flutter UI/component patterns (sanitized copy from global) |

## How to Read

1. **Start here** → `navigation.md` (this file) for structure overview
2. **Entry point** → `README.md` to understand the merge strategy
3. **Stable references** → `references.md` for global standards link table
4. **Deviations** → `overrides.md` for local decisions that override global defaults
5. **Specialized** → `flutter-state-management.md` or `flutter-ui-patterns.md` as needed

## Related Files

- **Root nav**: `navigation.md` (parent — links to this directory)
- **Global standards**: `~/.config/opencode/context/core/standards/` (source of truth for universal patterns)
- **Project intelligence**: `project-intelligence/navigation.md` (BlocoNaRua-specific overrides)
- **Paths config**: `paths.json` (local vs global path mappings)
