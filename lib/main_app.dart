// App root. Provides ThemeCubit, AuthCubit. Drives MaterialApp.themeMode from
// ThemeCubit so the theme persists across reboots and updates live when the
// user toggles via the Settings screen.

import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/router.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/foundation.dart";
import "package:go_router/go_router.dart";

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = router(context.read<AuthListenable>());
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Log device locale
    final deviceLocale = PlatformDispatcher.instance.locale;
    if (kDebugMode) {
      debugPrint('[DEBUG i18n] Device locale: $deviceLocale');
      debugPrint('[DEBUG i18n] Language: ${deviceLocale.languageCode}, Country: ${deviceLocale.countryCode}');
      debugPrint('[DEBUG i18n] Supported locales: ${AppLocalizations.supportedLocales}');
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
            authRepository: context.read(),
            authListenable: context.read<AuthListenable>(),
          ),
        ),
        BlocProvider(create: (_) => ThemeCubit()..load()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: "Bloco na Rua",
            themeMode: themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            routerConfig: _router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
