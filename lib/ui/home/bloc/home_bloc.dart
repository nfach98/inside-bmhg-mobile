import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/ui/home/bloc/home_event.dart';
import 'package:inside_bmhg/ui/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitial);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(const HomeState());
  }
}
