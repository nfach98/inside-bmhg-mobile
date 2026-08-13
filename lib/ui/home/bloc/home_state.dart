import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, logoutSuccess, failure }

// Model data untuk Chart
class ShiftData extends Equatable {
  final String day;
  final double hours;
  const ShiftData({required this.day, required this.hours});

  @override
  List<Object?> get props => [day, hours];
}

// Model data untuk List Meeting
class MeetingData extends Equatable {
  final String date;
  final String status; // 'checked', 'crossed', atau 'empty'
  const MeetingData({required this.date, required this.status});

  @override
  List<Object?> get props => [date, status];
}

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;
  final List<ShiftData> shifts;
  final double totalHours;
  final List<MeetingData> meetings;
  final String currentMonthName;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.shifts = const [],
    this.totalHours = 0,
    this.meetings = const [],
    this.currentMonthName = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<ShiftData>? shifts,
    double? totalHours,
    List<MeetingData>? meetings,
    String? currentMonthName,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shifts: shifts ?? this.shifts,
      totalHours: totalHours ?? this.totalHours,
      meetings: meetings ?? this.meetings,
      currentMonthName: currentMonthName ?? this.currentMonthName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        shifts,
        totalHours,
        meetings,
        currentMonthName,
      ];
}

