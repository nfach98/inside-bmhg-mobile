import 'package:equatable/equatable.dart';

class AttendanceState extends Equatable {
  const AttendanceState({this.isLoading = false, this.response = ''});

  final Object response;
  final bool isLoading;

  AttendanceState copyWith({bool? isLoading, Object? response}) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [isLoading, response];
}
