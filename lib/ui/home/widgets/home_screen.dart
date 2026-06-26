import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/home/bloc/home_bloc.dart';
import 'package:inside_bmhg/ui/home/bloc/home_event.dart';
import 'package:inside_bmhg/ui/home/bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _brandNavy = Color(0xFF1A2185);
  static const Color _pureBlack = Color(0xFF000000);

  // ─── Dialog & SnackBar (tidak berubah) ──────────────────────────────────

  void _showLogoutDialog(BuildContext context, HomeBloc bloc) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red.shade600,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Konfirmasi Keluar',
                  style: TextStyle(
                    fontFamily: 'Archivo',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _pureBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apakah Anda yakin ingin keluar dari aplikasi InsideBMHG?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Archivo',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontFamily: 'Archivo',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          bloc.add(HomeLogoutEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontFamily: 'Archivo',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(HomeInitialEvent()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.logoutSuccess) {
            context.go('/login');
          } else if (state.status == HomeStatus.failure) {
            _showSnackBar(context, state.errorMessage ?? 'Terjadi kesalahan');
          }
        },
        builder: (context, state) {
          final bloc = context.read<HomeBloc>();
          final isLoading = state.status == HomeStatus.loading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => bloc.add(HomeRefreshEvent()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──────────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Riwayat Shift & Weekly',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _brandNavy,
                            ),
                          ),
                          IconButton(
                            icon: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.redAccent,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.redAccent,
                                  ),
                            onPressed: isLoading
                                ? null
                                : () => _showLogoutDialog(context, bloc),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Card Shift ───────────────────────────────────────
                      _ShiftCard(state: state),
                      const SizedBox(height: 16),

                      // ── Card Weekly Meeting ──────────────────────────────
                      _MeetingCard(state: state),
                      const SizedBox(height: 20),

                      // ── Tombol Presensi ──────────────────────────────────
                      _PresensiButton(onTap: () => context.go('/attendance')),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Card Shift ───────────────────────────────────────────────────────────────

class _ShiftCard extends StatelessWidget {
  final HomeState state;
  const _ShiftCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        state.status == HomeStatus.loading ||
        state.status == HomeStatus.initial;

    return Container(
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

          // Total jam — skeleton saat loading
          isLoading
              ? _SkeletonBox(width: 140, height: 28)
              : Text(
                  state.shiftMingguIni,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

          const SizedBox(height: 16),

          // Chart — skeleton saat loading
          isLoading
              ? const _SkeletonBox(width: double.infinity, height: 180)
              : SizedBox(
                  height: 180,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    margin: EdgeInsets.zero,
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 11),
                    ),
                    primaryYAxis: const NumericAxis(isVisible: false),
                    series: <ColumnSeries<ShiftData, String>>[
                      ColumnSeries<ShiftData, String>(
                        dataSource: state.shifts,
                        xValueMapper: (d, _) => d.day,
                        yValueMapper: (d, _) => d.hours,
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Card Weekly Meeting ──────────────────────────────────────────────────────

class _MeetingCard extends StatelessWidget {
  final HomeState state;
  const _MeetingCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        state.status == HomeStatus.loading ||
        state.status == HomeStatus.initial;

    return Container(
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

          isLoading
              ? const _SkeletonBox(width: 80, height: 24)
              : Text(
                  state.weeklyMeetingBulan,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

          const SizedBox(height: 16),

          isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (_) => const _SkeletonBox(width: 46, height: 46),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: state.meetings
                      .map((m) => _MeetingSquare(data: m))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

// ─── Kotak meeting ────────────────────────────────────────────────────────────

class _MeetingSquare extends StatelessWidget {
  final MeetingData data;
  const _MeetingSquare({required this.data});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    Color squareColor;
    Widget? icon;

    if (data.status == 'checked') {
      squareColor = primary;
      icon = const Icon(Icons.check, color: Colors.white, size: 20);
    } else if (data.status == 'crossed') {
      squareColor = primary.withOpacity(0.7);
      icon = const Icon(Icons.close, color: Colors.white, size: 20);
    } else {
      squareColor = Colors.grey.shade400;
      icon = null;
    }

    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
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

// ─── Tombol Presensi ──────────────────────────────────────────────────────────

class _PresensiButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PresensiButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              child: const Icon(Icons.login, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skeleton loading ─────────────────────────────────────────────────────────

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
