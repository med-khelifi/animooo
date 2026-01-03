import 'package:animooo/core/network/api_error.dart';
import 'package:animooo/core/network/api_exceptions.dart';
import 'package:animooo/core/network/api_methods.dart';
import 'package:animooo/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class ApiService extends ApiMethods {
  final DioClient _dioClient ;
  ApiService({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<dynamic> get({required String endpoint,Map<String,dynamic>? queryParams}) async {
    try {
      final response = await _dioClient.dio.get(endpoint,queryParameters: queryParams,);
      return response;
    } on DioException catch (e) {
      return ApiExceptions.handleException(e);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<dynamic> post({dynamic data, required String endpoint}) async {
    try {
      final response = await _dioClient.dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      return ApiExceptions.handleException(e);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<dynamic> put({dynamic data, required String endpoint}) async {
    try {
      final response = await _dioClient.dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      return ApiExceptions.handleException(e);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<dynamic> delete({
    required String endpoint,
    Map<String, dynamic>? data,
    dynamic query,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        endpoint,
        data: data,
        queryParameters: query,
      );
      return response;
    } on DioException catch (e) {
      return ApiExceptions.handleException(e);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }
}
