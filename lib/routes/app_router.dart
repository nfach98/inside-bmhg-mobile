import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inside_bmhg/ui/attendance/widgets/attendance_screen.dart';
import 'package:inside_bmhg/ui/home/widgets/home_screen.dart';
import 'package:inside_bmhg/ui/login/widgets/login_screen.dart';
import 'package:inside_bmhg/ui/splash/widgets/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => AttendanceScreen(),
    ),
  ],
);
