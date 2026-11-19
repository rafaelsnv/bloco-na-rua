import "package:flutter/material.dart";

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/auth/logout/widgets/logout_action.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: l10n.settingsTitle),
      body: ContentWidthLimiter(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.pagePaddingFor(context),
          ),
          children: [
            AppSectionHeader(title: l10n.settingsAccountSection),
            const LogoutAction(),
          ],
        ),
      ),
    );
  }
}
