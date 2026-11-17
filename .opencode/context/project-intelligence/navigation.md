<!-- Context: project-intelligence/navigation | Priority: critical | Version: 1.4 | Updated: 2026-11-17 -->

# Project Intelligence Navigation

**Purpose**: Quick overview of available project intelligence files.
**Last Updated**: 2026-11-17

## Quick Routes

| File | Description | Priority |
|------|------------|----------|
| [technical-domain.md](./technical-domain.md) | Tech stack, architecture, patterns | critical |
| [business-domain.md](./business-domain.md) | Carnival block management domain | high |

## Deep Dives

| Category | File | Description | Priority |
|----------|------|------------|----------|
| Naming | [technical-naming.md](./technical-naming.md) | File/class/member naming conventions | high |
| API | [technical-api-pattern.md](./technical-api-pattern.md) | API client patterns | high |
| Components | [technical-component-pattern.md](./technical-component-pattern.md) | State/Cubit/Screen patterns | high |
| Design System | [lookup/design-tokens.md](./lookup/design-tokens.md) | "Fireworks on Velvet" token map + invariants | high |

## Examples (project-intelligence/examples/)

| File | Description | Priority |
|------|------------|----------|
| [module-pattern.md](./examples/module-pattern.md) | Feature wiring: Provider DI + GoRouter + BlocProvider | high |
| [state-pattern.md](./examples/state-pattern.md) | Status enum + single Equatable state class | high |
| [model-pattern.md](./examples/model-pattern.md) | Freezed sealed entity extending EntityBase | high |
| [widget-pattern.md](./examples/widget-pattern.md) | Token-driven widgets (AppButton, AppColors.inkFor) | high |
| [resumable-cubit-pattern.md](./examples/resumable-cubit-pattern.md) | Auto-refresh cubit on app resume | high |

## Quick Reference

**Tech Stack**: Flutter 3.8.1 + Dart ^3.8.1
**State Management**: Cubit + flutter_bloc + ResumableCubitMixin
**Architecture**: Clean Architecture (data/domain/ui layers)
**API**: Dio + result_dart (Success/Failure monad)
**Routing**: GoRouter with StatefulShellRoute.indexedStack
**Design**: "Fireworks on Velvet" theme (Violet #7C3AED primary)
**Domain**: Carnival block management (Bloco na Rua)

## Getting Started

1. Read `technical-domain.md` for technical patterns
2. Read `business-domain.md` for project context
3. Use patterns when generating code
4. Update context when patterns change
