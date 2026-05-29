import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/home/bloc/home_bloc.dart';
import 'package:inside_bmhg/ui/home/bloc/home_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:go_router/go_router.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // Data dummy chart (Nantinya data ini diambil dari `state`)
          final shifts = [
            ShiftData(day: 'Senin', hours: 5),
            ShiftData(day: 'Selasa', hours: 6),
            ShiftData(day: 'Rabu', hours: 6),
            ShiftData(day: 'Kamis', hours: 4),
            ShiftData(day: "Jum'at", hours: 6),
          ];

          // Data dummy meeting (Nantinya data ini diambil dari `state`)
          final meetings = [
            MeetingData(date: '1', status: 'checked'),
            MeetingData(date: '8', status: 'crossed'),
            MeetingData(date: '15', status: 'checked'),
            MeetingData(date: '22', status: 'empty'),
            MeetingData(date: '29', status: 'empty'),
          ];

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Shift & Weekly',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 1: SHIFT MINGGU INI
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF5FA),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Shift Minggu ini',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '7 Jam',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          //chart
                          SizedBox(
                            height: 300,
                            child: SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              primaryXAxis: const CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0),
                              ),

                              series: <ColumnSeries<ShiftData, String>>[
                                ColumnSeries<ShiftData, String>(
                                  dataSource: shifts,
                                  xValueMapper: (ShiftData data, _) => data.day,
                                  yValueMapper: (ShiftData data, _) =>
                                      data.hours,
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 2: WEEKLY MEETING BULAN INI
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF5FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weekly Meeting Bulan Ini',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Maret',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: meetings.map((meeting) {
                              return _buildMeetingSquare(context, meeting);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TOMBOL PRESENSI
                    InkWell(
                      onTap: () {
                        context.go('/attendance');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Presensi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.login,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper Widget untuk membuat kotak tanggal meeting yang presisi
  Widget _buildMeetingSquare(BuildContext context, MeetingData data) {
    Color squareColor;
    Widget? icon;

    // Mengatur warna kotak dan ikon berdasarkan status data dari BLoC nantinya
    if (data.status == 'checked') {
      squareColor = Theme.of(context).colorScheme.primary;
      icon = const Icon(Icons.check, color: Colors.white, size: 20);
    } else if (data.status == 'crossed') {
      squareColor = Theme.of(context).colorScheme.primary.withOpacity(0.7);
      icon = const Icon(Icons.close, color: Colors.white, size: 20);
    } else {
      squareColor =
          Colors.grey.shade400; // Untuk tanggal yang belum lewat/kosong
      icon = null;
    }

    return Column(
      children: [
        Container(
          width:
              46, // Menentukan lebar kotak agar simetris (bukan persegi panjang melar)
          height: 46, // Menentukan tinggi kotak
          decoration: BoxDecoration(
            color: squareColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 6),
        Text(
          data.date,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Model data untuk Chart
class ShiftData {
  final String day;
  final double hours;
  ShiftData({required this.day, required this.hours});
}

// Model data untuk List Meeting
class MeetingData {
  final String date;
  final String status; // 'checked', 'crossed', atau 'empty'
  MeetingData({required this.date, required this.status});
}
