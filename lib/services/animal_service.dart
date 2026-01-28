import 'package:animooo/core/network/api_error.dart';
import 'package:animooo/core/network/api_service.dart';
import 'package:animooo/core/response/response.dart';
import 'package:animooo/models/animal_model.dart';

class AnimalService {
  AnimalService({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  Future<Response<List<AnimalModel>>> getAllAnimals() async {
    try {
      var result = await _apiService.get(endpoint: '/allAnimal');

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
      final animalsData = data["Animals"];

      // Check if it's a List (don't check the inner type yet)
      if (animalsData == null || animalsData is! List) {
        return Response.failure(ApiError(message: "Invalid animal data"));
      }

      // Map the list to CategoryModel objects
      final animals = (animalsData as List)
          .map((e) => AnimalModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Response.success(animals, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }
}
