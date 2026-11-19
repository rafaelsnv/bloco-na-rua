import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:flutter/material.dart";

/// A read-only date/time picker field styled consistently with [AppTextField].
///
/// Combines [InkWell] (the press feedback) with [InputDecorator] (the
/// label / error surface) and announces itself as a button so screen readers
/// treat it as an interactive trigger instead of a dead text box.
///
/// The [controller] is owned by the parent, which also owns the picker
/// dialog: the field only reports the tap through [onTap].
class AppDateTimeField extends StatelessWidget {
  /// Creates an [AppDateTimeField].
  const AppDateTimeField({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
    this.hint,
    this.errorText,
    this.suffixIcon,
    this.semanticsLabel,
  });

  /// The floating label text, passed to [InputDecoration.labelText].
  final String label;

  /// Controller holding the formatted date/time string, owned by the parent.
  final TextEditingController controller;

  /// Callback invoked when the field is tapped.
  final VoidCallback? onTap;

  /// Placeholder text shown when [controller] is empty.
  final String? hint;

  /// Error text displayed below the field, passed to [InputDecoration.errorText].
  final String? errorText;

  /// Trailing icon inside the input decoration.
  final IconData? suffixIcon;

  /// Optional accessibility label announced by screen readers; defaults to
  /// [label].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final isEmpty = value.text.isEmpty;
        return Semantics(
          key: key ?? Key("app_date_time_field_$label"),
          container: true,
          label: semanticsLabel ?? label,
          value: isEmpty ? null : value.text,
          button: true,
          enabled: onTap != null,
          onTap: onTap,
          child: InkWell(
            onTap: onTap,
            borderRadius: Radii.input,
            child: InputDecorator(
              isEmpty: isEmpty,
              decoration: InputDecoration(
                labelText: label,
                errorText: errorText,
                suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
                // The label always floats so it never overlaps the value
                // painted inside the field.
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              child: ExcludeSemantics(
                child: Text(
                  isEmpty ? (hint ?? "") : value.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isEmpty
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
