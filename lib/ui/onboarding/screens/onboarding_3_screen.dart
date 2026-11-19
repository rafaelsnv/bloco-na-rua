import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.event_available_rounded,
            size: AppIconSizes.heroArt,
            color: colors.primary,
          ),
          const SizedBox(height: Spacing.space_xl),
          Text(
            l10n.onboarding3Title,
            style: AppTypography.headlineLarge.copyWith(color: colors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.space_md),
          Text(
            l10n.onboarding3Body,
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
