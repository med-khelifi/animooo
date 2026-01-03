abstract class ApiMethods {

  Future<dynamic> get({required String endpoint,Map<String,dynamic>? queryParams});

  Future<dynamic> post({required String endpoint, dynamic data});

  Future<dynamic> put({required String endpoint, dynamic data});

  Future<dynamic> delete({required String endpoint, Map<String, dynamic>? data,dynamic query}) ;
}