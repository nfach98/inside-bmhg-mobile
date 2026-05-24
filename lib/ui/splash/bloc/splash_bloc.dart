import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/data/repositories/auth_repository.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_event.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;

  SplashBloc(this._authRepository) : super(const SplashState()) {
    on<CheckLoginEvent>(_onCheckLogin);
  }

  void _onCheckLogin(CheckLoginEvent event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loading));
    await Future.delayed(const Duration(milliseconds: 1800));

    final status = _authRepository.isLoggedIn()
        ? SplashStatus.authenticated
        : SplashStatus.unauthenticated;
    emit(state.copyWith(status: status));
  }
}
