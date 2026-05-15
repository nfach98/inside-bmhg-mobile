import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/ui/login/bloc/login_event.dart';
import 'package:inside_bmhg/ui/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginInitialEvent>(_onLoginInitial);
  }

  void _onLoginInitial(LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(const LoginState());
  }
}
