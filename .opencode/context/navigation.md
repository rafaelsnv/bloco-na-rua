<!-- Context: root-navigation | Priority: critical | Version: 1.1 | Updated: 2026-07-03 -->

# BlocoNaRua — OpenCode Context Root

> Project intelligence for the BlocoNaRua Flutter mobile app. Start here.

## Structure

```
.opencode/context/
├── navigation.md              # This file
├── paths.json                 # Context path config (local + global)
└── project-intelligence/      # Domain, architecture, conventions
    └── navigation.md          # Project-intelligence index (read first!)
└── standards/                 # Universal standards overlay (referenced from global)
    └── navigation.md          # Standards index — references, overrides, sanitized patterns
```

## Quick Start

1. Open `.opencode/context/project-intelligence/navigation.md`
2. Follow the **Onboarding Path**: business-domain → architecture → stack → lookup
3. Bookmark `living-notes.md` for current work
4. For universal Flutter/Dart standards, see `standards/navigation.md` (referenced from global)

## Archive

Old migrated context versions are kept at:
```
.opencode/.archive/project-intelligence/
```

These are pre-July-2026 versions from a generic Flutter template that have been
replaced by BlocoNaRua-specific context. Kept for git diff history only.

## Project Info

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Project       | BlocoNaRua                              |
| Domain        | Brazilian carnival block management     |
| Stack         | Flutter mobile, Dio + Supabase hybrid   |
| Primary lang  | pt-BR (default), en (secondary)         |
| Source root   | `lib/` (NOT `lib/src/`)                |
| Architecture  | Clean Architecture (UI/Domain/Data)    |

See `project-intelligence/` for full breakdown.
