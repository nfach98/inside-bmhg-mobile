import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/data/exceptions/api_exception.dart';
import 'package:inside_bmhg/data/repositories/auth_repository.dart';
import 'package:inside_bmhg/ui/login/bloc/login_event.dart';
import 'package:inside_bmhg/ui/login/bloc/login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(const LoginState()) {
    on<LoginInitialEvent>(_onLoginInitial);
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<LoginSSOEvent>(_onLoginSSO);
  }

  void _onLoginInitial(
    LoginInitialEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState());
  }

  void _onLoginSSO(
    LoginSSOEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      await _authRepository.loginWithSSO();
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Terjadi kesalahan SSO: ${e.toString()}',
      ));
    }
  }

  void _onLoginSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Terjadi kesalahan. Coba lagi.',
      ));
    }
  }
}
