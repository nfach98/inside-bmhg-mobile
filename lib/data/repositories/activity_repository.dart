import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@injectable
class ActivityRepository {
  final SharedPrefHelper spHelper;
  final Dio dio;

  const ActivityRepository({required this.spHelper, required this.dio});
}
