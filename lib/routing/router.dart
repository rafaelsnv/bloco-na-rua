import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart';
import 'package:bloco_na_rua/ui/auth/signUp/widgets/signup_screen.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/widgets/create_block_screen.dart';
import 'package:bloco_na_rua/ui/home/cubit/home_cubit.dart';
import 'package:bloco_na_rua/ui/home/widgets/home_screen.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_cubit.dart';
import 'package:bloco_na_rua/ui/members/widgets/members_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter router(IAuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => HomeCubit(
            getHomeDataUseCase: context.read(),
          )..loadHomeData(),
          child: const HomeScreen(),
        );
      },
    ),
    GoRoute(
      path: '${Routes.carnivalBlock}/:id',
      builder: (context, state) {
        final carnivalBlockId = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => BlockDetailsCubit(
            carnivalBlocksRepository: context.read<ICarnivalBlocksRepository>(),
            carnivalBlockId: carnivalBlockId,
          ),
          child: BlockDetailsScreen(
            carnivalBlockId: carnivalBlockId,
          ),
        );
      },
    ),
    GoRoute(
      path: '${Routes.meeting}/:id',
      builder: (context, state) {
        final meetingId = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => MeetingDetailsCubit(
            meetingsRepository: context.read<IMeetingsRepository>(),
            meetingId: meetingId,
          ),
          child: MeetingDetailsScreen(
            meetingId: meetingId,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.createBlock,
      builder: (context, state) {
        return const CreateBlockScreen();
      },
    ),
    GoRoute(
      path: Routes.members,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MembersCubit(
            membersRepository: context.read(),
          )..loadMembers(),
          child: const MembersScreen(),
        );
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<IAuthRepository>().isAuthenticated;
  if (!loggedIn) {
    if (state.matchedLocation == Routes.register) {
      return null;
    }
    return Routes.login;
  }

  if ([Routes.login, Routes.register].contains(state.matchedLocation)) {
    return Routes.home;
  }

  return null;
}
