import 'package:dio/dio.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

class AuthInterceptor extends Interceptor {
  final SharedPrefHelper _sharedPrefHelper;

  AuthInterceptor(this._sharedPrefHelper);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _sharedPrefHelper.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
