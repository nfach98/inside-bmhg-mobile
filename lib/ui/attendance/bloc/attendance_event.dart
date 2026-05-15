import 'package:equatable/equatable.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';

class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class AttendanceInitialEvent extends AttendanceEvent {}
