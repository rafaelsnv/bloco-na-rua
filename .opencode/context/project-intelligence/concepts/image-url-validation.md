<!-- Context: project-intelligence/concepts/image-url-validation | Priority: high | Version: 1.0 | Updated: 2026-07-08 -->

# Image URL Validation — `isValidImageUrl(...)`

**Core Concept**: A pure-Dart validator guards every image provider call against malformed URLs (e.g., backend returning the placeholder `"img"`). This is the ONLY way to prevent `CachedNetworkImageProvider("img")` from crashing — `DecorationImage` has **no** `errorBuilder` API, so bad data must never reach the provider.

> Adopted 2026-07-08 after a runtime crash captured via `dart_mcp_get_runtime_errors` (3 escalations, `errorsSinceReload: 27→29`). Source: `.tmp/.archive/2026-07-08/sessions/2026-07-03-design-system/HANDOFF.md §16/§17`.

---

## The Validator

**File**: `lib/ui/core/widgets/display/image_url_validator.dart`

```dart
bool isValidImageUrl(
  String? url, {
  Set<String> allowedSchemes = const {"http", "https"},
})
```

Rejects: `null` / empty / whitespace / relative paths (`"img"`, `"img/foo.png"`) / protocol-relative URLs (`"//cdn.example.com/x.png"`) / non-http(s) schemes / URLs missing a host. Returns `true` only for absolute http(s) URLs with a parseable host.

---

## When to Use

Call `isValidImageUrl(...)` before passing any user/entity-supplied URL to:

- `CachedNetworkImageProvider(...)` — unsafe; errors fire **asynchronously** inside the image cache, escaping any `errorBuilder`.
- `CachedNetworkImage(imageUrl: ...)` — safer (has `errorWidget`), but still wastes a network request on a known-bad URL.
- `NetworkImage(...)` — same as `CachedNetworkImageProvider`.

## When NOT to Use

- Hardcoded asset URLs (`AssetImage("assets/icons/foo.png")`) — not URLs.
- Data URIs unless `allowedSchemes: {"http", "https", "data"}` is explicitly passed.
- File paths or filenames that aren't URLs.

---

## Pattern (PREFER vs AVOID)

```dart
// AVOID: passing a potentially bad URL to DecorationImage — no errorBuilder
Container(
  decoration: BoxDecoration(
    image: DecorationImage(image: CachedNetworkImageProvider(block.coverUrl)),
  ),
)

// PREFER: guard with the validator, fall back to a static placeholder
if (isValidImageUrl(block.coverUrl))
  CachedNetworkImage(imageUrl: block.coverUrl, errorWidget: (ctx, _, __) => /* fallback */)
else
  Container(color: AppColors.surfaceVariant, child: Icon(Icons.celebration_rounded))
```

---

## Protected Callsites (3)

| # | File | Originally | Now |
|---|------|------------|-----|
| 1 | `lib/ui/core/widgets/cards/block_card.dart` | Unsafe `BoxDecoration.image` + `DecorationImage` | Guarded `if (isValidImageUrl(...))` + colored `Container` fallback with `Icons.celebration_rounded` |
| 2 | `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` | `if (hasImage)` flag (only checked non-empty) | Inline `if (isValidImageUrl(carnivalBlock.carnivalBlockImage))` at cover-image use site |
| 3 | `lib/ui/core/widgets/display/app_avatar.dart` | `imageUrl == null \|\| imageUrl!.trim().isEmpty` (caught null/empty but not `"img"`) | `!isValidImageUrl(imageUrl)` so backend placeholders fall back to initials/icon |

---

## Why Not Alternatives?

| Alternative | Why rejected |
|-------------|-------------|
| `FlutterError.onError` global handler | Masks the issue; users still see broken `Container` background |
| `try/catch` around `CachedNetworkImageProvider(...)` | Error fires **asynchronously** in the cache, not in the constructor |
| `errorBuilder` on `DecorationImage` | **`DecorationImage` has no errorBuilder API** — the only way to avoid the throw is to never pass a bad URL |
| Catch upstream in `image_provider.dart` | Flutter SDK — out of our control |

---

## Backend Follow-up (separate ticket)

API returns `"img"` (rather than `null` or `""`) for blocks without a cover photo. Frontend is now defensive; contract should be cleaned up at the source. Options:

- **(a)** Backend returns `null` — preferred (falls through `isValidImageUrl` cleanly).
- **(b)** Backend returns a fully-qualified default placeholder URL (e.g., `https://cdn.example.com/blocks/default.png`).
- **(c)** Frontend joins a known `MEDIA_BASE_URL` constant when the API contract is path-only.

See `living-notes.md` §I5.

---

## Reference

- `lookup/widgets-api.md` — `AppAvatar` / `BlockCard` constructors
- `errors/common-errors.md` — image-loading error catalog
- `living-notes.md` §I5 — backend ticket
- `.tmp/.archive/2026-07-08/sessions/2026-07-03-design-system/HANDOFF.md` §16/§17 — full bug story