import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sellerproof/core/config/app_config.dart';
import 'package:sellerproof/core/network/auth_interceptor.dart';
import 'package:sellerproof/data/datasources/local/auth_local_datasource.dart';
import 'package:sellerproof/data/datasources/remote/api_client.dart';
import 'package:sellerproof/data/repositories/auth_repository_impl.dart';
import 'package:sellerproof/data/repositories/video_repository_impl.dart';
import 'package:sellerproof/domain/repositories/auth_repository.dart';
import 'package:sellerproof/domain/repositories/video_repository.dart';
import 'package:sellerproof/domain/usecases/auth/get_cached_user_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/login_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/logout_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/register_usecase.dart';
import 'package:sellerproof/domain/usecases/auth/verify_email_usecase.dart';
import 'package:sellerproof/presentation/providers/auth_provider.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  sl.registerLazySingleton(() => AuthLocalDataSource(sl()));

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeout),
      ),
    );
    dio.interceptors.add(AuthInterceptor(sl(), dio));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  sl.registerLazySingleton(() => ApiClient(sl()));

  sl.registerLazySingleton<VideoRepository>(() => VideoRepositoryImpl(sl()));

  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(
    () => AuthProvider(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyEmailUseCase: sl(),
      getCachedUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}
