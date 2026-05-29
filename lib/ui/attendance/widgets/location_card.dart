import 'package:flutter/material.dart';
import 'package:inside_bmhg/ui/attendance/bloc/attendance_state.dart';
import 'package:inside_bmhg/ui/attendance/widgets/shift_status_badge.dart';

/// Card yang menampilkan lokasi GPS saat ini beserta status shift.
class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final AttendanceState state;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EAF6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon lokasi
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Info lokasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi Saat Ini',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                if (state.isLocationLoading)
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Mendapatkan lokasi...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  )
                else if (state.locationError != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.locationError!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD93025),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onRefresh,
                        child: Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    state.locationName ?? 'Belum ada lokasi',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Badge status shift
          ShiftStatusBadge(status: state.shiftStatus),
        ],
      ),
    );
  }
}
