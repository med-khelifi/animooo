import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/resources/app_navigation.dart';
import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/storge/storge_helper.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:dio/dio.dart';

class DioClient {
  late Dio _dio;
  bool _isRefreshing = false;
  final List<void Function()> _requestsToRetry = [];

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

    // If already refreshing, queue this request
    if (_isRefreshing) {
      await _queueRequest(error, handler);
      return;
    }

    // Attempt to refresh the token
    await _refreshTokenAndRetry(error, handler);
  }

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

  Future<void> _queueRequest(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Wait for token refresh to complete
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return _isRefreshing;
    });

    // Retry the request with new token
    try {
      final storage = services<StorageHelper>();
      final newAccessToken = await storage.getAccessToken();

      if (newAccessToken == null) {
        return handler.reject(error);
      }

      final originalRequest = error.requestOptions;
      originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

      if (originalRequest.data is FormData) {
        originalRequest.data = await _cloneFormData(originalRequest.data);
      }

      final retryResponse = await _dio.fetch(originalRequest);
      return handler.resolve(retryResponse);
    } catch (e) {
      return handler.reject(error);
    }
  }

  Future<void> _refreshTokenAndRetry(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    _isRefreshing = true;

    try {
      final storage = services<StorageHelper>();
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null) {
        _isRefreshing = false;
        await _handleSessionExpired(storage);
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
        originalRequest.data = await _cloneFormData(originalRequest.data);
      }

      final retryResponse = await _dio.fetch(originalRequest);
      _isRefreshing = false;
      return handler.resolve(retryResponse);
    } catch (e) {
      _isRefreshing = false;
      final storage = services<StorageHelper>();
      await _handleSessionExpired(storage);
      return handler.reject(error);
    }
  }

  Future<void> _handleSessionExpired(StorageHelper storage) async {
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

  Future<FormData> _cloneFormData(FormData original) async {
    final newFormData = FormData();

    // Copy fields
    newFormData.fields.addAll(original.fields);

    // Copy files
    for (final mapFile in original.files) {
      final multipartFile = mapFile.value;

      // Create new MultipartFile from stream
      newFormData.files.add(
        MapEntry(
          mapFile.key,
          MultipartFile.fromStream(
            () => multipartFile.finalize(),
            multipartFile.length,
            filename: multipartFile.filename,
            contentType: multipartFile.contentType,
          ),
        ),
      );
    }

    return newFormData;
  }
}
