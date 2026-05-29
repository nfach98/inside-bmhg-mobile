import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_bloc.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_event.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';
import 'package:inside_bmhg/ui/attendance/widgets/location_card.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<AttendanceBloc>()..add(const AttendanceInitialEvent()),
      child: const _AttendanceView(),
    );
  }
}

// ---------------------------------------------------------------------------
// View (konsumsi BLoC)
// ---------------------------------------------------------------------------

class _AttendanceView extends StatelessWidget {
  const _AttendanceView();

  static const _activities = ['Shift In', 'Shift Out'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listenWhen: (prev, curr) => prev.response != curr.response,
      listener: (context, state) {
        if (state.response.toString().isNotEmpty &&
            state.response.toString() != '') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.toString()),
              backgroundColor: const Color(0xFF1B9E4E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<AttendanceBloc>();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FD),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── App bar custom ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _UserHeader(),
                  ),
                ),

                // ── Tanggal & jam ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: _DateTimeSection(currentTime: state.currentTime),
                  ),
                ),

                // ── Lokasi & status shift ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: LocationCard(
                      state: state,
                      onRefresh:
                          () => bloc.add(
                            const AttendanceLocationRequestedEvent(),
                          ),
                    ),
                  ),
                ),

                // ── Spacer fleksibel ───────────────────────────────────────
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: SizedBox(),
                ),
              ],
            ),
          ),

          // ── Bottom area: dropdown + submit ──────────────────────────────
          bottomNavigationBar: _BottomActionArea(
            state: state,
            activities: _activities,
            onActivitySelected:
                (v) => bloc.add(AttendanceActivitySelectedEvent(v!)),
            onSubmit:
                state.selectedActivity != null && !state.isLoading
                    ? () => bloc.add(const AttendanceSubmitEvent())
                    : null,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Header: Avatar + Nama user
// ---------------------------------------------------------------------------

class _UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // Avatar
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withValues(alpha: 0.12),
          ),
          child: ClipOval(
            child: Icon(Icons.person_rounded, color: primary, size: 22),
          ),
        ),
        const SizedBox(width: 10),

        // Nama dalam pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF0FB),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Harvest Walukow',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tanggal & Jam besar
// ---------------------------------------------------------------------------

class _DateTimeSection extends StatelessWidget {
  const _DateTimeSection({required this.currentTime});

  final DateTime currentTime;

  static const _dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const _monthNames = [
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

  String get _formattedDate {
    final d = currentTime;
    final dayName = _dayNames[d.weekday - 1];
    final monthName = _monthNames[d.month - 1];
    return '$dayName, ${d.day} $monthName ${d.year}';
  }

  String get _formattedTime {
    final h = currentTime.hour.toString().padLeft(2, '0');
    final m = currentTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tanggal
        Text(
          _formattedDate,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4A6A),
          ),
        ),
        const SizedBox(height: 4),

        // Jam besar
        Text(
          _formattedTime,
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            height: 1.0,
            letterSpacing: -2,
          ),
        ),

        // Detik (kecil)
        Text(
          ':${currentTime.second.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom area: Dropdown + Submit
// ---------------------------------------------------------------------------

class _BottomActionArea extends StatelessWidget {
  const _BottomActionArea({
    required this.state,
    required this.activities,
    required this.onActivitySelected,
    required this.onSubmit,
  });

  final AttendanceState state;
  final List<String> activities;
  final ValueChanged<String?> onActivitySelected;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputDecorator(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            child: DropdownButton<String>(
              value: state.selectedActivity,
              hint: const Text('Pilih Aktivitas'),
              isExpanded: true,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              items: activities
                  .map(
                    (a) => DropdownMenuItem(
                      value: a,
                      child: Row(
                        children: [
                          Icon(
                            a == 'Shift In'
                                ? Icons.login_rounded
                                : Icons.logout_rounded,
                            size: 18,
                            color: a == 'Shift In'
                                ? const Color(0xFF1B9E4E)
                                : const Color(0xFFD93025),
                          ),
                          const SizedBox(width: 10),
                          Text(a),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onActivitySelected,
            ),
          ),

          const SizedBox(height: 12),

          // ── Tombol Submit ──────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor:
                    onSubmit != null
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  state.isLoading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                      : const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
