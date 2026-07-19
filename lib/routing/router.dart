import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart";
import "package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart";
import "package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart";
import "package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart";
import "package:bloco_na_rua/ui/auth/signUp/widgets/signup_screen.dart";
import "package:bloco_na_rua/ui/auth/verifyEmail/widgets/verify_email_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/addMember/widgets/add_member_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/widgets/block_list_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/widgets/create_block_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/widgets/edit_block_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/joinBlock/widgets/join_block_modal.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_shell.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_bottom_nav.dart";
import "package:bloco_na_rua/ui/error/widgets/error_screen.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/home/widgets/home_screen.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/widgets/create_meeting_screen.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/widgets/edit_meeting_screen.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/widgets/user_meetings_screen.dart";
import "package:bloco_na_rua/ui/not_found/widgets/not_found_screen.dart";
import "package:bloco_na_rua/ui/onboarding/onboarding_wrapper.dart";
import "package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart";
import "package:bloco_na_rua/ui/profile/widgets/profile_screen.dart";
import "package:bloco_na_rua/ui/settings/widgets/settings_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:logging/logging.dart";

final _logger = Logger("GoRouter");

const _shellNavItems = <AppBottomNavItem>[
  AppBottomNavItem(icon: Icons.home_rounded, label: "Início"),
  AppBottomNavItem(icon: Icons.celebration_rounded, label: "Blocos"),
  AppBottomNavItem(icon: Icons.event_rounded, label: "Reuniões"),
  AppBottomNavItem(icon: Icons.person_rounded, label: "Perfil"),
];

// Custom page transition
CustomTransitionPage<void> _buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  _logger.info('Navigating to: ${state.matchedLocation}');
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: child,
      );
    },
  );
}

