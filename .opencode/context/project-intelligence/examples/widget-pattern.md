<!-- Context: project-intelligence/examples/widget-pattern | Priority: high | Version: 1.0 | Updated: 2026-07-01 -->

# Widget Pattern

**Core Concept**: Stateless widgets with `WidgetStateProperty` for hover/disabled states, using constants for styling.

---

## Flexible Button Pattern

**Example**: Generic reusable button component.

```dart
class FlexibleButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final double width;
  final double height;
  final double borderWidth;
  final Color color;
  final Color borderColor;
  final Color? hoverColor;
  final Color? disabledColor;
  final VoidCallback? onTap;
  final bool isEnabled;
  // ... additional optional properties for flexible styling

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton.icon(
        label: Text(title),
        icon: iconPath.isNotEmpty ? buildIcon : null,
        onPressed: isEnabled ? onTap : null,
        style: ButtonStyle(
          animationDuration: Duration.zero,
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor ?? color.withOpacity(0.5);
            }
            if (states.contains(WidgetState.hovered)) {
              return hoverColor ?? Colors.grey.shade100;
            }
            return color;
          }),
          // ... additional WidgetStateProperty handlers for foreground, border, etc.
        ),
      ),
    );
  }
}
```

---

## Key Points

1. **Stateless widget** with many optional properties for flexibility
2. **WidgetStateProperty** for hover/disabled/pressed states
3. **Color extensions**: prefer explicit `withOpacity(...)` over shorthand
4. **Constants**: define app-wide color, typography, and spacing constants in a single module
5. **OutlinedButton.icon** with label + icon support

---

## Related

- `core/standards/concepts/philosophy.md` — modular design principles
- `core/standards/examples/widget-pattern.md` — base StatelessWidget pattern
