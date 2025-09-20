import 'package:bloco_na_rua/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.go(Routes.profile),
      icon: Icon(Icons.account_circle),
    );
  }
}
