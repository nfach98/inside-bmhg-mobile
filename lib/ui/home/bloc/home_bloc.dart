import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/data/repositories/auth_repository.dart';
import 'package:inside_bmhg/ui/home/bloc/home_event.dart';
import 'package:inside_bmhg/ui/home/bloc/home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository _authRepository;

  HomeBloc(this._authRepository) : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<HomeLogoutEvent>(_onHomeLogout);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(const HomeState());
  }

  void _onHomeLogout(HomeLogoutEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await _authRepository.logout();
      emit(state.copyWith(status: HomeStatus.logoutSuccess));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Gagal melakukan logout. Silakan coba lagi.',
      ));
    }
  }
}
