<!-- Context: standards/readme | Priority: medium | Version: 1.0 | Updated: 2026-07-03 -->

# Standards — Universal Standards Overlay

> This directory overlays universal development standards onto the local project. It is NOT project-specific — no BlocoNaRua entities, carnival blocks, or app-domain content lives here.

## Quick Reference

- **Purpose**: Universal standards overlay for BlocoNaRua — referenced from global, with local project-specific overrides documented
- **Strategy**: Hybrid merge (Option F) — reference stable global, copy+sanitize contaminated files, document local overrides
- **Start here**: `navigation.md` for structure; then `references.md` (links) or `overrides.md` (decisions)
- **Last updated**: 2026-07-03 (merge creation date)
- **Total files**: 6 (475 lines)

## What This Is

A **universal standards overlay** that merges global opencode standards with local project decisions. Global standards at `~/.config/opencode/context/` are slow-evolving and apply to all projects. Local overrides capture project-specific deviations.

**Strategy**: Option F — Hybrid Merge (reference + copy + override).

## Merge Strategy

| Source | Strategy | Rationale |
|--------|----------|-----------|
| Stable global standards | **Reference** | Slow-evolving; always current via path reference |
| Contaminated global files | **Copy + sanitize** | Strip project-specific leaks before local adoption |
| Local decisions that override global defaults | **Document in overrides.md** | Preserve traceability of why local wins |

### Three Tiers

1. **Referenced** (`references.md`) — stable global files linked, not copied. Auto-track global on change.
2. **Copied + sanitized** — global files with `contaminated: true` markers are purified and stored locally.
3. **Overridden** (`overrides.md`) — documented local decisions that diverge from global defaults.

## Update Cadence

| File Type | Update Rule |
|-----------|-------------|
| Referenced (global linked) | **Do NOT auto-sync**; re-validate on global context version bumps; manual review per change |
| Copied (sanitized snapshot) | Snapshot at creation date; update only when global source changes significantly |
| Overrides | **Manual only**; project team decides when a local override should change |

**Rule**: Never auto-sync referenced global files. Always review manually — global changes may introduce patterns that conflict with local decisions.

## How to Read

1. **`navigation.md`** — structure overview and quick routes
2. **`README.md`** — this file (strategy + cadence)
3. **`references.md`** — link table to all stable global standards
4. **`overrides.md`** — local decisions that override global defaults
5. **`flutter-state-management.md`** — specialized Flutter state patterns
6. **`flutter-ui-patterns.md`** — specialized Flutter UI patterns

## Related Files

- **Root navigation**: `navigation.md` (parent context entry point)
- **Project intelligence**: `project-intelligence/navigation.md` (BlocoNaRua-specific context)
- **Paths config**: `paths.json` (local/global path mappings for @ references)
- **Global standards**: `~/.config/opencode/context/core/standards/` (upstream source)
