import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/resources/app_navigation.dart';
import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/storge/storge_helper.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:dio/dio.dart';

class DioClient {
  late Dio _dio;

  Dio get dio => _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.100.127:8000/api',
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  // ============= Request Interceptor =============

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = services<StorageHelper>();
    final token = await storage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  // ============= Error Interceptor =============

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Skip refresh logic for the refresh endpoint itself
    if (error.requestOptions.path.contains('generateAccessToken')) {
      return handler.reject(error);
    }

    // Check if this is a token expiration error
    if (!_isTokenExpiredError(error)) {
      return handler.reject(error);
    }

    // Attempt to refresh the token and retry
    await _refreshTokenAndRetry(error, handler);
  }

  // ============= Token Validation =============

  bool _isTokenExpiredError(DioException error) {
    if (error.response == null) return false;

    final statusCode = error.response!.statusCode;
    if (statusCode != 401 && statusCode != 400) return false;

    final data = error.response!.data;

    // Check for expired token in various formats
    if (data is Map) {
      // Check error array
      if (data["error"] is List) {
        final errors = List<String>.from(data["error"]);
        return errors.any((e) => e.toLowerCase().contains("expired"));
      }

      // Check message field
      if (data["message"] is String) {
        return data["message"].toString().toLowerCase().contains("expired");
      }
    }

    return false;
  }

  // ============= Token Refresh Logic =============

  Future<void> _refreshTokenAndRetry(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final storage = services<StorageHelper>();
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null) {
        await _handleSessionExpired();
        return handler.reject(error);
      }

      // Attempt token refresh
      final response = await Dio().post(
        'http://192.168.100.127:8000/api/generateAccessToken',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'refresh_token': refreshToken,
          },
        ),
      );

      final newAccessToken = response.data['access_token'];
      await storage.saveAccessToken(newAccessToken);

      // Retry original request
      final originalRequest = error.requestOptions;
      originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

      if (originalRequest.data is FormData) {
        originalRequest.data = _cloneFormData(originalRequest.data);
      }

      final retryResponse = await _dio.fetch(originalRequest);
      return handler.resolve(retryResponse);
    } catch (e) {
      await _handleSessionExpired();
      return handler.reject(error);
    }
  }

  // ============= FormData Handling =============

  FormData _cloneFormData(FormData original) {
    final cloned = FormData();

    // Copy fields
    for (final field in original.fields) {
      cloned.fields.add(MapEntry(field.key, field.value));
    }

    // Copy files
    for (final file in original.files) {
      cloned.files.add(MapEntry(file.key, file.value.clone()));
    }

    return cloned;
  }

  // ============= Session Management =============

  Future<void> _handleSessionExpired() async {
    final storage = services<StorageHelper>();
    await storage.clearAll();

    final context = AppNavigation.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      AppSnackBar.showError(
        context,
        message: "Session expired. Please login again.",
      );
    }

    AppNavigation.pushAndRemoveUntil(RoutesNames.login);
  }
}