GoRouter router(AuthListenable authListenable) => GoRouter(
  initialLocation: Routes.login,
  redirect: _redirect,
  refreshListenable: authListenable,
  errorBuilder: _errorBuilder,
  routes: [
    // Auth routes (no shell, no transition)
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: Routes.verifyEmail,
      builder: (context, state) {
        final email = state.uri.queryParameters["email"] ?? "";
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingWrapper(),
    ),

    // Shell with 4 branches
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(
        navigationShell: navigationShell,
        items: _shellNavItems,
        showAppBar: false,
      ),
      branches: [
        // Branch 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              pageBuilder: (context, state) => _buildPageWithSlideTransition(
                context: context,
                state: state,
                child: BlocProvider(
                  create: (context) =>
                      HomeCubit(getHomeDataUseCase: context.read())
                        ..loadHomeData(),
                  child: const HomeScreen(),
                ),
              ),
            ),
          ],
        ),
        // Branch 1: Blocks
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.carnivalBlocks,
              pageBuilder: (context, state) => _buildPageWithSlideTransition(
                context: context,
                state: state,
                child: BlocProvider(
                  create: (context) =>
                      BlockListCubit(getHomeDataUseCase: context.read())
                        ..loadBlocks(),
                  child: const BlockListScreen(),
                ),
              ),
            ),
          ],
        ),
        // Branch 2: Meetings (using userMeetingsScreen)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.userMeetings,
              pageBuilder: (context, state) => _buildPageWithSlideTransition(
                context: context,
                state: state,
                child: BlocProvider(
                  create: (context) =>
                      UserMeetingsCubit(getUserMeetingsUseCase: context.read())
                        ..loadMeetings(),
                  child: const UserMeetingsScreen(),
                ),
              ),
            ),
          ],
        ),
        // Branch 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              pageBuilder: (context, state) => _buildPageWithSlideTransition(
                context: context,
                state: state,
                child: BlocProvider(
                  create: (context) =>
                      context.read<ProfileCubit>()..loadProfile(),
                  child: const ProfileScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),

    // All modal/detail routes OUTSIDE the shell (with slide transition)
    GoRoute(
      path: "${Routes.carnivalBlock}/:id",
      pageBuilder: (context, state) {
        final carnivalBlockId = state.pathParameters["id"]!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => BlockDetailsCubit(
              carnivalBlocksRepository: context
                  .read<ICarnivalBlocksRepository>(),
              getCurrentUserData: context.read<GetCurrentUserData>(),
              carnivalBlockId: carnivalBlockId,
            ),
            child: BlockDetailsScreen(carnivalBlockId: carnivalBlockId),
          ),
        );
      },
    ),
    GoRoute(
      path: "${Routes.meeting}/:id",
      pageBuilder: (context, state) {
        final meetingId = state.pathParameters["id"]!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => MeetingDetailsCubit(
              meetingsRepository: context.read<IMeetingsRepository>(),
              meetingPresencesRepository: context
                  .read<IMeetingPresencesRepository>(),
              authRepository: context.read<IAuthRepository>(),
              carnivalBlocksRepository: context
                  .read<ICarnivalBlocksRepository>(),
              meetingId: meetingId,
            ),
            child: MeetingDetailsScreen(meetingId: meetingId),
          ),
        );
      },
    ),
    GoRoute(
      path: "${Routes.editMeeting}/:id",
      pageBuilder: (context, state) {
        final meetingId = state.pathParameters["id"]!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => EditMeetingCubit(
              meetingsRepository: context.read<IMeetingsRepository>(),
            ),
            child: EditMeetingScreen(meetingId: meetingId),
          ),
        );
      },
    ),
    GoRoute(
      path: "${Routes.editBlock}/:id",
      pageBuilder: (context, state) {
        final blockId = state.pathParameters["id"]!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => EditBlockCubit(
              carnivalBlocksRepository: context
                  .read<ICarnivalBlocksRepository>(),
              carnivalBlockId: blockId,
            ),
            child: EditBlockScreen(carnivalBlockId: blockId),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.joinBlock,
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context: context,
        state: state,
        child: const JoinBlockModal(),
      ),
    ),
    GoRoute(
      path: Routes.createBlock,
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (context) => CreateBlockCubit(
            carnivalBlocksRepository: context.read<ICarnivalBlocksRepository>(),
            carnivalBlockMembersRepository: context
                .read<ICarnivalBlockMembersRepository>(),
            getCurrentUserData: context.read<GetCurrentUserData>(),
          ),
          child: const CreateBlockScreen(),
        ),
      ),
    ),
    GoRoute(
      path: "/create-meeting/:blockId",
      pageBuilder: (context, state) {
        final blockId = state.pathParameters["blockId"]!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => CreateMeetingCubit(
              meetingsRepository: context.read<IMeetingsRepository>(),
            ),
            child: CreateMeetingScreen(carnivalBlockId: blockId),
          ),
        );
      },
    ),
    GoRoute(
      path: "/add-member/:blockId",
      pageBuilder: (context, state) {
        final blockId = state.pathParameters["blockId"]!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => AddMemberCubit(
              membersRepository: context.read<IMembersRepository>(),
              carnivalBlockMembersRepository: context
                  .read<ICarnivalBlockMembersRepository>(),
            ),
            child: AddMemberScreen(carnivalBlockId: blockId),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.settings,
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context: context,
        state: state,
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: Routes.notFound,
      builder: (context, state) => const NotFoundScreen(),
    ),
    GoRoute(
      path: Routes.error,
      builder: (context, state) => const ErrorScreen(),
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final sessionValid = await context.read<IAuthRepository>().validateSession();
  final location = state.matchedLocation;

  if (!sessionValid) {
    if (location == Routes.register) {
      return null;
    }
    return Routes.login;
  }

  if ([Routes.login, Routes.register].contains(location)) {
    return Routes.home;
  }

  if (location.startsWith("/add-member/")) {
    return null;
  }

  return null;
}

Widget _errorBuilder(BuildContext context, GoRouterState state) {
  final error = state.error;
  if (error != null && error.toString().contains("not found")) {
    _logger.warning("Page not found: ${state.uri}");
    return const NotFoundScreen();
  }
  _logger.severe("Routing error: $error", error, StackTrace.current);
  return const ErrorScreen();
}
