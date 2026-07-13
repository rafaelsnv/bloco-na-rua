// lib/ui/core/widgets/inputs/app_text_field.dart
//
// Bloco na Rua design system text field widget.
//
// Built on top of TextFormField for seamless Form integration.
// Decoration (padding, border, fill colors) is supplied entirely by the
// app's inputDecorationTheme in app_theme.dart — this widget only sets
// labelText, hintText, helperText, errorText, prefixIcon, and suffixIcon.
//
// State behavior:
//   - enabled = true  (default): normal interactive state
//   - enabled = false: TextFormField's built-in opacity reduction applies

import "package:flutter/material.dart";
import "package:flutter/services.dart";

/// A themed text input field for the Bloco na Rua design system.
///
/// Wraps [TextFormField] so it can participate in [Form] validation via
/// the [validator] callback. Visual decoration (border, fill, padding) is
/// supplied by the app's [ThemeData.inputDecorationTheme] — see [AppTheme].
class AppTextField extends StatelessWidget {
  /// Creates an AppTextField.
  ///
  /// All parameters are optional except where marked required. The [label]
  /// parameter is the field's floating label; it is displayed as the
  /// [InputDecoration.labelText].
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.isMultiline = false,
    this.isEnabled = true,
    this.maxLines,
    this.autofocus = false,
    this.inputFormatters,
  });

  /// The floating label text, passed to [InputDecoration.labelText].
  final String? label;

  /// The placeholder text shown when the field is empty,
  /// passed to [InputDecoration.hintText].
  final String? hint;

  /// Helper text displayed below the field,
  /// passed to [InputDecoration.helperText].
  final String? helperText;

  /// Error text displayed below the field,
  /// passed to [InputDecoration.errorText].
  final String? errorText;

  /// Icon shown at the start of the input area.
  /// Passed as an [Icon] widget inside [InputDecoration.prefixIcon].
  final IconData? prefixIcon;

  /// Widget shown at the end of the input area,
  /// passed to [InputDecoration.suffixIcon].
  final Widget? suffixIcon;

  /// Whether to obscure text entry (e.g. for passwords).
  /// Defaults to `false`.
  final bool obscureText;

  /// The type of keyboard to show.
  final TextInputType? keyboardType;

  /// The action button on the keyboard (e.g. "done", "next").
  final TextInputAction? textInputAction;

  /// Controller for the text being edited.
  final TextEditingController? controller;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. presses Enter).
  final ValueChanged<String>? onSubmitted;

  /// Validator called by [TextFormField] during form validation.
  final FormFieldValidator<String>? validator;

  /// When `true`, the field expands vertically for multi-line input.
  /// Sets [maxLines] to `null`, [minLines] to `3`, and
  /// [keyboardType] to [TextInputType.multiline] unless already set.
  final bool isMultiline;

  /// Whether the field is enabled. When `false`, the field is read-only
  /// and [TextFormField] applies reduced opacity automatically.
  final bool isEnabled;

  /// Maximum number of lines. Only used when [isMultiline] is `false`.
  /// When `isMultiline` is `true`, this parameter is ignored.
  final int? maxLines;

  /// Whether to autofocus this field when the screen appears.
  final bool autofocus;

  /// Optional list of [TextInputFormatter]s applied to the input.
  /// Useful for phone masks, currency, digits-only, etc.
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final effectiveKeyboardType = isMultiline && keyboardType == null
        ? TextInputType.multiline
        : keyboardType;

    final effectiveMaxLines = isMultiline ? null : (maxLines ?? 1);

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      obscureText: obscureText,
      keyboardType: effectiveKeyboardType,
      textInputAction: isMultiline ? TextInputAction.newline : textInputAction,
      enabled: isEnabled,
      maxLines: effectiveMaxLines,
      minLines: isMultiline ? 3 : null,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
