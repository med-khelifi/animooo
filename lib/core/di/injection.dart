import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../network/api_service.dart';
import '../../services/auth_service.dart';

final services = GetIt.instance;

void setupInjection() {
  services.registerLazySingleton<DioClient>(() => DioClient());

  services.registerLazySingleton<ApiService>(
    () => ApiService(dioClient: services()),
  );

  services.registerLazySingleton<AuthService>(
    () => AuthService(apiService: services()),
  );
}
