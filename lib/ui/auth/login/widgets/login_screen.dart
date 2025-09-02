// import 'package:bloco_na_rua/ui/auth/login/view_models/login_viewmodel.dart';
// import 'package:flutter/widgets.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key, required this.viewModel});

//   final LoginViewModel viewModel;

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController(
//     text: 'email@example.com',
//   );
//   final TextEditingController _password = TextEditingController(
//     text: 'password',
//   );

  // @override
  // void initState() {
  //   super.initState();
  //   widget.viewModel.login.addListener(_onResult);
  // }

  // @override
  // void didUpdateWidget(covariant LoginScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   oldWidget.viewModel.login.removeListener(_onResult);
  //   widget.viewModel.login.addListener(_onResult);
  // }

  // @override
  // void dispose() {
  //   widget.viewModel.login.removeListener(_onResult);
  //   super.dispose();
  // }

  // void _onResult() {
  //   if (widget.viewModel.login.) {
  //     widget.viewModel.login.clearResult();
  //     context.go(Routes.home);
  //   }

  //   if (widget.viewModel.login.error) {
  //     widget.viewModel.login.clearResult();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(AppLocalization.of(context).errorWhileLogin),
  //         action: SnackBarAction(
  //           label: AppLocalization.of(context).tryAgain,
  //           onPressed: () => widget.viewModel.login.execute((
  //             _email.value.text,
  //             _password.value.text,
  //           )),
  //         ),
  //       ),
  //     );
  //   }
  // }
// }
