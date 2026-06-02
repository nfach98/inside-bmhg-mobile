import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/config/api_urls.dart';
import 'package:inside_bmhg/data/models/response_activity.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@injectable
class ActivityRepository {
  final SharedPrefHelper spHelper;
  final Dio dio;

  const ActivityRepository({required this.spHelper, required this.dio});

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<ResponseActivity> createactivity(
    String activity,
    String userLat,
    String userLon,
  ) async {
    try {
      final token = spHelper.getToken();
      final response = await dio.post(
        ApiUrls.createActivity,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'activity': activity, 'user_lat': userLat, 'user_lon': userLon},
      );
      final responseData = response.data;
      return ResponseActivity.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  Future<ResponseActivity> getShifts(
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    try {
      final token = spHelper.getToken();
      final response = await dio.get(
        ApiUrls.getShifts,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          if (startDate != null) 'start_date': _formatDate(startDate),
          if (endDate != null) 'end_date': _formatDate(endDate),
        },
      );
      final responseData = response.data;
      return ResponseActivity.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to get shifts: $e');
    }
  }

  Future<ResponseActivity> getMeetings(
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    try {
      final token = spHelper.getToken();
      final response = await dio.get(
        ApiUrls.getMeetings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          if (startDate != null) 'start_date': _formatDate(startDate),
          if (endDate != null) 'end_date': _formatDate(endDate),
        },
      );
      final responseData = response.data;
      return ResponseActivity.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to get meetings: $e');
    }
  }
}
