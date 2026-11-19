import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_repository.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/base_api_client.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/google_sign_in_service.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/router.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:provider/provider.dart";
import "package:result_dart/result_dart.dart";

class MockIMembersRepository extends Mock implements IMembersRepository {}

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockGoogleSignInService extends Mock implements GoogleSignInService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockIBaseApiClient extends Mock implements IBaseApiClient {
  @override
  late Dio client;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthRepository authRepository;
  late MockIMembersRepository membersRepository;
  late MockSecureStorageService secureStorageService;
  late MockGoogleSignInService googleSignInService;
  late BaseApiClient baseApiClient;
  late AuthListenable authListenable;

  /// Number of `GET /Members/uuid/{uuid}` calls — the only network call the
  /// router redirect can trigger.
  var memberCalls = 0;

  final member = MembersEntity(
    id: 1,
    name: "Ana",
    email: "ana@test.com",
    uuid: "user-uuid",
  );

  setUp(() {
    memberCalls = 0;

    membersRepository = MockIMembersRepository();
    secureStorageService = MockSecureStorageService();
    googleSignInService = MockGoogleSignInService();
    baseApiClient = BaseApiClient();
    authListenable = AuthListenable();

    when(
      () => secureStorageService.fetchToken(),
    ).thenAnswer((_) async => const Success("token"));
    when(
      () => secureStorageService.fetchUuid(),
    ).thenAnswer((_) async => const Success("user-uuid"));
    when(
      () => secureStorageService.saveUuid(any()),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => secureStorageService.saveToken(any()),
    ).thenAnswer((_) async => const Success(true));
    when(() => membersRepository.getByUuidAsync(any())).thenAnswer((_) async {
      memberCalls++;
      return Success(member);
    });

    authRepository = AuthRepository(
      membersRepository: membersRepository,
      authApiClient: MockAuthApiClient(),
      googleSignInService: googleSignInService,
      baseApiClient: baseApiClient,
      sharedPreferencesService: secureStorageService,
      authListenable: authListenable,
    );
  });

  testWidgets(
    "the redirect does not validate the session on every navigation",
    (tester) async {
      final appRouter = router(
        authListenable,
        initialLocation: Routes.settings,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<IAuthRepository>.value(value: authRepository)],
          child: BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(
              authRepository: authRepository,
              authListenable: authListenable,
            ),
            child: MaterialApp.router(
              routerConfig: appRouter,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The first navigation validates the session over the network.
      expect(memberCalls, equals(1));

      // The backend "breaks" after that first validation: any further network
      // call would invalidate the session and kick the user to the login.
      when(() => membersRepository.getByUuidAsync(any())).thenAnswer((_) async {
        memberCalls++;
        return Failure(Exception("Member not found"));
      });

      appRouter.go(Routes.onboarding);
      await tester.pumpAndSettle();

      expect(memberCalls, equals(1));
      expect(
        appRouter.routerDelegate.currentConfiguration.uri.path,
        equals(Routes.onboarding),
      );

      // An auth notification re-runs the redirect — still without the network.
      authListenable.notify();
      await tester.pumpAndSettle();

      expect(memberCalls, equals(1));
      expect(
        appRouter.routerDelegate.currentConfiguration.uri.path,
        equals(Routes.onboarding),
      );
    },
  );

  testWidgets("a 401 notification redirects guarded routes to login", (
    tester,
  ) async {
    final appRouter = router(authListenable, initialLocation: Routes.settings);

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<IAuthRepository>.value(value: authRepository)],
        child: BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authRepository: authRepository,
            authListenable: authListenable,
          ),
          child: MaterialApp.router(
            routerConfig: appRouter,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      appRouter.routerDelegate.currentConfiguration.uri.path,
      Routes.settings,
    );

    when(() => membersRepository.getByUuidAsync(any())).thenAnswer((_) async {
      memberCalls++;
      return Failure(Exception("Session revoked"));
    });
    baseApiClient.formatError(
      Response(statusCode: 401, requestOptions: RequestOptions(path: "/api")),
    );
    await tester.pumpAndSettle();

    expect(
      appRouter.routerDelegate.currentConfiguration.uri.path,
      Routes.login,
    );
  });
}
