import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_event.dart';
import 'package:inside_bmhg/ui/splash/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<CheckLoginEvent>(_onCheckLogin);
  }

  void _onCheckLogin(CheckLoginEvent event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loading));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(status: SplashStatus.unauthenticated));
  }
}
