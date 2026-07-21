<!-- Context: project-intelligence/nav | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# BlocoNaRua — Project Intelligence

> Mobile Flutter app for managing Brazilian carnival blocks. Read navigation first, then jump to the topic you need.

## Quick Routes

| Need                          | File                                            | Section                    |
| ----------------------------- | ----------------------------------------------- | -------------------------- |
| Understand the product        | `business-domain.md`                            | Problem, users, value      |
| Map product → code            | `business-tech-bridge.md`                       | Entities → use cases        |
| Architecture (Clean Arch)     | `concepts/architecture.md`                      | Layered flow, DI, routing  |
| Technology stack              | `concepts/stack.md`                             | Versions + reasoning        |
| Target devices                | `concepts/device-types.md`                      | Mobile-first, pt-BR       |
| Naming conventions            | `technical-naming.md`                           | Files, classes, files      |
| Component patterns            | `technical-component-pattern.md`                | Cubit / UseCase / Repo     |
| API + backend patterns        | `technical-api-pattern.md`                      | Dio + Supabase hybrid      |
| Decisions log                 | `decisions-log.md`                              | Why we chose X over Y       |
| Active issues / debts         | `living-notes.md`                               | TODO, blockers              |
| MCP Dart tooling              | `mcp-tools-dart.md`                             | dart_mcp capabilities       |
| MCP Figma tools               | `mcp-tools-figma.md`                            | Design sync                 |

## Function-Based Index

```
project-intelligence/
├── navigation.md              # This file
├── business-domain.md         # Product context
├── business-tech-bridge.md    # Domain → implementation map
├── technical-domain.md        # System overview
├── decisions-log.md           # Architecture decisions
├── living-notes.md            # Active work, debts, questions
├── mcp-tools-dart.md          # Dart MCP reference
├── mcp-tools-figma.md         # Figma MCP reference
├── technical-naming.md        # Naming conventions
├── technical-api-pattern.md   # REST/Supabase patterns
├── technical-component-pattern.md  # Component layering
├── concepts/                  # Core concepts (one idea per file)
│   ├── architecture.md
│   ├── stack.md
│   ├── device-types.md
│   ├── bloc-state-pattern.md
│   ├── dio-pipeline.md
│   ├── result-handling.md
│   ├── freezed-entity.md
│   └── supabase-vs-rest.md
├── examples/                  # Working code snippets
│   ├── state-pattern.md
│   ├── widget-pattern.md
│   ├── module-pattern.md      # Provider DI (NOT Modular)
│   ├── dio-error-translation.dart
│   ├── home-feature-flow.md
│   └── router-slide-transition.md
├── guides/                    # Step-by-step tasks
│   ├── adding-feature.md
│   ├── error-to-user-message.md
│   ├── error-display-strategy.md
│   └── i18n-ptbr-setup.md
├── lookup/                    # Quick reference tables
│   ├── cli-commands.md
│   ├── naming-conventions.md
│   ├── ui-organization.md
│   ├── entities.md
│   ├── use-cases.md
│   ├── routes.md
│   └── cubits.md
└── errors/                    # Known issues & gotchas
    ├── common-errors.md
    └── dio-supabase-errors.md
```

## Onboarding Path

1. **Read** `business-domain.md` → understand the *why*
2. **Read** `concepts/architecture.md` → understand the *how* (layers)
3. **Read** `concepts/stack.md` → learn the moving parts
4. **Skim** `lookup/` files → catalog of entities/routes/cubits
5. **Bookmark** `living-notes.md` → current state of work

## Maintenance

- Update `living-notes.md` weekly (current issues, debts)
- Add to `decisions-log.md` whenever an architectural choice is made
- New entities → add to `lookup/entities.md` AND `domain/entities/` map
- New routes → add to `lookup/routes.md` AND `routing/routes.dart`

**Archive**: Old versions kept at `.opencode/.archive/project-intelligence/` for git diff history.
