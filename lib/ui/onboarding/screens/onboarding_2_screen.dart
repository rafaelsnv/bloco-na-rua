import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.group_add_rounded, size: 120, color: AppColors.primary),
          const SizedBox(height: Spacing.space_xl),
          Text(
            "Crie ou entre em um bloco",
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.space_md),
          Text(
            "Junte-se a um bloco existente ou crie o seu próprio. Convide amigos e familiares para fazer parte da folia!",
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
