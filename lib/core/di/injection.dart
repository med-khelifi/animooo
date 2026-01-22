import 'package:animooo/core/storge/storge_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../services/auth_service.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

final services = GetIt.instance;

void setupInjection() {
  services.registerLazySingleton<DioClient>(() => DioClient());

  services.registerLazySingleton<ApiService>(
    () => ApiService(dioClient: services()),
  );

  services.registerLazySingleton<AuthService>(
    () => AuthService(apiService: services()),
  );
  services.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  services.registerLazySingleton<StorageHelper>(
    () => StorageHelper(services<FlutterSecureStorage>()),
  );
}
