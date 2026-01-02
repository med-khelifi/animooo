import 'package:dio/dio.dart';

class DioClient {
  late Dio _dio;

  get dio => _dio;

  DioClient() {
   _dio = Dio(
    BaseOptions(
    baseUrl: 'http://192.168.100.127:8000/api',
    headers: {'Content-Type': 'application/json'},
    ),);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = null; //await PrefHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}