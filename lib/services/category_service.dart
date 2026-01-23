import 'package:animooo/core/network/api_error.dart';
import 'package:animooo/core/network/api_service.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
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
}
