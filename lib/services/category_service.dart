import 'package:animooo/core/network/api_error.dart';
import 'package:animooo/core/network/api_service.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
import 'package:animooo/core/requests/update_category_request.dart';
import 'package:animooo/core/response/response.dart';
import 'package:animooo/models/category_model.dart';

class CategoryService {
  final ApiService _apiService;
  CategoryService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<CategoryModel>> registerNewCategory({
    required CreateNewCategoryRequest createCategoryRequest,
  }) async {
    try {
      var result = await _apiService.post(
        endpoint: '/createNewCategory',
        data: await createCategoryRequest.toFormData(),
      );
      if (result is ApiError) {
        return Response.failure(result);
      }
      // data section from response
      final data = result.data;

      if (data == null || data is! Map) {
        return Response.failure(ApiError(message: 'Invalid backend response'));
      }
      int code = int.tryParse(data["statusCode"].toString()) ?? 500;
      if (code < 200 || code > 299) {
        return Response.failure(ApiError(message: "Unknown backend error"));
      }
      final alert = data["message"].toString();
      // extract user data
      final categoryData = data["Category"];

      if (categoryData == null || categoryData is! Map) {
        return Response.failure(ApiError(message: "Invalid category object"));
      }

      final user = CategoryModel.fromJson(categoryData as Map<String, dynamic>);

      return Response.success(user, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }

  Future<Response<CategoryModel>> updateCategory({
    required UpdateCategoryRequest updateCategoryRequest,
  }) async {
    try {
      var result = await _apiService.post(
        endpoint: '/updateCategory',
        data: await updateCategoryRequest.toFormData(),
      );
      if (result is ApiError) {
        return Response.failure(result);
      }
      // data section from response
      final data = result.data;

      if (data == null || data is! Map) {
        return Response.failure(ApiError(message: 'Invalid backend response'));
      }
      int code = int.tryParse(data["statusCode"].toString()) ?? 500;
      if (code < 200 || code > 299) {
        return Response.failure(ApiError(message: "Unknown backend error"));
      }
      final alert = data["message"].toString();
      // extract user data
      final categoryData = data["Category"];

      if (categoryData == null || categoryData is! Map) {
        return Response.failure(ApiError(message: "Invalid category object"));
      }

      final user = CategoryModel.fromJson(categoryData as Map<String, dynamic>);

      return Response.success(user, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }

  Future<Response<List<CategoryModel>>> getAllCategories() async {
    try {
      var result = await _apiService.get(endpoint: '/allCategories');

      if (result is ApiError) {
        return Response.failure(result);
      }

      // Extract data from response
      final data = result.data;

      if (data == null || data is! Map<String, dynamic>) {
        return Response.failure(ApiError(message: 'Invalid backend response'));
      }

      // Validate status code
      int code = int.tryParse(data["statusCode"].toString()) ?? 500;
      if (code < 200 || code > 299) {
        return Response.failure(ApiError(message: "Unknown backend error"));
      }

      final alert = data["message"]?.toString();

      // Extract categories data
      final categoriesData = data["Categories"];

      // Check if it's a List (don't check the inner type yet)
      if (categoriesData == null || categoriesData is! List) {
        return Response.failure(ApiError(message: "Invalid category data"));
      }

      // Map the list to CategoryModel objects
      final categories = (categoriesData as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Response.success(categories, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }
}
