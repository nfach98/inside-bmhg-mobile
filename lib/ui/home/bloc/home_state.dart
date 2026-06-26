import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, logoutSuccess, failure }

// ─── Model lokal untuk UI (Chart & Meeting) ───────────────────────────────────

class ShiftData {
  final String day;
  final double hours;
  const ShiftData({required this.day, required this.hours});
}

class MeetingData {
  final String date;
  final String status; // 'checked', 'crossed', 'empty'
  const MeetingData({required this.date, required this.status});
}

// ─── State ────────────────────────────────────────────────────────────────────

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;

  // Data shift
  final String shiftMingguIni;
  final List<ShiftData> shifts;

  // Data meeting
  final String weeklyMeetingBulan;
  final List<MeetingData> meetings;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.shiftMingguIni = '-',
    this.shifts = const [],
    this.weeklyMeetingBulan = '-',
    this.meetings = const [],
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    String? shiftMingguIni,
    List<ShiftData>? shifts,
    String? weeklyMeetingBulan,
    List<MeetingData>? meetings,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shiftMingguIni: shiftMingguIni ?? this.shiftMingguIni,
      shifts: shifts ?? this.shifts,
      weeklyMeetingBulan: weeklyMeetingBulan ?? this.weeklyMeetingBulan,
      meetings: meetings ?? this.meetings,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    shiftMingguIni,
    shifts,
    weeklyMeetingBulan,
    meetings,
  ];
}
