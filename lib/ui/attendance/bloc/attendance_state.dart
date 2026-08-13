import 'package:equatable/equatable.dart';

enum ShiftStatus { shiftIn, shiftOut, inactive }

class AttendanceState extends Equatable {
  AttendanceState({
    this.isLoading = false,
    this.isLocationLoading = false,
    this.response = '',
    this.shiftStatus = ShiftStatus.inactive,
    this.selectedActivity,
    this.latitude,
    this.longitude,
    this.locationName,
    this.locationError,
    this.userName,
    DateTime? currentTime,
  }) : currentTime = currentTime ?? DateTime.now();

  final bool isLoading;
  final bool isLocationLoading;
  final Object response;
  final ShiftStatus shiftStatus;
  final String? selectedActivity;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? locationError;
  final String? userName;
  final DateTime currentTime;

  AttendanceState copyWith({
    bool? isLoading,
    bool? isLocationLoading,
    Object? response,
    ShiftStatus? shiftStatus,
    String? selectedActivity,
    double? latitude,
    double? longitude,
    String? locationName,
    String? locationError,
    String? userName,
    DateTime? currentTime,
    bool clearLocationError = false,
    bool clearSelectedActivity = false,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      response: response ?? this.response,
      shiftStatus: shiftStatus ?? this.shiftStatus,
      selectedActivity:
          clearSelectedActivity
              ? null
              : (selectedActivity ?? this.selectedActivity),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      locationError:
          clearLocationError ? null : (locationError ?? this.locationError),
      userName: userName ?? this.userName,
      currentTime: currentTime ?? this.currentTime,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLocationLoading,
    response,
    shiftStatus,
    selectedActivity,
    latitude,
    longitude,
    locationName,
    locationError,
    userName,
    currentTime,
  ];
}
