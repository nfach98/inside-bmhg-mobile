import 'package:flutter/material.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';

/// Badge kecil yang menampilkan status shift.
/// - ShiftStatus.shiftIn  → label "Shift In"  dengan warna hijau
/// - ShiftStatus.shiftOut → label "Shift Out" dengan warna merah
/// - ShiftStatus.inactive → label "Tidak Aktif" dengan warna merah
class ShiftStatusBadge extends StatelessWidget {
  const ShiftStatusBadge({super.key, required this.status});

  final ShiftStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      ShiftStatus.shiftIn => (
        'Shift In',
        const Color(0xFF1B9E4E),
        Colors.white,
      ),
      ShiftStatus.shiftOut => (
        'Shift Out',
        const Color(0xFFD93025),
        Colors.white,
      ),
      ShiftStatus.inactive => (
        'Tidak Aktif',
        const Color(0xFFD93025),
        Colors.white,
      ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
