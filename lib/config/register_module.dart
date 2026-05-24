import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inside_bmhg/config/api_urls.dart';
import 'package:inside_bmhg/config/auth_interceptor.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio dio(SharedPrefHelper sharedPrefHelper) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.BASE_URL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(AuthInterceptor(sharedPrefHelper));
    return dio;
  }
}
