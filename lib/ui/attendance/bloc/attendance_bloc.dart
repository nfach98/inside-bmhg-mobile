import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_event.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(const AttendanceState()) {
    on<AttendanceInitialEvent>(_onAttendanceInitial);
  }

  void _onAttendanceInitial(
    AttendanceInitialEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceState());
  }
}
