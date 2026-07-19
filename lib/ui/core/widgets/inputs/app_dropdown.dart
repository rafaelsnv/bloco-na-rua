import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";

/// A typed dropdown item for use with [AppDropdown].
///
/// Contains the selectable [value], display [label], and optional [icon].
class AppDropdownItem<T> {
  /// The value this item represents when selected.
  final T value;

  /// The display label shown in the dropdown menu and selected state.
  final String label;

  /// Optional leading icon displayed next to the label.
  final Widget? icon;

  const AppDropdownItem({required this.value, required this.label, this.icon});
}

/// A typed dropdown input widget with design system styling.
///
/// Wraps [DropdownButtonFormField] to provide a consistent dropdown
/// experience with label, hint, error text, and disabled state support.
class AppDropdown<T> extends StatelessWidget {
  /// Optional label text displayed above the dropdown.
  final String? label;

  /// The currently selected value.
  final T? value;

  /// The list of available items in the dropdown.
  final List<AppDropdownItem<T>> items;

  /// Callback fired when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Hint text displayed when no value is selected.
  final String? hint;

  /// Error message displayed below the dropdown.
  final String? errorText;

  /// Whether the dropdown is enabled. Defaults to true.
  final bool isEnabled;

  const AppDropdown({
    super.key,
    this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.errorText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: key ?? Key('app_dropdown_$label'),
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                item.icon!,
                SizedBox(width: Spacing.space_xs),
              ],
              Text(item.label, style: AppTypography.bodyMedium),
            ],
          ),
        );
      }).toList(),
      onChanged: isEnabled ? onChanged : null,
      hint: hint != null
          ? Text(
              hint!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDisabled,
              ),
            )
          : null,
      decoration: InputDecoration(labelText: label, errorText: errorText),
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                item.icon!,
                SizedBox(width: Spacing.space_xs),
              ],
              Text(item.label, style: AppTypography.bodyMedium),
            ],
          );
        }).toList();
      },
    );
  }
}
