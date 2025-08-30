import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/members_list_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: Routes.members,
  routes: [
    GoRoute(
      path: Routes.members,
      builder: (context, state) => const MembersListScreen(),
    ),
  ],
);
