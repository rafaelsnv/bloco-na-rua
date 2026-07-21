<!-- Context: project-intelligence/lookup/routes | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Routes Catalog

**Core Concept**: ~15 routes via `go_router` v17. Most use slide transition + per-page `BlocProvider`.

---

## Constants (from `lib/routing/routes.dart`)

| Constant             | Path                  | Notes                            |
| -------------------- | --------------------- | -------------------------------- |
| `Routes.home`         | `/`                    | Dashboard                        |
| `Routes.login`        | `/login`               | No slide transition              |
| `Routes.register`     | `/register`            | No slide transition              |
| `Routes.carnivalBlock`| `/carnival-block`      | Base for `/{id}` detail          |
| `Routes.createBlock`  | `/create-block`        |                                  |
| `Routes.editBlock`    | `/edit-block`          | Base for `/{id}` detail          |
| `Routes.joinBlock`    | `/join-block`          | Modal                            |
| `Routes.members`      | `/members`             |                                  |
| `Routes.meeting`      | `/meeting`             | Base for `/{id}` detail          |
| `Routes.userMeetings` | `/user-meetings`       |                                  |
| `Routes.editMeeting`  | `/edit-meeting`        | Base for `/{id}` detail          |
| `Routes.createMeeting`| `/create-meeting`      | Base for `/:blockId` detail      |
| `Routes.meetingPresences`| `/meeting-presences` | TBD                              |
| `Routes.profile`      | `/profile`             |                                  |
| `Routes.settings`     | `/settings`            |                                  |
| `Routes.notFound`     | `/404`                 | Default not-found route          |
| `Routes.error`        | `/error`               | Default error route              |

> Detail paths are built as `'${Routes.meeting}/:id'` etc.

---

## Auth-Aware Routes

`redirect()` in `router.dart`:

```dart
if (!sessionValid && location != Routes.register) return Routes.login;
if (sessionValid && [login, register].contains(location)) return Routes.home;
return null;  // no redirect
```

`refreshListenable: authRepository` → logout triggers re-evaluation.

---

## Detail Routes (with path parameter)

| Path                          | Path parameter | Cubit Created                              |
| ----------------------------- | -------------- | ------------------------------------------ |
| `${Routes.carnivalBlock}/:id`  | `id` (int)       | `BlockDetailsCubit(blockId)`                |
| `${Routes.meeting}/:id`        | `id` (int)       | `MeetingDetailsCubit(meetingId)`            |
| `${Routes.editMeeting}/:id`    | `id` (int)       | `EditMeetingCubit(meetingId)`               |
| `${Routes.editBlock}/:id`      | `id` (int)       | `EditBlockCubit(carnivalBlockId)`           |
| `/create-meeting/:blockId`     | `blockId` (int)  | `CreateMeetingCubit(blockId)`               |
| `/add-member/:blockId`         | `blockId` (int)  | `AddMemberCubit(blockId)`                   |

---

## Routes WITHOUT Slide Transition

- `/login` (auth gate UX, no slide)
- `/register` (auth gate UX, no slide)
- `/404` and `/error` (special-case UX)

---

## Adding a New Route

1. Add constant in `lib/routing/routes.dart`
2. Add a `GoRoute` in `lib/routing/router.dart`:
   ```dart
   GoRoute(
     path: Routes.myFeature,
     pageBuilder: (context, state) => _buildPageWithSlideTransition(
       context: context,
       state: state,
       child: BlocProvider(
         create: (context) => MyCubit(...),
         child: const MyScreen(),
       ),
     ),
   ),
   ```
3. If path needs a parameter, use `${Routes.myBase}/:id` and parse `state.pathParameters['id']!`
4. Update this catalog

---

## Reference

- `lib/routing/router.dart` — full route list (~320 lines)
- `lib/routing/routes.dart` — path constants
- `examples/router-slide-transition.md` — transition details
- `go_router` docs: https://pub.dev/packages/go_router
