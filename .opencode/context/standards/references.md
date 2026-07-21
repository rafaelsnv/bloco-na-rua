<!-- Context: standards/references | Priority: medium | Version: 1.0 | Updated: 2026-07-03 -->

# Standards References (Universal)

> Reference table to universal standards living at `~/.config/opencode/context/`.
> Strategy: link, don't copy. These files are stable and may be re-read from global at any time.

## Quick Reference

- **Purpose**: Link table to global standards — no content duplication
- **Notation**: Use `@~/...` in agent prompts, or read directly via `paths.json` resolution
- **Update Cadence**: Referenced files are snapshots; global updates flow on next agent read
- **Conflict Note**: `dart.md` has a sealed-class conflict with local — see `overrides.md`

## Reference Table

| Path | Category | Summary |
|------|----------|---------|
| @~/.config/opencode/context/core/standards/code-quality.md | Code Quality | Universal patterns: modular, functional, maintainable; pure functions, immutability |
| @~/.config/opencode/context/core/standards/dart.md | Dart | ⚠️ CONFLICT: Sealed class state pattern vs local plain Equatable — see `overrides.md` |
| @~/.config/opencode/context/core/standards/test-coverage.md | Testing | AAA pattern, coverage tiers, pure function testing, Flutter/Dart testing with mocktail |
| @~/.config/opencode/context/core/standards/documentation.md | Documentation | Golden rule, what/how to document, README structure, API docs |
| @~/.config/opencode/context/core/standards/security-patterns.md | Security | Error handling, validation, logging, never expose secrets |
| @~/.config/opencode/context/core/standards/code-analysis.md | Code Analysis | Analysis process, report format, be thorough/objective/specific/actionable |
| @~/.config/opencode/context/core/standards/navigation.md | Standards Nav | Core standards directory index and loading strategy |
| @~/.config/opencode/context/development/principles/clean-code.md | Clean Code | Meaningful names, single responsibility, DRY, error handling |
| @~/.config/opencode/context/development/principles/api-design.md | API Design | REST/GraphQL patterns, versioning, authentication, best practices |
| @~/.config/opencode/context/core/essential-patterns.md | Essential Patterns | Core philosophy, critical patterns, modular/functional/maintainable |

## How to Read

Use the `@~/...` notation in agent prompts to reference global files, or read directly:

```bash
# Example: Load dart.md via paths.json resolution
@~/.config/opencode/context/core/standards/dart.md
```

Paths are resolved relative to `~/.config/opencode/context/` via the global `paths.json`.

## Update Cadence

Referenced files are **snapshots** at time of merge (2026-07-03). Global updates to:
- `core/standards/` — flow in on next agent read session
- `development/principles/` — flow in on next agent read session

Local overrides in `overrides.md` take precedence when conflicts exist.

## Related Files

- [navigation.md](navigation.md) — Standards directory navigation
- [README.md](README.md) — Entry point and merge strategy
- [overrides.md](overrides.md) — Local decisions that diverge from global defaults
- [flutter-state-management.md](flutter-state-management.md) — Sanitized state management patterns
- [flutter-ui-patterns.md](flutter-ui-patterns.md) — Sanitized UI patterns
