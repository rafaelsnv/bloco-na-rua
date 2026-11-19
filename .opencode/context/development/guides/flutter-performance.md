<!-- Context: development/guides/flutter-performance | Priority: high | Version: 1.0 | Updated: 2026-06-10 -->

# Performance Patterns for Flutter Chart Rendering

## Pattern 1: Isolate-Based Background Data Processing

**Problem**: `_downsamplePoints` runs synchronously on main thread, blocking UI.

**Solution**: Use `compute()` or `Isolate.spawn` to offload processing:
```dart
import 'dart:isolate';

Future<List<DataPoint>> processInBackground(List<DataPoint> data) async {
  return await Isolate.run(() => downsamplePoints(data));
}
```

**Result**: Main thread stays free for UI, charts render without jank.

---

## Pattern 2: Batch Chart Rendering with Timer.periodic

**Problem**: All charts built simultaneously cause CPU spike.

**Solution**: Build charts 1-2 at a time with 100ms intervals:
```dart
Timer.periodic(const Duration(milliseconds: 100), (timer) {
  if (chartIndex >= charts.length) {
    timer.cancel();
    return;
  }
  buildChart(charts[chartIndex]);
  chartIndex++;
});
```

**Result**: Prevents CPU spike, keeps UI responsive during PDF export.

---

## Pattern 3: Caching to Skip Redundant Rebuilds

**Problem**: Charts reprocess every time if `_chartsBuilt` flag resets.

**Solution**: Check if data already exists before rebuilding:
```dart
if (test.chartSoundLevel != null && test.chartSoundLevel!.isNotEmpty) {
  // Skip processing - use cached data
  return test.chartSoundLevel!;
}
```

**Result**: Instant export if charts already built.

---

## Pattern 4: Use Timer Instead of Future.delayed

**Benefits**:
- More precise control over timing
- Can cancel if user navigates away
- No arbitrary delay values

```dart
// ❌ Arbitrary - can be too long or too short
await Future.delayed(Duration(milliseconds: 500));

// ✅ Precise - cancelable, controllable
Timer.periodic(const Duration(milliseconds: 100), (timer) { ... });
```

**Reference**: `.tmp/sessions/2026-06-10-slm-chart-performance/context.md`