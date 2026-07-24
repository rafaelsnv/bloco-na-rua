# Bloco na Rua

<p align="center">
  <a href="" rel="noopener">
  <img width=200px height=200px src="https://i.imgur.com/6wj0hh6.jpg" alt="Project logo">
  </a>
</p>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

## About

**Bloco na Rua** is a Flutter mobile application for managing carnival blocks (blocos de rua). It allows users to:

- 🔐 **Authentication** - Login/register with email and Supabase auth
- 📦 **Manage Carnival Blocks** - Create, view, and manage bloco information
- 👥 **Member Management** - View and manage block members
- 📅 **Meeting Management** - Create, edit, delete meetings
- ✅ **Attendance Control** - Mark and view meeting presences

## Architecture

Clean Architecture with unidirectional data flow:

```
UI Layer (Screens, Widgets, Cubits)
    ↓
Domain Layer (Use Cases, Entities)
    ↓
Data Layer (Repositories, API Clients, Services)
```

### State Management
- **Provider** for dependency injection (repositories, API clients)
- **flutter_bloc (Cubit)** for AuthCubit and UI state
- **go_router** for navigation with auth guards

---

## Getting Started

### Prerequisites

- Flutter 3.x SDK
- Dart 3.x
- Android SDK (for Android development)
- Supabase account (backend auth)

### Environment Setup

Create a `.env` file in the project root:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
API_URL=your_backend_api_url
```

### Installation

```bash
# Install dependencies
flutter pub get

# Generate freezed and json_serializable files
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Running Tests

```bash
# Widget tests
flutter test

# Integration tests (requires emulator/device)
flutter test integration_test/app_test.dart -d <device_id>
```

---

## Project Structure

```
lib/
├── main.dart                 # Entry point, Supabase init
├── main_app.dart             # MaterialApp.router with AuthCubit
├── config/
│   └── dependencies.dart    # Provider DI setup
├── core/                     # Base interfaces, utilities
├── data/
│   ├── repositories/         # Repository implementations
│   └── services/
│       ├── api/             # API clients (base, meetings, blocks, etc.)
│       └── auth/            # Auth service
├── domain/
│   ├── entities/            # Freezed entities (Meeting, Block, Member, etc.)
│   └── use_cases/           # Business logic use cases
├── routing/
│   ├── router.dart          # GoRouter with auth redirect
│   └── routes.dart          # Route constants
└── ui/
    ├── auth/                # Login, SignUp screens
    ├── carnivalBlock/       # Block CRUD screens
    ├── home/                # Home screen with blocks/meetings
    ├── meetings/            # Meeting screens (create, edit, details)
    └── members/            # Members list screen
```

---

## Key Features

### Authentication
- Email/password login via Supabase
- Auto-redirect based on auth state
- Persistent session via SharedPreferences

### Block Management
- Create new carnival blocks with name and image
- View block details with member list
- Invite codes for block sharing

### Meeting Calendar
- View weekly meetings on home screen
- Create meetings with date/time picker
- Edit and delete meetings

### Attendance
- Mark presence at meetings
- View presence list for each meeting

---

## API Integration

The app communicates with a REST backend at `/api/v1/`:

| Endpoint | Description |
|----------|-------------|
| `GET/POST /api/v1/Meetings` | Meeting CRUD |
| `GET /api/v1/Meetings/block/{blockId}` | Meetings by block |
| `POST/GET/DELETE /api/v1/MeetingPresences` | Attendance control |
| `GET /api/v1/CarnivalBlocks` | Block management |
| `GET /api/v1/CarnivalBlockMembers/block/{blockId}` | Block members |
| `GET /api/v1/Members/{id}/blocks` | User's blocks |

---

## Development

### Code Generation

```bash
# Regenerate .freezed.dart and .g.dart files
flutter pub run build_runner build --delete-conflicting-outputs
```

### Analysis

```bash
# Analyze Dart code
flutter analyze
dart analyze

# Format code
dart format .
```

### Android Configuration

Key settings in `android/app/build.gradle.kts`:
- `ndkVersion` - Must match integration_test requirements (currently 28.2.13676358)

Key settings in `android/app/src/main/AndroidManifest.xml`:
- `android:enableOnBackInvokedCallback="true"` - Enable Android 14+ back gesture

---

## Built Using

- **Flutter** - UI framework
- **Dart** - Language
- **Supabase** - Authentication
- **go_router** - Navigation
- **flutter_bloc** - State management
- **provider** - Dependency injection
- **freezed** - Immutable data classes
- **dio** - HTTP client
- **result_dart** - Functional error handling

---

## License

MIT License
