import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_bloc.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceBloc>(),
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Attendance')),
            body: Center(child: Text('Attendance')),
          );
        },
      ),
    );
  }
}
