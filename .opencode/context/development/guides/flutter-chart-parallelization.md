<!-- Context: development/guides/flutter-chart-parallelization | Priority: high | Version: 1.0 | Updated: 2026-06-10 -->

# Guide: Chart Parallel Building with Future.wait

**Purpose**: Build multiple chart types in parallel using hybrid parallelization.

## Core Concept
Group widgets by chart TYPE (not by test), build all charts of type A together, all charts of type B together, then use `Future.wait` to wait for all types to complete concurrently.

## Key Points
- Group by chart TYPE (e.g., Line, Bar, Pie)
- Use `Navigator.push` with `PageRouteBuilder` for invisible pages
- Push multiple invisible pages concurrently (one per chart type)
- Wait for all types with `Future.wait([future1, future2, ...])`
- Model needs cache fields for each chart type

## Chart Configurations
| Type | Chart Widget | xUnit | yUnit |
|------|-------------|-------|-------|
| Line | CustomLineChart | time | decibel |
| Bar | CustomColumnChart | "Hz" | decibel |
| Spectrum | CustomLineChart | "Hz" | decibel |

## Minimal Example
```dart
// Group by TYPE, not by test
final lineGroup = <String, List<TestModel>>{};
final barGroup = <String, List<TestModel>>{};

// Push multiple invisible pages concurrently
await Future.wait([
  _buildChartsInBackground(lineGroup, ChartType.line),
  _buildChartsInBackground(barGroup, ChartType.bar),
  _buildChartsInBackground(pieGroup, ChartType.pie),
]);
```
