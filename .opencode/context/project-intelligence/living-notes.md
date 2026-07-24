<!-- Context: project-intelligence/notes | Priority: high | Version: 3.2 | Updated: 2026-07-08 -->

# Living Notes — BlocoNaRua

> Active issues, technical debt, and open questions. Updated whenever status changes.

---

## Technical Debt

| Item                                                                | Impact                              | Priority | Mitigation                                    |
| ------------------------------------------------------------------- | ----------------------------------- | -------- | --------------------------------------------- |
| 8 Cubits call Repositories directly (no UseCase)                    | Bypasses orchestration layer        | Medium   | Extract UseCases on next refactor pass         |
| `shared_preferencies_service.dart` (sic) misspelled                  | Cosmetic                            | Low      | Rename in dedicated PR                          |
| No global 401 handler — app stays in `/home` after session expires  | UX issue                            | High     | Hook auth notification in `DioErrorInterceptor` |
| Inconsistent repository method names (`getByBlock` vs `getBlocksByMemberId`) | API confusion             | Medium   | Standardize to `getXByY(...)`                   |
| No automated tests in `test/` directory                             | Refactoring is risky                | High     | Start with HomeCubit (most-flow)               |
| ~~`profile_cubit` and `meeting_presences_cubit` use freezed for UI state~~ | ~~Violates 2025-08 "NO freezed for UI states" decision~~ | ~~Medium~~ | **Resolved 2026-07-02** — `decisions-log.md` §"Plain Class UI States" was revised to permit freezed for sealed unions with payload variants. See decisions entry for the audit table and exception scope. |
| `OnBackInvokedCallback` Android manifest warning | Cosmetic (Android log warning) | Low | Android manifest config — separate ticket |

---

## Open Questions

### Q1: Should 401 from REST API trigger auto-logout?

**Stakeholders**: Project lead
**Status**: Open
**Next action**: Add `if (e.response?.statusCode == 401) locator<IAuthRepository>().notifyListeners();` to `DioErrorInterceptor`

### Q2: Should we extract UseCases for write-side cubits?

**Stakeholders**: Project lead
**Status**: Deferred
**Context**: Currently `CreateMeetingCubit`, `EditMeetingCubit`, `AddMemberCubit`, `EditBlockCubit` call repos directly. Adding UseCases now would be a 2-3 day refactor with no immediate feature benefit.
**Trigger to revisit**: Any of these cubits needs cross-cutting concerns (cache invalidation, analytics, retry).

### Q3: When do we extract pt-BR strings to ARB files for i18n?

**Stakeholders**: Project lead
**Status**: Deferred until 3rd locale needed
**Trigger**: Add `Locale('es','')` or other Portuguese variants.

---

## Known Issues

### I1: `MeetingPresences` route returns the screen directly — no `BlocProvider`

**Reproduction**: Visit `/meeting-presences`
**Workaround**: None — feature incomplete
**Root Cause**: `MeetingPresencesCubit` EXISTS as a TODO scaffold (`lib/ui/meeting_presences/cubit/`) but is **not wired** in `lib/routing/router.dart` (line 270 carries the `// TO-DO` comment). Route currently returns `MeetingPresencesScreen()` directly.
**Fix Plan**: (1) Wire `BlocProvider<MeetingPresencesCubit>` in `router.dart`; (2) implement `IMeetingPresencesRepository` methods; (3) add `MeetingPresencesUseCase` (estimated 1 day)
**See**: `lookup/cubits.md` — `MeetingPresencesCubit` row
**Status**: Planned

### I2: `Settings` route returns the screen directly — `SettingsCubit` not wired

**Symptom**: `/settings` route loads but shows only theme toggle scaffold
**Root Cause**: `SettingsCubit` EXISTS (`lib/ui/settings/cubit/settings_cubit.dart` with `SettingsInitial` state) but is **not wired** in `lib/routing/router.dart`. Route currently returns `SettingsScreen()` directly.
**See**: `lookup/cubits.md` — `SettingsCubit` row
**Status**: Known — not in v1 scope

### I3: `meetings_repository.dart` not actually fetching `MembersEntity` for attendees

**Workaround**: Reading `meetings_api_client.dart` only — attendee resolution happens client-side
**Status**: Open

### I4: Two cubits use freezed UI states, contrary to `decisions-log.md` (2025-08)

**Files**: `lib/ui/profile/cubit/profile_cubit.freezed.dart`, `lib/ui/meeting_presences/cubit/meeting_presences_cubit.freezed.dart`
**See**: `lookup/cubits.md` (cubit catalog), `decisions-log.md` §"Plain Class UI States (Revised 2026-07-02)"
**Status**: **Resolved 2026-07-02** — the 2025-08 decision was revised to permit freezed for sealed unions with payload-carrying variants. `ProfileCubit`'s `_Loaded(member)` variant falls within exception scope; `MeetingPresencesCubit`'s use is currently gratuitous (single variant) and will be re-evaluated when real variants are added.

