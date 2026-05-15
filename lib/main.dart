import 'package:flutter/material.dart';
import 'package:inside_bmhg/routes/app_router.dart';
import 'package:inside_bmhg/ui/core/themes/app_theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InsideBMHG',
      theme: AppTheme.getTheme(),
      routerConfig: router,
    );
  }
}
