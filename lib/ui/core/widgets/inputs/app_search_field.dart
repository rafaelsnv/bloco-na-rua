// lib/ui/core/widgets/inputs/app_search_field.dart
//
// Search field widget for the Bloco na Rua design system.
//
// A specialized text input with a search icon prefix and a clear-button suffix.
// The clear button appears only when the field contains text; it clears the
// content and notifies the onChanged callback.
//
// State behaviour:
//   - Manages its own TextEditingController when no external controller is provided.
//   - Disposes its own controller only (not the externally-provided one).
//   - Re-renders when text changes to show/hide the clear button.

import "package:flutter/material.dart";

import "../../tokens/app_duration.dart";

/// Search field widget with prefix search icon and clear-button suffix.
class AppSearchField extends StatefulWidget {
  /// Hint text shown when the field is empty. Defaults to "Pesquisar...".
  final String? hint;

  /// Callback fired whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback fired when the user submits the field (e.g., presses enter).
  final ValueChanged<String>? onSubmitted;

  /// Optional external controller. When provided, the widget will not create
  /// or dispose its own controller.
  final TextEditingController? controller;

  /// Whether the field should autofocus on initial render. Defaults to false.
  final bool autofocus;

  /// Creates a search field.
  ///
  /// The [hint] defaults to "Pesquisar..." if not provided.
  /// When [controller] is null, the widget creates and manages its own
  /// TextEditingController and disposes it in [dispose].
  const AppSearchField({
    super.key,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    // Only dispose the internally-created controller.
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint ?? "Pesquisar...",
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: AnimatedSwitcher(
          duration: AppDurations.fast,
          child: _controller.text.isEmpty
              ? const SizedBox.shrink(key: ValueKey("empty"))
              : IconButton(
                  key: ValueKey("clear"),
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  splashRadius: 20,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call("");
                    setState(() {});
                  },
                ),
        ),
      ),
    );
  }
}
