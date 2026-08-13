import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/data/repositories/auth_repository.dart';
import 'package:inside_bmhg/data/repositories/activity_repository.dart';
import 'package:inside_bmhg/ui/home/bloc/home_event.dart';
import 'package:inside_bmhg/ui/home/bloc/home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository _authRepository;
  final ActivityRepository _activityRepository;

  HomeBloc(this._authRepository, this._activityRepository) : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<HomeLogoutEvent>(_onHomeLogout);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final now = DateTime.now();
      
      // Hitung range minggu ini (Senin - Minggu)
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7)).subtract(const Duration(microseconds: 1));

      // Hitung range bulan ini
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(microseconds: 1));

      // Fetch data dari API paralel/sekuensial
      final shiftResponse = await _activityRepository.getShifts(startOfWeek, endOfWeek);
      final meetingResponse = await _activityRepository.getMeetings(startOfMonth, endOfMonth);

      // 1. Parsing Shift Data
      final shiftsData = shiftResponse.data ?? [];
      final Map<int, List<dynamic>> eventsByDay = {};
      for (var event in shiftsData) {
        if (event.timestamp != null) {
          try {
            final dt = DateTime.parse(event.timestamp!).toLocal();
            eventsByDay.putIfAbsent(dt.weekday, () => []).add(event);
          } catch (_) {}
        }
      }

      const dayNames = {
        1: 'Senin',
        2: 'Selasa',
        3: 'Rabu',
        4: 'Kamis',
        5: "Jum'at",
        6: 'Sabtu',
        7: 'Minggu',
      };

      double totalHours = 0;
      final List<ShiftData> shifts = [];
      // Tampilkan hari Senin - Jum'at seperti layout semula
      for (int i = 1; i <= 5; i++) {
        final dayName = dayNames[i]!;
        final events = eventsByDay[i] ?? [];
        
        // Urutkan berdasarkan waktu
        events.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
        
        double totalMinutes = 0;
        DateTime? currentIn;
        for (var event in events) {
          if (event.activity == 'Shift In') {
            try {
              currentIn = DateTime.parse(event.timestamp!).toLocal();
            } catch (_) {}
          } else if (event.activity == 'Shift Out' && currentIn != null) {
            try {
              final outTime = DateTime.parse(event.timestamp!).toLocal();
              totalMinutes += outTime.difference(currentIn).inMinutes;
              currentIn = null;
            } catch (_) {}
          }
        }
        
        final hours = double.parse((totalMinutes / 60.0).toStringAsFixed(1));
        totalHours += hours;
        shifts.add(ShiftData(day: dayName, hours: hours));
      }

      // 2. Parsing Meeting Data (Setiap hari Minggu di bulan ini)
      final meetingsData = meetingResponse.data ?? [];
      final List<MeetingData> meetings = [];
      
      // Ambil semua hari Minggu di bulan ini
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      final List<int> sundays = [];
      for (int day = 1; day <= lastDay; day++) {
        final dt = DateTime(now.year, now.month, day);
        if (dt.weekday == DateTime.sunday) {
          sundays.add(day);
        }
      }

      // Format nama bulan Indonesia
      const monthNames = {
        1: 'Januari',
        2: 'Februari',
        3: 'Maret',
        4: 'April',
        5: 'Mei',
        6: 'Juni',
        7: 'Juli',
        8: 'Agustus',
        9: 'September',
        10: 'Oktober',
        11: 'November',
        12: 'Desember',
      };
      final currentMonthName = monthNames[now.month] ?? '';

      // Tentukan status untuk setiap hari Minggu
      final todayDate = DateTime(now.year, now.month, now.day);
      for (var sundayDay in sundays) {
        final sundayDt = DateTime(now.year, now.month, sundayDay);
        
        // Cek apakah ada record meeting di tanggal ini
        final hasMeeting = meetingsData.any((m) {
          if (m.timestamp == null) return false;
          try {
            final mDt = DateTime.parse(m.timestamp!).toLocal();
            return mDt.year == sundayDt.year && mDt.month == sundayDt.month && mDt.day == sundayDt.day;
          } catch (_) {
            return false;
          }
        });

        String status;
        if (hasMeeting) {
          status = 'checked';
        } else {
          if (sundayDt.isAfter(todayDate)) {
            status = 'empty';
          } else {
            status = 'crossed';
          }
        }

        meetings.add(MeetingData(date: sundayDay.toString(), status: status));
      }

      emit(state.copyWith(
        status: HomeStatus.initial,
        shifts: shifts,
        totalHours: double.parse(totalHours.toStringAsFixed(1)),
        meetings: meetings,
        currentMonthName: currentMonthName,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Gagal memuat data dashboard: $e',
      ));
    }
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

