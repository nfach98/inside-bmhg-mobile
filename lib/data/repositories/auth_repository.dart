import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@injectable
class AuthRepository {
  final SharedPrefHelper spHelper;
  final Dio dio;

  const AuthRepository({required this.spHelper, required this.dio});
}
