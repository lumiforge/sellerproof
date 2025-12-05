import 'package:dio/dio.dart';
import 'package:sellerproof/core/config/app_config.dart';
import 'package:sellerproof/data/datasources/local/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _authLocalDataSource;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._authLocalDataSource, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authLocalDataSource.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/refresh')) {
      if (_isRefreshing) {
        return handler.next(err);
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _authLocalDataSource.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.next(err);
        }

        final refreshDio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];
          await _authLocalDataSource.saveTokens(
            newAccessToken,
            newRefreshToken,
          );

          _isRefreshing = false;

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';

          final clonedRequest = await _dio.request(
            opts.path,
            options: Options(
              method: opts.method,
              headers: opts.headers,
              contentType: opts.contentType,
              responseType: opts.responseType,
            ),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );
          return handler.resolve(clonedRequest);
        }
      } catch (e) {
        await _authLocalDataSource.clearTokens();
      }
      _isRefreshing = false;
    }
    handler.next(err);
  }
}
