import 'package:dio/dio.dart';
import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/datasources/local/auth_local_datasource.dart';
import 'package:sellerproof/data/datasources/remote/api_client.dart';
import 'package:sellerproof/data/models/api_models.dart';
import 'package:sellerproof/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._apiClient, this._localDataSource);

  @override
  Future<Result<UserInfo, String>> login(String email, String password) async {
    try {
      final response = await _apiClient.login(
        LoginRequest(email: email, password: password),
      );
      await _localDataSource.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      return Success(response.user);
    } catch (e) {
      return Failure(_handleError(e));
    }
  }

  @override
  Future<Result<void, String>> register(RegisterRequest request) async {
    try {
      await _apiClient.register(request);
      return const Success(null);
    } catch (e) {
      return Failure(_handleError(e));
    }
  }

  @override
  Future<Result<void, String>> verifyEmail(String email, String code) async {
    try {
      final response = await _apiClient.verifyEmail(
        VerifyEmailRequest(email: email, code: code),
      );
      if (response.success) {
        return const Success(null);
      } else {
        return Failure(response.message);
      }
    } catch (e) {
      return Failure(_handleError(e));
    }
  }

  @override
  Future<Result<UserInfo?, String>> getCachedUser() async {
    try {
      final user = await _localDataSource.getUser();
      return Success(user);
    } catch (e) {
      return Failure(_handleError(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.clearTokens();
    } catch (_) {}
  }

  String _handleError(Object e) {
    if (e is DioException) {
      if (e.response?.statusCode == 502) {
        return 'Сервер временно недоступен. Попробуйте позже.';
      }
      final data = e.response?.data;
      if (data != null && data is Map) {
        if (data['message'] != null) return data['message'].toString();
        if (data['error'] != null) return data['error'].toString();
      }
      return e.message ?? e.toString();
    }
    return e.toString();
  }
}