### I5: Backend API returns `"img"` placeholder for blocks without a cover photo

**Symptom**: `CarnivalBlocksEntity.carnivalBlockImage` (non-nullable `String`) is set to the bare placeholder `"img"`. Flows into `CachedNetworkImageProvider("img")` → `ArgumentError: No host specified in URI "img"` → escapes to `ImageResourceService` because `DecorationImage` has no `errorBuilder`.
**Discovered**: 2026-07-08 (live runtime, `dart_mcp_get_runtime_errors`, escalations 27→29).
**Frontend mitigation (DONE 2026-07-08)**: New `isValidImageUrl(...)` validator in `lib/ui/core/widgets/display/image_url_validator.dart` + 3 guarded callsites (`BlockCard`, `BlockDetailsScreen` cover image, `AppAvatar`). See `concepts/image-url-validation.md`.
**Backend fix options**:
  - **(a)** API returns `null` — preferred (falls through `isValidImageUrl` cleanly, removes placeholder from contract).
  - **(b)** API returns fully-qualified default URL (e.g., `https://cdn.example.com/blocks/default.png`).
  - **(c)** Frontend joins `MEDIA_BASE_URL` constant when API contract is path-only (e.g., `img/123.png`).
**See**: `decisions-log.md` (decision pending — add date + chosen option when resolved)
**Status**: Frontend defensive — backend contract decision pending.

### I6: 2x `GET /Members/uuid/{uuid}` race on app boot

**Reproduction**: Boot app with valid session; check `dart_mcp_get_app_logs` — observe 2x `GET /Members/uuid/{uuid}` per cold start.
**Root Cause**: Race between `IAuthRepository.refreshListenable` (router redirect) and `HomeCubit.loadHomeData()`. Both call `GetCurrentUserData` simultaneously; cache-miss path doesn't write back (code review H3). Current cache eliminates only 1 duplicate per render frame.
**Files**: `lib/data/repositories/auth/auth_repository.dart`, `lib/domain/use_cases/auth/get_current_user_data.dart`
**Fix**: Memoize `validateSession()` — follow-up approved but deferred.
**Status**: Open

### I7: Duplicate GET calls for blocks/blocks-list endpoints

**Reproduction**: Navigate home → block details → back → home; check `dart_mcp_get_app_logs`.
**Observed**: `GET /Members/4/blocks` fires 2x and `GET /CarnivalBlocks/1` fires 2x per navigation. Separate root cause from I6.
**Status**: Open — needs investigation

---

## Insights & Lessons Learned

### What Works Well
- **Single-file DI** (`dependencies.dart`) → easy to grep, easy to reason about
- **AsyncResult everywhere** → Cubits never `try/catch` for translation
- **pt-BR error catalog** (`error_messages.dart`) → consistent UX, easy to translate

### What Could Be Better
- **No naming convention test** → refactors may silently break (e.g., `getByX` → `getByY`)
- **No golden tests for screens** → visual regressions caught late
- **`getMeetingById` vs `getById` inconsistency** across repos (see technical debt)

### Lessons Learned
- **Freezed codegen is forgiving** but `.freezed.dart` files MUST be regenerated after rename, not just re-imported
- **SharedPreferences token storage** is fine for v1; revisit Keychain/EncryptedSharedPreferences if PII added
- **Don't add `flutter_driver` E2E tests before fixing the settings screen** — wasted effort

---

## Active Projects

| Project                  | Goal                                  | Owner         | Timeline          |
| ------------------------ | ------------------------------------- | ------------- | ----------------- |
| Extract UseCases pass    | Wrap direct-repo calls in UseCases    | Project lead  | Q3 2026           |
| 401 auto-logout          | Hook Dio interceptor to Auth notify   | Project lead  | This sprint       |
| Add HomeCubit tests      | 100% coverage on most-flowed cubit    | Project lead  | Next sprint       |
| MeetingPresences screen  | Finish the TODO route                 | Project lead  | Asap              |
| Backend "img" placeholder | Decide on (a)/(b)/(c) per I5; update `decisions-log.md` | Project lead | When API owner available |

---

## Archive (Resolved Items)

### Resolved: Supabase vs pure REST decision
- **Resolved**: 2025-08 (scaffold)
- **Resolution**: Hybrid — Supabase auth + REST for entities
- **Learnings**: Saved ~2 weeks; will revisit if RLS rules become painful

---

## Related Files

- `decisions-log.md` — Past decisions
- `business-tech-bridge.md` — Concept → code mapping
- `errors/dio-supabase-errors.md` — Known gotchas
