import 'package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.replaceAll("Exception: ", "")),
              showCloseIcon: true,
            ),
          );
        }
      },
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () => context.read<AuthCubit>().logout(),
      ),
    );
  }
}
