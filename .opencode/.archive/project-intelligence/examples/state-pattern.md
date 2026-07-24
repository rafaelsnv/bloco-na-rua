<!-- Context: project-intelligence/examples/state-pattern | Priority: high | Version: 1.0 | Updated: 2026-05-04 -->

# State Pattern Example

**Example**: Cubit + sealed State classes for feature state management.

---

## Cubit Pattern

```dart
class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit({required IFeatureService featureService})
      : _featureService = featureService, super(FeatureInitial());

  final IFeatureService _featureService;

  Future<void> loadFeature() async {
    emit(FeatureLoading());
    try {
      final data = await _featureService.getFeature(featureId);
      emit(FeatureLoaded(data));
    } catch (e) {
      emit(FeatureError(e.toString()));
    }
  }
}
```

---

## State Pattern

```dart
sealed class FeatureState extends Equatable {
  const FeatureState();
  @override List<Object?> get props => [];
}

final class FeatureInitial extends FeatureState {}
final class FeatureLoading extends FeatureState {}

final class FeatureLoaded extends FeatureState {
  final FeatureModel model;
  const FeatureLoaded(this.model);
  @override List<Object?> get props => [model];
}

final class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
  @override List<Object?> get props => [message];
}
```

---

## Key Points

1. Sealed base class with Equatable
2. Final subclasses for each state variant
3. Loading state before async operation
4. Error state carries message

---

## Reference

- Full example: `lib/src/modules/{feature}/ui/cubit/`
