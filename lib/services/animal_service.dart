import 'package:animooo/core/network/api_error.dart';
import 'package:animooo/core/network/api_service.dart';
import 'package:animooo/core/requests/create_animal_request.dart';
import 'package:animooo/core/requests/update_animal_request.dart';
import 'package:animooo/core/response/response.dart';
import 'package:animooo/models/animal_model.dart';

class AnimalService {
  final ApiService _apiService;

  AnimalService({required ApiService apiService}) : _apiService = apiService;

  /// Create a new animal
  Future<Response<AnimalModel>> registerNewAnimal({
    required CreateNewAnimalRequest createAnimalRequest,
  }) async {
    try {
      var result = await _apiService.post(
        endpoint: '/createNewAnimal',
        data: await createAnimalRequest.toFormData(),
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

      // extract animal data
      final animalData = data["Animal"];

      if (animalData == null || animalData is! Map) {
        return Response.failure(ApiError(message: "Invalid animal object"));
      }

      final animal = AnimalModel.fromJson(animalData as Map<String, dynamic>);

      return Response.success(animal, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }

  /// Update an existing animal
  Future<Response<AnimalModel>> updateAnimal({
    required UpdateAnimalRequest updateAnimalRequest,
  }) async {
    try {
      var result = await _apiService.post(
        endpoint: '/updateAnimal',
        data: await updateAnimalRequest.toFormData(),
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

      // extract animal data
      final animalData = data["Animal"];

      if (animalData == null || animalData is! Map) {
        return Response.failure(ApiError(message: "Invalid animal object"));
      }

      final animal = AnimalModel.fromJson(animalData as Map<String, dynamic>);

      return Response.success(animal, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }

  /// Get all animals
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

      // Extract animals data
      final animalsData = data["Animals"];

      // Check if it's a List
      if (animalsData == null || animalsData is! List) {
        return Response.failure(ApiError(message: "Invalid animal data"));
      }

      // Map the list to AnimalModel objects
      final animals = (animalsData as List)
          .map((e) => AnimalModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Response.success(animals, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }

  /// Delete an animal by ID
  Future<Response<bool>> deleteAnimal({required int id}) async {
    try {
      var result = await _apiService.delete(
        endpoint: '/deleteAnimal',
        query: {'id': id},
      );

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

      return Response.success(true, alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }
}
