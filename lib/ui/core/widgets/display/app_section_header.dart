import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.leading,
    this.action,
    this.titleTrailing,
  });

  /// Section title text (required).
  final String title;

  /// Optional leading widget placed before the title (e.g. icon).
  final Widget? leading;

  /// Optional widget placed right after the title (e.g. a count chip).
  final Widget? titleTrailing;

  /// Optional trailing widget (e.g. TextButton "Ver todos").
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingMobile,
        vertical: Spacing.space_2xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: Spacing.space_xs),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTypography.headlineSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (titleTrailing != null) ...[
            const SizedBox(width: Spacing.space_xs),
            titleTrailing!,
          ],
          if (action != null) ...[
            const SizedBox(width: Spacing.space_sm),
            action!,
          ],
        ],
      ),
    );
  }
}
