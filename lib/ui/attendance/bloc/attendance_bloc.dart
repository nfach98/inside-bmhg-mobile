import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/data/repositories/activity_repository.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_event.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final ActivityRepository activityRepository;

  AttendanceBloc(this.activityRepository) : super(AttendanceState()) {
    on<AttendanceInitialEvent>(_onInitial);
    on<AttendanceTimeTickEvent>(_onTimeTick);
    on<AttendanceLocationRequestedEvent>(_onLocationRequested);
    on<AttendanceActivitySelectedEvent>(_onActivitySelected);
    on<AttendanceSubmitEvent>(_onSubmit);
  }

  Timer? _timer;

  // ---------------------------------------------------------------------------
  // Handlers
  // ---------------------------------------------------------------------------

  Future<void> _onInitial(
    AttendanceInitialEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    // Mulai jam real-time
    _startClock();

    // Langsung minta lokasi (dummy)
    add(const AttendanceLocationRequestedEvent());
  }

  void _onTimeTick(
    AttendanceTimeTickEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(state.copyWith(currentTime: event.time));
  }

  Future<void> _onLocationRequested(
    AttendanceLocationRequestedEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    // Using dummy location as requested
    emit(
      state.copyWith(
        isLocationLoading: false,
        latitude: -6.200000,
        longitude: 106.816666,
        locationName: 'Jakarta (Dummy)',
      ),
    );
  }

  void _onActivitySelected(
    AttendanceActivitySelectedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    final shiftStatus = switch (event.activity) {
      'Shift In' => ShiftStatus.shiftIn,
      'Shift Out' => ShiftStatus.shiftOut,
      _ => ShiftStatus.inactive,
    };

    emit(
      state.copyWith(
        selectedActivity: event.activity,
        shiftStatus: shiftStatus,
      ),
    );
  }

  Future<void> _onSubmit(
    AttendanceSubmitEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    if (state.selectedActivity == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      // Menggunakan dummy lat/long
      const dummyLat = '-6.200000';
      const dummyLon = '106.816666';

      final responseActivity = await activityRepository.createactivity(
        state.selectedActivity!,
        dummyLat,
        dummyLon,
      );

      emit(
        state.copyWith(
          isLoading: false,
          response: responseActivity.message ?? 'Absen berhasil dicatat!',
        ),
      );
      print(responseActivity.message);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          response: 'Gagal mencatat absen: $e',
        ),
      );
      print(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(AttendanceTimeTickEvent(DateTime.now()));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
