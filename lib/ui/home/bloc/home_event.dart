import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialEvent extends HomeEvent {}

class HomeLogoutEvent extends HomeEvent {}

/// Dipanggil saat halaman pertama kali dibuka untuk fetch data shift & meeting
class HomeFetchDataEvent extends HomeEvent {}

/// Dipanggil saat pull-to-refresh
class HomeRefreshEvent extends HomeEvent {}
