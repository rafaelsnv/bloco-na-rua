<!-- Context: project-intelligence/decisions | Priority: high | Version: 1.1 | Updated: 2026-11-19 -->

# Decisions Log

> Record major architectural and business decisions with full context. This prevents "why was this done?" debates.

## Quick Reference

- **Purpose**: Document decisions so future team members understand context
- **Format**: Each decision as a separate entry
- **Status**: Decided | Pending | Under Review | Deprecated

## Decision Template

```markdown
## [Decision Title]

**Date**: YYYY-MM-DD
**Status**: [Decided/Pending/Under Review/Deprecated]
**Owner**: [Who owns this decision]

### Context
[What situation prompted this decision? What was the problem or opportunity?]

### Decision
[What was decided? Be specific about the choice made.]

### Rationale
[Why this decision? What were the alternatives and why were they rejected?]

### Alternatives Considered
| Alternative | Pros | Cons | Why Rejected? |
|-------------|------|------|---------------|
| [Alt 1] | [Pros] | [Cons] | [Why not chosen] |
| [Alt 2] | [Pros] | [Cons] | [Why not chosen] |

### Impact
**Positive**: [What this enables or improves]
**Negative**: [What trade-offs or limitations this creates]
**Risk**: [What could go wrong]

### Related
- [Links to related decisions, PRs, issues, or documentation]
```

---

## Decision: [Title]

**Date**: YYYY-MM-DD
**Status**: [Status]
**Owner**: [Owner]

### Context
[What was happening? Why did we need to decide?]

### Decision
[What we decided]

### Rationale
[Why this was the right choice]

### Alternatives Considered
| Alternative | Pros | Cons | Why Rejected? |
|-------------|------|------|---------------|
| [Option A] | [Good things] | [Bad things] | [Reason] |
| [Option B] | [Good things] | [Bad things] | [Reason] |

### Impact
- **Positive**: [What we gain]
- **Negative**: [What we trade off]
- **Risk**: [What to watch for]

### Related
- [Link to PR #000]
- [Link to issue #000]
- [Link to documentation]

---

## Decision: Full ARB/i18n Migration with Error Markers

**Date**: 2026-11-19
**Status**: Decided
**Owner**: Team

### Context
User-facing strings were baked into widgets and, worse, into cubits/states which have no `BuildContext` — making localization impossible outside the widget layer.

### Decision
Migrate all of `lib/ui` to `AppLocalizations` via ARB (`lib/l10n/app_pt.arb` + `app_en.arb`, 267 keys, pt/en parity). Cubits/states carry typed markers (`AuthSuccessKind`, `BlockError`, `MeetingError`); screens localize via `extractUserMessage(error, context)`.

### Rationale
Cubits have no BuildContext, so they cannot resolve strings — markers are the only clean option. ARB is Flutter's native l10n mechanism.

### Alternatives Considered
| Alternative | Pros | Cons | Why Rejected? |
|-------------|------|------|---------------|
| Baked strings + translation shim later | Fast now | Unlocalizable cubit state, full rewrite later | Defers the problem |
| Strings passed through states | No markers needed | States become string-bags, test brittleness | Loses type safety |

### Impact
- **Positive**: pt/en parity, single source of truth, typed error handling
- **Negative**: every new string requires ARB key + regen (`flutter gen-l10n`)

### Related
- `concepts/localization.md`

---

## Decision: Session-Validity Cache in AuthRepository

**Date**: 2026-11-19
**Status**: Decided
**Owner**: Team

### Context
The go_router redirect called the network to validate the session on every navigation — slow, janky, and chatty.

### Decision
`AuthRepository._sessionValid` cache makes the redirect network-free, with single-flight `_validateSessionFuture` deduping concurrent checks. On a mid-session 401: `BaseApiClient.formatError` → `ApiError.isAuthFailure` → `AuthRepository.invalidateSession()` → `AuthListenable.notify()` triggers re-evaluation of the redirect.

### Rationale
Redirects must be synchronous/cheap; 401 is the authoritative invalidation signal.

### Alternatives Considered
| Alternative | Pros | Cons | Why Rejected? |
|-------------|------|------|---------------|
| Validate on every navigation | Always fresh | Network per navigation, visible lag | Cost/benefit fails |
| Periodic revalidation | Simple | Wasted calls, stale window remains | Unnecessary traffic |

### Impact
- **Positive**: Instant navigation, one validation flight at a time
- **Negative**: Stale-valid window until a 401 arrives (acceptable — API rejects first)

### Related
- `technical-domain.md` (API client patterns)

---

## Decision: AppTextColors Collapse + Border Contrast Fix

**Date**: 2026-11-19
**Status**: Decided
**Owner**: Team

### Context
AppTextColors had redundant `*Dark` twin variants; borders (borderLight #8B7FD6 / borderDark #8A94A6) failed WCAG non-text contrast.

### Decision
Collapse AppTextColors to ONE value per role; set border colors to pass ≥3:1 non-text contrast in both modes.

### Rationale
Fewer tokens = fewer wrong choices; ≥3:1 is the WCAG 1.4.11 requirement.

### Alternatives Considered
| Alternative | Pros | Cons | Why Rejected? |
|-------------|------|------|---------------|
| Keep twins, fix values only | Smaller diff | Two sources of truth persist | Redundancy remains |

### Impact
- **Positive**: Simpler token surface, accessible borders
- **Negative**: Callers referencing removed `*Dark` colors must migrate (done in audit)

### Related
- `lookup/design-tokens.md`

---

## Deprecated Decisions

Decisions that were later overturned (for historical context):

| Decision | Date | Replaced By | Why |
|----------|------|-------------|-----|
| [Old decision] | [Date] | [New decision] | [Reason] |

## Onboarding Checklist

- [ ] Understand the philosophy behind major architectural choices
- [ ] Know why certain technologies were chosen over alternatives
- [ ] Understand trade-offs that were made
- [ ] Know where to find decision context when questions arise
- [ ] Understand what decisions are pending and why

## Related Files

- `technical-domain.md` - Technical implementation affected by these decisions
- `business-tech-bridge.md` - How decisions connect business and technical
- `living-notes.md` - Current open questions that may become decisions
