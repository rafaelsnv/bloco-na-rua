<!-- Context: development/guides/flutter-chart-interactions | Priority: medium | Version: 1.0 | Updated: 2026-06-10 -->

# Guide: Zoom State Tracking for Animation Control

**Purpose**: Disable animations during zoom/pan to improve performance and UX.

## Implementation
```dart
class _CustomLineChartState extends State<CustomLineChart> {
  bool _isZooming = false;

  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    enableDoubleTapZooming: true,
  ).also((behavior) {
    behavior.zoomStart = () => setState(() => _isZooming = true);
    behavior.zoomEnd = () => setState(() => _isZooming = false);
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: charts.map((series) {
        return series.copyWith(
          animationDuration: _isZooming ? 0 : 300,
        );
      }).toList(),
    );
  }
}
```

**Key Points**:
- Track zoom state via callbacks on ZoomPanBehavior
- Set animationDuration to 0 during zoom
- Re-enable animations when zoom ends
- Use `also()` to add callbacks to existing behavior

---

# Pattern: Conditional Rendering Based on Drag State

**Core Idea**: Only show UI elements when actively interacting.

**Use Case**: Selection overlay labels visible only during marker drag.

## Implementation
```dart
class SelectionOverlayState {
  bool _isDraggingStart = false;
  bool _isDraggingEnd = false;

  void onDragStart(DragStartDetails details) {
    if (isOverStartMarker(details.localPosition)) {
      setState(() => _isDraggingStart = true);
    }
    if (isOverEndMarker(details.localPosition)) {
      setState(() => _isDraggingEnd = true);
    }
  }

  void onDragEnd(DragEndDetails details) {
    setState(() {
      _isDraggingStart = false;
      _isDraggingEnd = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Label only shown when dragging start marker
        if (_isDraggingStart) _buildStartLabel(),
        // Label only shown when dragging end marker
        if (_isDraggingEnd) _buildEndLabel(),
      ],
    );
  }
}
```

**Benefits**:
- Cleaner UI - less visual noise
- Performance - no hidden elements taking resources
- Clear feedback - user knows what's interactive
