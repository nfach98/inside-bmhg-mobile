import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:inside_bmhg/config/api_urls.dart';
import 'package:inside_bmhg/data/exceptions/api_exception.dart';
import 'package:inside_bmhg/utils/shared_pref_helper.dart';

@injectable
class AuthRepository {
  final Dio _dio;
  final SharedPrefHelper _spHelper;

  const AuthRepository({
    required Dio dio,
    required SharedPrefHelper spHelper,
  })  : _dio = dio,
        _spHelper = spHelper;

  bool isLoggedIn() {
    final token = _spHelper.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _spHelper.clearToken();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiUrls.login,
        data: FormData.fromMap({
          'email': email,
          'password': password,
        }),
      );

      final body = response.data;
      if (body == null || body['status'] != 'success') {
        throw ApiException(
          body?['message'] as String? ?? 'Login gagal',
        );
      }

      final data = body['data'] as Map<String, dynamic>?;
      final token = data?['token'] as String?;
      if (token == null || token.isEmpty) {
        throw const ApiException('Token tidak ditemukan dalam respons.');
      }

      await _spHelper.saveToken(token);
    } on DioException catch (e) {
      throw ApiException(_messageFromDio(e));
    }
  }

  String _messageFromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Koneksi timeout. Periksa jaringan Anda.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Tidak dapat terhubung ke server.';
    }
    return 'Login gagal. Coba lagi.';
  }
}
