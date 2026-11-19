import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: l10n.notFoundTitle),
      body: SafeArea(
        child: ContentWidthLimiter(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: AppColors.error,
                    size: AppIconSizes.illustration,
                  ),
                  const SizedBox(height: Spacing.sectionGap),
                  Text("404", style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: Spacing.space_sm),
                  Text(
                    l10n.notFoundMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: Spacing.sectionGap),
                  AppButton(
                    label: l10n.coreBack,
                    variant: AppButtonVariant.primary,
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(Routes.home);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
