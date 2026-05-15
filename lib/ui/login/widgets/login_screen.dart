import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/login/bloc/login_bloc.dart';
import 'package:inside_bmhg/ui/login/bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {},
        child: Scaffold(
          appBar: AppBar(title: Text('Login')),
          body: Center(child: Text('Login')),
        ),
      ),
    );
  }
}
