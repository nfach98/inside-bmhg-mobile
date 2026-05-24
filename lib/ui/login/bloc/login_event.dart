import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginInitialEvent extends LoginEvent {}

class LoginSubmitEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
