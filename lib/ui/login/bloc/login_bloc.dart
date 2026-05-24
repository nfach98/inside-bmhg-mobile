import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/ui/login/bloc/login_event.dart';
import 'package:inside_bmhg/ui/login/bloc/login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginInitialEvent>(_onLoginInitial);
    on<LoginSubmitEvent>(_onLoginSubmit);
  }

  void _onLoginInitial(
    LoginInitialEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState());
  }

  void _onLoginSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // TODO: ganti dengan repository/use-case login yang sebenarnya
      // contoh: await _authRepository.login(event.username, event.password);
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi sukses — hapus dan ganti dengan response asli
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}