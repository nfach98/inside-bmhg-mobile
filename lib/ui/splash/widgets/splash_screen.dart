import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_bloc.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_event.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<SplashBloc>()..add(CheckLoginEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            (current.status == SplashStatus.authenticated ||
                current.status == SplashStatus.unauthenticated),
        listener: (context, state) {
          switch (state.status) {
            case SplashStatus.authenticated:
              context.go('/');
            case SplashStatus.unauthenticated:
              context.go('/login');
            case SplashStatus.initial:
            case SplashStatus.loading:
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            toolbarHeight: 0,
          ),
          backgroundColor: theme.colorScheme.primary,
          body: Center(
            child: SizedBox(
              width: 120,
              height: 48,
              child: Image.asset(
                'assets/images/logo-bmhg.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
