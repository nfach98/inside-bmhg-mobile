import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/data/repositories/activity_repository.dart';
import 'package:inside_bmhg/data/repositories/auth_repository.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_event.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final ActivityRepository _activityRepository;
  final AuthRepository _authRepository;

  AttendanceBloc(
    this._activityRepository,
    this._authRepository,
  ) : super(AttendanceState()) {
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

    // Langsung minta lokasi
    add(const AttendanceLocationRequestedEvent());

    // Ambil nama user terkonfirmasi dari AuthRepository
    final userName = await _authRepository.getUserProfile();
    if (userName != null && userName.isNotEmpty) {
      emit(state.copyWith(userName: userName));
    }
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
    emit(state.copyWith(isLocationLoading: true, clearLocationError: true));

    try {
      // Cek apakah layanan lokasi aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            isLocationLoading: false,
            locationError: 'Layanan lokasi tidak aktif.',
          ),
        );
        return;
      }

      // Cek & minta izin
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              isLocationLoading: false,
              locationError: 'Izin lokasi ditolak.',
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            isLocationLoading: false,
            locationError: 'Izin lokasi ditolak permanen. Buka Pengaturan.',
          ),
        );
        return;
      }

      // Ambil posisi
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final locationName =
          '${position.latitude.toStringAsFixed(5)}, '
          '${position.longitude.toStringAsFixed(5)}';

      emit(
        state.copyWith(
          isLocationLoading: false,
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: locationName,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLocationLoading: false,
          locationError: 'Gagal mendapatkan lokasi.',
        ),
      );
    }
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
    final activity = state.selectedActivity;
    if (activity == null) return;
    if (state.latitude == null || state.longitude == null) {
      emit(state.copyWith(
        isLoading: false,
        locationError: 'Lokasi belum didapatkan. Pastikan GPS aktif.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final res = await _activityRepository.createactivity(
        activity,
        state.latitude.toString(),
        state.longitude.toString(),
      );

      emit(
        state.copyWith(
          isLoading: false,
          response: res.message ?? 'Absen berhasil dicatat!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          locationError: 'Gagal mencatat presensi: ${e.toString().replaceAll('Exception: ', '')}',
        ),
      );
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
