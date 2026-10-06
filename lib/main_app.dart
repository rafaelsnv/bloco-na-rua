// App root. Provides ThemeCubit, AuthCubit. Drives MaterialApp.themeMode from
// ThemeCubit so the theme persists across reboots and updates live when the
// user toggles via the Settings screen.
//
// Also provides the 3 list cubits (BlockListCubit, UserMeetingsCubit,
// HomeCubit) at the app level so CRUD screens outside the shell branch
// (CreateBlock, EditBlock, CreateMeeting, EditMeeting, etc.) can call
// `context.read<...>().loadX()` before popping — see option-1 lift pattern.

import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/router.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
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
  late final AuthCubit _authCubit;
  late final BlockListCubit _blockListCubit;
  late final UserMeetingsCubit _userMeetingsCubit;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    final authListenable = context.read<AuthListenable>();
    _router = router(authListenable);
    _authCubit = AuthCubit(
      authRepository: context.read(),
      authListenable: authListenable,
    );
    // design: list cubits are app-scoped (not shell-scoped) so CRUD routes
    // outside the shell can reach them via context.read. ResumableCubit's
    // WidgetsBindingObserver still works at app scope.
    _blockListCubit = BlockListCubit(getHomeDataUseCase: context.read());
    _userMeetingsCubit = UserMeetingsCubit(
      getUserMeetingsUseCase: context.read(),
    );
    _homeCubit = HomeCubit(getHomeDataUseCase: context.read());
  }

  @override
  void dispose() {
    _authCubit.close();
    _blockListCubit.close();
    _userMeetingsCubit.close();
    _homeCubit.close();
    super.dispose();
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
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<BlockListCubit>.value(value: _blockListCubit),
        BlocProvider<UserMeetingsCubit>.value(value: _userMeetingsCubit),
        BlocProvider<HomeCubit>.value(value: _homeCubit),
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
