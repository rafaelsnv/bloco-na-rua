<!-- Context: project-intelligence/examples/model-pattern | Priority: high | Version: 1.0 | Updated: 2026-05-04 -->

# Model Pattern Example

**Example**: JSON-serializable model with copyWith for device data.

---

## Model Definition

```dart
@JsonSerializable()
class DeviceModel extends Equatable {
  final String id;
  final String serialNumber;
  final String name;
  final DateTime? lastCalibration;

  const DeviceModel({
    required this.id,
    required this.serialNumber,
    required this.name,
    this.lastCalibration,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  DeviceModel copyWith({
    String? id,
    String? serialNumber,
    String? name,
    DateTime? lastCalibration,
  }) => _$DeviceModelUpdate(this);

  @override
  List<Object?> get props => [id, serialNumber, name, lastCalibration];
}
```

---

## Generated Files

| File | Purpose |
|------|---------|
| `{device}_model.g.dart` | fromJson/toJson |
| `{device}_model.update.g.dart` | copyWith |

---

## Reference

- Full example: `lib/src/modules/{device}/domain/models/`
- Code generation: `core/standards/guides/code-generation.md`
