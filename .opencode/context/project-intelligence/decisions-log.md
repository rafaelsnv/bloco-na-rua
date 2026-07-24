<!-- Context: project-intelligence/decisions | Priority: high | Version: 3.1 | Updated: 2026-07-02 -->

# Decisions Log — BlocoNaRua

> Architectural and product decisions with context. Updated whenever a meaningful choice is made.

---

## Hybrid Supabase + Custom REST Backend (2025-08, Decided)

**Owner**: Project lead

**Context**: Need authentication + business entity CRUD (CarnivalBlock, Meetings, Members).

**Decision**: Supabase = auth only (sign-in/sign-up/out/session); Custom REST via Dio for ALL business entities.

**Rationale**:
- Supabase auth is mature, free, saves ~2 weeks
- Business entities need complex queries (joins, custom roles) that don't fit Supabase RLS easily
- Future-proof: keeps entity CRUD under our control

**Alternatives**: Pure Supabase (RLS becomes complex) | Pure custom (auth is its own project) | Firebase (already chose Supabase)

**Impact**: ~2 weeks saved; must coordinate Supabase token → REST for auth-gated endpoints.

See: `concepts/supabase-vs-rest.md`, `concepts/dio-pipeline.md`

---

## Provider for Dependency Injection (2025-08, Decided)

**Owner**: Project lead

**Context**: Register ~15 dependencies (Dio, repos, use cases, cubits). Options: Modular, GetIt, Riverpod, Provider.

**Decision**: `package:provider` v6 + single `MultiProvider` in `main.dart` + one `dependencies.dart` file.

**Rationale**: Provider is the Flutter standard; single file = single source of truth; no annotation processing → faster builds; page-scoped cubits live in `router.dart`.

**Alternatives**: Modular (overkill) | GetIt (two systems) | Riverpod (learning curve)

**Impact**: Simple and debuggable; would need to switch if team exceeds ~10.

See: `examples/module-pattern.md`

---

## Freezed Entities Over Manual Classes (2025-08, Decided)

**Owner**: Project lead

**Context**: Entities need `copyWith`, `==`, `fromJson`, possibly sealed variants.

**Decision**: `@freezed sealed class XxxEntity extends EntityBase with _$XxxEntity` for all domain entities.

**Rationale**: Auto-generated `copyWith`, `==`, `hashCode`, `fromJson`; sealed unions for variants; one-shot codegen; consistent base (`EntityBase`).

**Alternatives**: Manual classes (boilerplate) | `equatable` only (no `copyWith`) | Dart 3 records (immature)

**Impact**: Less boilerplate; MUST regenerate after every entity change.

See: `concepts/freezed-entity.md`

---

## Plain Class UI States (NOT freezed) (2025-08, Decided — Revised 2026-07-02)

**Owner**: Project lead

**Context**: Cubit state classes also need `copyWith` and equality. Could use freezed like entities, OR plain + Equatable.

**Decision (revised 2026-07-02)**:

- **Default**: Plain class + `enum Status { initial, loading, success, failure }` + `Equatable` + manual `copyWith`. This is the preferred pattern and applies to most cubits.
- **Exception**: Freezed is permitted for cubits whose state is a **sealed union with payload-carrying variants** (e.g., `_Loaded(MembersEntity)`, `_Error(String message)`). The freezed union pattern expresses those variants more clearly than nested nullable fields on a plain class.
- **Avoid**: Freezed for single-state or flat cubits (no payload variants) — it adds codegen cost with no benefit.

**Original 2025-08 rationale (still valid for the default case)**: UI states are simpler; plain class is easier to log; codegen only runs on entity changes (faster dev loop).

**2026-07-02 revision rationale**: Two cubits already use freezed UI states (`ProfileCubit`, `MeetingPresencesCubit`); rather than re-implement them, recognize that freezed is appropriate when the state model is a real union. The exception scope is narrow and will not affect the majority of cubits (which are simple `enum Status` + single data field).

**Current freezed UI states in use** (audit, 2026-07-02):

| Cubit | State file | Variants | Justification |
| ----- | ---------- | -------- | ------------ |
| `ProfileCubit` | `lib/ui/profile/cubit/profile_state.dart` | `_Initial`, `_Loading`, `_Loaded(member: MembersEntity)`, `_Error(message: String)` | Payload-carrying union — fits exception scope ✓ |
| `MeetingPresencesCubit` | `lib/ui/meeting_presences/cubit/meeting_presences_state.dart` | `_Initial` (only — TODO scaffold per `lib/routing/router.dart` line 270) | Currently a single variant; freezed is gratuitous here — revisit when real variants are added |

**Alternatives considered (still rejected)**: freezed for ALL UI states (slower rebuild) | BuildReducer (extra complexity) | Plain class for ALL UI states (forces nullable fields on payload variants like `_Loaded`)

**Impact**: Two patterns now coexist (plain for simple cubits, freezed for union-shaped cubits). Onboarding should explain the distinction; the default is plain. Future cubits should choose based on state shape, not by convention.

See: `concepts/bloc-state-pattern.md`, `examples/state-pattern.md`, `living-notes.md` §I4 (now Resolved)

---

## `go_router` v17 (2025-09, Decided)

**Owner**: Project lead

**Context**: Need deep-link, redirects (auth), custom transitions, param parsing.

**Decision**: `go_router` v17 with one `GoRoute` per screen, custom slide transitions, `refreshListenable` tied to `IAuthRepository`.

**Rationale**: Declarative matches Cubit pattern; built-in redirect + refreshListenable; custom transitions via `CustomTransitionPage`.

**Alternatives**: Navigator 2.0 raw (verbose) | auto_route (codegen, only for ~50 routes)

**Impact**: Single `router.dart` file holds all routes; minor version updates may have breaking changes.

See: `examples/router-slide-transition.md`, `lookup/routes.md`

---

## pt-BR as Default Locale (2025-08, Decided)

**Owner**: Project lead

**Context**: Target users are Brazilian carnival block organizers.

**Decision**: `Locale('pt','BR')` primary; `Locale('en','')` secondary (framework-level only); error messages hardcoded pt-BR in `lib/core/error_messages.dart`; `brasil_fields` for CPF/CNPJ/phone.

**Rationale**: 100% of target users are BR; English kept minimal (framework) to avoid blocking international contributors.

**Alternatives**: slang i18n (overkill for 2 locales) | English-only (wrong audience)

**Impact**: Authentic UX for primary users; adding a 3rd locale requires extraction to ARB files.

See: `concepts/device-types.md`, `guides/error-to-user-message.md`

---

## Archived Decisions

| Decision | Date | Replaced By | Reason |
| -------- | ---- | ----------- | ------ |
| (none yet) |    |             |        |

---

## Related

- `living-notes.md` — Open issues that may become decisions
- `business-domain.md` — Business context behind decisions
- `concepts/` — Per-decision deep dives
