<!-- Context: development/guides/flutter-bloc-patterns | Priority: high | Version: 2.0 | Updated: 2026-06-14 -->

# Guide: Cubit Partial State Update Pattern

**Purpose**: Update a single item within a list without replacing the entire state.

**Use Case**: When you need to modify one event in a test's events list, or update one test in openTests.

## Pattern: updateEvent() Method

```dart
void updateEvent(int testIndex, int eventIndex, DeviceEvent event) {
  final test = state.openTests[testIndex];
  final events = [...test.events];  // Create new list copy
  events[eventIndex] = event;       // Update specific item

  // Create new test with updated events
  final updatedTest = test.copyWith(events: events);

  // Replace only the modified test, keep others unchanged
  emit(state.copyWith(
    openTests: [
      ...state.openTests.sublist(0, testIndex),
      updatedTest,
      ...state.openTests.sublist(testIndex + 1),
    ],
  ));
}
```

**Key Steps**:
1. Get reference to item at index
2. Create shallow copy of the list
3. Update the specific index
4. Create new parent object with updated list
5. Build new state with only changed item replaced

**Benefits**:
- Immutability preserved
- Only what changed is new
- Other items stay referentially equal
- Triggers UI update via Equatable comparison

**Alternative: Using map**:
```dart
final newTests = state.openTests.asMap().entries.map((entry) {
  return entry.key == testIndex
      ? entry.value.copyWith(events: updatedEvents)
      : entry.value;
}).toList();
emit(state.copyWith(openTests: newTests));
```

---

## Screen Pattern with BlocProvider

```dart
class MyFeatureScreen extends StatefulWidget {
  const MyFeatureScreen({super.key, required this.featureId});
  @override State<MyFeatureScreen> createState() => _MyFeatureScreenState();
}

class _MyFeatureScreenState extends State<MyFeatureScreen> {
  @override Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MyFeatureCubit(repo: ctx.read<IMyFeatureRepository>()),
      child: BlocConsumer<MyFeatureCubit, MyFeatureState>(
        listener: (ctx, state) {
          if (state.status == MyFeatureStatus.success) {
            ctx.go(Routes.home);
          } else if (state.status == MyFeatureStatus.failure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
        builder: (ctx, state) => switch (state.status) {
          MyFeatureStatus.initial => const CircularProgressIndicator(),
          MyFeatureStatus.loading => const CircularProgressIndicator(),
          MyFeatureStatus.success => ListView.builder(
            itemCount: state.data?.length ?? 0,
            itemBuilder: (_, i) => MyFeatureTile(state.data![i]),
          ),
          MyFeatureStatus.failure => ErrorWidget(state.errorMessage ?? 'Error'),
        },
      ),
    );
  }
}
```

**Key Points**:
- `BlocProvider` creates Cubit with injected dependencies
- `BlocConsumer` handles both UI updates and side effects (navigation, SnackBars)
- `switch` on `state.status` enum (default) — exhaustive on enum values
- Access `state.data` / `state.errorMessage` directly via getters; nullable payloads handled at callsite
