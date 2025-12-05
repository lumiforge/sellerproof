import 'package:sellerproof/core/utils/result.dart';
import 'package:sellerproof/data/models/api_models.dart';

abstract class AuthRepository {
  Future<Result<UserInfo, String>> login(String email, String password);
  Future<Result<void, String>> register(RegisterRequest request);
  Future<Result<void, String>> verifyEmail(String email, String code);
  Future<Result<UserInfo?, String>> getCachedUser();
  Future<void> logout();
}
