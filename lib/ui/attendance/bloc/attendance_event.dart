import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Dipanggil saat screen pertama dibuka — minta izin lokasi & mulai timer jam
class AttendanceInitialEvent extends AttendanceEvent {
  const AttendanceInitialEvent();
}

/// Update jam setiap detik
class AttendanceTimeTickEvent extends AttendanceEvent {
  const AttendanceTimeTickEvent(this.time);
  final DateTime time;

  @override
  List<Object?> get props => [time];
}

/// Minta izin & ambil koordinat GPS
class AttendanceLocationRequestedEvent extends AttendanceEvent {
  const AttendanceLocationRequestedEvent();
}

/// Pilih aktivitas dari dropdown (Shift In / Shift Out)
class AttendanceActivitySelectedEvent extends AttendanceEvent {
  const AttendanceActivitySelectedEvent(this.activity);
  final String activity;

  @override
  List<Object?> get props => [activity];
}

/// Submit absen
class AttendanceSubmitEvent extends AttendanceEvent {
  const AttendanceSubmitEvent();
}
