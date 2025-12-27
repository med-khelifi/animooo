import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../network/api_service.dart';
import '../../services/auth_service.dart';

final sl = GetIt.instance;

void setupInjection() {
  sl.registerLazySingleton<DioClient>(() => DioClient());

  sl.registerLazySingleton<ApiService>(
    () => ApiService(dioClient: sl()),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(apiService: sl()),
  );
}
