import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:flutter/material.dart";

class ErrorScreen extends StatelessWidget {
  final String? errorMessage;

  const ErrorScreen({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Erro"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 80,
                ),
                const SizedBox(height: Spacing.sectionGap),
                Text(
                  errorMessage ?? "Ocorreu um erro inesperado.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: Spacing.sectionGap),
                AppButton(
                  label: "Voltar",
                  variant: AppButtonVariant.primary,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushReplacementNamed("/");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
