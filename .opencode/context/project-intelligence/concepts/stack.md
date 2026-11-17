---
provenance: bilbos.Desktop.Main
contaminated: true
audit_date: 2026-07-01
---

<!-- Context: project-intelligence/concepts/stack | Priority: critical | Version: 2.0 | Updated: 2026-11-17 -->

# Tech Stack - Flutter Mobile (Bloco na Rua)

**Core Concept**: Flutter mobile application for managing carnival blocks (blocos de rua): authentication, block/member/meeting management, and attendance control, backed by Supabase auth and a REST API.

---

## Primary Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Framework | Flutter 3.x mobile | Android-first (see README prerequisites) |
| Language | Dart 3.x, null-safe | |
| Backend/Auth | Supabase | Email/password auth, `.env` config |
| State | flutter_bloc (Cubit) | AuthCubit + UI state |
| DI | provider | Repositories, API clients (NOT flutter_modular) |
| Navigation | go_router | Auth guards, auto-redirect on auth state |
| Entities | freezed | Immutable data classes + json_serializable |
| HTTP | dio | REST client for `/api/v1/` endpoints |
| Errors | result_dart | Success/Failure functional error handling |

---

## Minimal Example

Cubit pattern used across the app:

```dart
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(AuthInitial());
  final AuthService _authService;

  Future<Result<Unit>> login(String email, String password) async {
    emit(AuthLoading());
    return _authService.login(email, password); // result_dart Result
  }
}
```

---

## Key Points

1. **Mobile only** — no desktop/web targets; Android SDK required for dev
2. **Supabase** for auth; REST backend for domain data (meetings, blocks, members)
3. **Code generation** required: `build_runner build` for `.freezed.dart`/`.g.dart`
4. **Session persistence** via SharedPreferences

---

## Reference

- Full stack list: `README.md` ("Built Using" section)
- Environment setup: `README.md` (`.env` variables)
- Pinned versions: `pubspec.yaml`
