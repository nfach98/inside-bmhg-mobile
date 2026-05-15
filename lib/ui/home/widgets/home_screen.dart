import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/home/bloc/home_bloc.dart';
import 'package:inside_bmhg/ui/home/bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: Text('Home')),
          );
        },
      ),
    );
  }
}
