import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.leading,
    this.action,
  });

  /// Section title text (required).
  final String title;

  /// Optional leading widget placed before the title (e.g. icon).
  final Widget? leading;

  /// Optional trailing widget (e.g. TextButton "Ver todos").
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingMobile,
        vertical: Spacing.space_sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: Spacing.space_xs),
          ],
          Expanded(child: Text(title, style: AppTypography.headlineSmall)),
          if (action != null) ...[
            const SizedBox(width: Spacing.space_sm),
            action!,
          ],
        ],
      ),
    );
  }
}
