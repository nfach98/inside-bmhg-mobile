import 'package:flutter/foundation.dart';
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

  HomeBloc(this._authRepository, this._activityRepository)
    : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<HomeLogoutEvent>(_onHomeLogout);
    on<HomeFetchDataEvent>(_onFetchData);
    on<HomeRefreshEvent>(_onRefresh);
  }

  // ─── Initial ──────────────────────────────────────────────────────────────

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) {
    add(HomeFetchDataEvent());
  }

  // ─── Fetch & Refresh ──────────────────────────────────────────────────────

  Future<void> _onFetchData(
    HomeFetchDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _fetchData(emit);
  }

  Future<void> _onRefresh(
    HomeRefreshEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<HomeState> emit) async {
    try {
      final now = DateTime.now();

      // Rentang minggu ini (Senin–Jumat)
      final senin = now.subtract(Duration(days: now.weekday - 1));
      final jumat = senin.add(const Duration(days: 4));
      final awalMinggu = DateTime(senin.year, senin.month, senin.day);
      final akhirMinggu = DateTime(
        jumat.year,
        jumat.month,
        jumat.day,
        23,
        59,
        59,
      );

      // Rentang bulan ini
      final awalBulan = DateTime(now.year, now.month, 1);
      final akhirBulan = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      // Panggil kedua API bersamaan
      final results = await Future.wait([
        _activityRepository.getShifts(awalMinggu, akhirMinggu),
        _activityRepository.getMeetings(awalBulan, akhirBulan),
      ]);

      final shifts = _mapShifts(results[0].data ?? []);
      final meetings = _mapMeetings(results[1].data ?? []);

      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          shiftMingguIni: _hitungTotalShift(shifts),
          shifts: shifts,
          weeklyMeetingBulan: _namaBulan(now.month),
          meetings: meetings,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Gagal memuat data. Silakan coba lagi.',
        ),
      );
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> _onHomeLogout(
    HomeLogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await _authRepository.logout();
      emit(state.copyWith(status: HomeStatus.logoutSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Gagal melakukan logout. Silakan coba lagi.',
        ),
      );
    }
  }

  // ─── Helper: Mapping Shift ────────────────────────────────────────────────
  //
  // Logika:
  //   API mengirim pasangan "Shift-In" & "Shift-Out" per sesi kerja.
  //   Kita kelompokkan per hari, pasangkan In–Out, lalu hitung selisih jamnya.
  //
  //   Contoh response:
  //     { activity: "Shift-In",  timestamp: "2026-05-04 12:12:06" }
  //     { activity: "Shift-Out", timestamp: "2026-05-04 14:45:40" }
  //   → Senin: 2.55 jam  (14:45 - 12:12 = 2j 33m)

  List<ShiftData> _mapShifts(List<dynamic> dataList) {
    const urutan = ['Senin', 'Selasa', 'Rabu', 'Kamis', "Jum'at"];

    // Akumulasi total jam per hari
    final Map<String, double> totalJam = {for (final h in urutan) h: 0.0};

    // Kelompokkan semua record berdasarkan tanggal (yyyy-MM-dd)
    final Map<String, List<dynamic>> perTanggal = {};
    for (final item in dataList) {
      if (item.timestamp == null) continue;
      final dt = DateTime.tryParse(item.timestamp!);
      if (dt == null) continue;
      final key =
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      perTanggal.putIfAbsent(key, () => []).add(item);
    }

    // Per tanggal: pasangkan Shift-In dengan Shift-Out
    for (final entry in perTanggal.entries) {
      final records = entry.value;

      // Ambil semua timestamp Shift-In dan Shift-Out
      final shiftIns =
          records
              .where((r) => r.activity == 'Shift-In')
              .map((r) => DateTime.tryParse(r.timestamp!))
              .whereType<DateTime>()
              .toList()
            ..sort();

      final shiftOuts =
          records
              .where((r) => r.activity == 'Shift-Out')
              .map((r) => DateTime.tryParse(r.timestamp!))
              .whereType<DateTime>()
              .toList()
            ..sort();

      // Pasangkan In[0]→Out[0], In[1]→Out[1], dst
      final pasangan = shiftIns.length < shiftOuts.length
          ? shiftIns.length
          : shiftOuts.length;

      double totalHariIni = 0;
      for (int i = 0; i < pasangan; i++) {
        final durasi = shiftOuts[i].difference(shiftIns[i]);
        // Hanya hitung jika Out > In (validasi data)
        if (durasi.isNegative) continue;
        totalHariIni += durasi.inMinutes / 60.0;
      }

      if (totalHariIni == 0) continue;

      // Tentukan nama hari dari tanggal
      final dt = DateTime.tryParse(entry.key);
      final nama = dt != null ? _namaHari(dt.weekday) : null;
      if (nama == null) continue;

      totalJam[nama] = (totalJam[nama] ?? 0) + totalHariIni;
    }

    return urutan.map((h) => ShiftData(day: h, hours: totalJam[h]!)).toList();
  }

  // ─── Helper: Mapping Meeting ──────────────────────────────────────────────
  //
  // Sesuaikan nilai activity di sini jika API meeting berbeda dari shift.
  // Saat ini mengikuti pola yang sama: 'Shift-In' / 'Shift-Out'
  // Ubah jika endpoint getMeetings mengembalikan nilai berbeda.

  List<MeetingData> _mapMeetings(List<dynamic> dataList) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    // Cari semua hari Senin di bulan ini
    final List<DateTime> mondays = [];
    // Mulai dari tanggal 1 bulan ini
    DateTime temp = DateTime(year, month, 1);
    // Cari Senin pertama
    while (temp.weekday != DateTime.monday) {
      temp = temp.add(const Duration(days: 1));
    }
    // Tambahkan semua Senin di bulan ini
    while (temp.month == month) {
      mondays.add(DateTime(temp.year, temp.month, temp.day));
      temp = temp.add(const Duration(days: 7));
    }

    // Kelompokkan dataList berdasarkan hari (dd)
    final Set<int> attendedDays = {};
    for (final item in dataList) {
      if (item.timestamp == null) continue;
      final dt = DateTime.tryParse(item.timestamp!);
      if (dt == null) continue;
      // Pastikan tahun dan bulan sama (antisipasi jika data API meluber)
      if (dt.year == year && dt.month == month) {
        attendedDays.add(dt.day);
      }
    }

    // Bandingkan setiap Senin dengan hari ini untuk menentukan status
    final todayStart = DateTime(now.year, now.month, now.day);

    return mondays.map((monday) {
      final dateStr = monday.day.toString();
      if (attendedDays.contains(monday.day)) {
        return MeetingData(date: dateStr, status: 'checked');
      } else if (monday.isBefore(todayStart)) {
        return MeetingData(date: dateStr, status: 'crossed');
      } else {
        return MeetingData(date: dateStr, status: 'empty');
      }
    }).toList();
  }

  // ─── Helper: Format & Nama ────────────────────────────────────────────────

  /// Ubah total jam (double) → "5 jam 33 menit"
  String _hitungTotalShift(List<ShiftData> shifts) {
    final total = shifts.fold(0.0, (sum, s) => sum + s.hours);
    final jam = total.toInt();
    final menit = ((total - jam) * 60).round();
    if (menit == 0) return '$jam jam';
    return '$jam jam $menit menit';
  }

  String? _namaHari(int weekday) {
    const map = {1: 'Senin', 2: 'Selasa', 3: 'Rabu', 4: 'Kamis', 5: "Jum'at"};
    return map[weekday];
  }

  String _namaBulan(int bulan) {
    const nama = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return nama[bulan];
  }
}
