import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.event_available_rounded,
            size: 120,
            color: AppColors.primary,
          ),
          const SizedBox(height: Spacing.space_xl),
          Text(
            "Confirme presença nas reuniões",
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.space_md),
          Text(
            "Veja as reuniões do seu bloco e confirme sua presença. Nunca mais perca um encontro!",
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
