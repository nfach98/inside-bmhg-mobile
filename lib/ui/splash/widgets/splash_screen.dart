import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_bloc.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_event.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SplashBloc()..add(CheckLoginEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.status == SplashStatus.unauthenticated) {
            context.go('/login');
          } else if (state.status == SplashStatus.authenticated) {
            context.go('/home');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            toolbarHeight: 0,
          ),
          backgroundColor: theme.colorScheme.primary,
          body: Center(
            child: Image.asset(
              'assets/images/logo-bmhg.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
